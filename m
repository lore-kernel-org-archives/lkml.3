Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbaJXTni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 15:43:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43215 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745AbaJXTng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:43:36 -0400
Date: Fri, 24 Oct 2014 14:42:50 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: remove redundant irq disable at halt and restart
Message-ID: <20141024194250.GF11455@saruman>
Reply-To: <balbi@ti.com>
References: <1414177592-14547-1-git-send-email-johan@kernel.org>
 <20141024191627.GA11455@saruman>
 <20141024192111.GC11455@saruman>
 <20141024192845.GC19377@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E69HUUNAyIJqGpVn"
Content-Disposition: inline
In-Reply-To: <20141024192845.GC19377@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--E69HUUNAyIJqGpVn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2014 at 09:28:45PM +0200, Johan Hovold wrote:
> On Fri, Oct 24, 2014 at 02:21:11PM -0500, Felipe Balbi wrote:
> > On Fri, Oct 24, 2014 at 02:16:27PM -0500, Felipe Balbi wrote:
> > > On Fri, Oct 24, 2014 at 09:06:32PM +0200, Johan Hovold wrote:
> > > > Remove redundant local_irq_disable() at machine halt and restart.
> > > >=20
> > > > Since commit 44424c34049f ("ARM: 7803/1: Fix deadlock scenario with
> > > > smp_send_stop()") interrupts are disabled before stopping secondary
> > > > CPUs.
> > >=20
> > > Assuming this is correct, you should have:
> > >=20
> > > Fixes: 44424c3 (ARM: 7803/1: Fix deadlock scenario with smp_send_stop=
())
> > > Cc: <stable@vger.kernel.org> # v3.12+
>=20
> It's not a bug. Just a redundant disabling of already disabled
> interrupts, something which could possibly lead someone to believe that
> interrupts could be re-enabled by the power-off handler.

I didn't dig any of this out but I'll assume you did :-) So I withdraw
my comment ;-)

> > > > diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> > > > index a35f6ebbd2c2..5663ab57cf07 100644
> > > > --- a/arch/arm/kernel/process.c
> > > > +++ b/arch/arm/kernel/process.c
> > > > @@ -195,7 +195,6 @@ void machine_halt(void)
> > > >  	local_irq_disable();
> > > >  	smp_send_stop();
> > > > =20
> > > > -	local_irq_disable();
> > > >  	while (1);
> > > >  }
> > > > =20
> > > > @@ -237,7 +236,6 @@ void machine_restart(char *cmd)
> > > > =20
> > > >  	/* Whoops - the platform was unable to reboot. Tell the user! */
> > > >  	printk("Reboot failed -- System halted\n");
> > > > -	local_irq_disable();
> > >=20
> > > ... but wouldn't this reintroduce the the buck which that commit fixe=
d ?
> >=20
> > s/buck/bug :-) my fingers have a mind of their own, aparently.
>=20
> :)
>=20
> No, the interrupts would still be disabled.

alright... so far I couldn't find where IRQs are disable before
machine_power_off() is called. Starting a do_poweroff(), couldn't find
it... Oh well, I'll keep digging.

cheers

--=20
balbi

--E69HUUNAyIJqGpVn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSqu5AAoJEIaOsuA1yqREpWgP/RLu8bLHDu1TfYg36aXH9OJE
rXeXZI6yP27SrzEzIIEoIPrqyrYxcyX0bo+n/T8dnB42jEdSgc/MbMkIAiS0Cu3q
TDyzimTUAV/ys9Ngbq7cjhBguruubvAwG8YF/1ZIx3ic+0jaE3ee9OdP4OOeESdG
GlQs3oLLfaasUP4XAWzDCJ0HoUAr6a0G+RNoSa0JFY/9cQsAQbOiu7Y19oAA93FC
ugyfakc6DchzX6/O6ldo68SoEHlRA/JYiIg67m4vyAU06O7nC5SwOgKAUyu8IZhC
DUKsbPMyKX+QHD95rfG2gJN/y7sk+QWti+ebOBcixJBT1QhXbdstCrCKQcl7wTnw
7CHu7UBmcEAkTWlh2qjTCbvXra9f45XwLEOcW+YhR2MrDITSKvf7In2Tb2p6CKNl
9PiZyqR/JBFhwgRb8iJqYAvLxRaLzBAHMLmRsE5tDsoOjPhTLj+TRd5Og5CtWLt2
FCc6yNce5kWngDA9oRoTFoqttEABy8OSA8YxxeLVinJfBo/sGuZSOHWdKvNY9Anz
i/5UsJ581ax8/WVl6aambOJVdXypKnG+xIu7br3yw3jQiM9KsRQuMkTQJB7LShAu
J2dStRQ1IjrXRENK3QmrdpNTejzvtRnVnwO6Fx/iEqxJlNVg+aM7lCfnXkbdnFNc
XkogukZWf1V9NNRvlxWO
=rH5H
-----END PGP SIGNATURE-----

--E69HUUNAyIJqGpVn--
