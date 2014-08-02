Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbaHBOuM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 10:50:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47633 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754477AbaHBOuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 10:50:05 -0400
Date: Sat, 2 Aug 2014 16:49:25 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        laurent.pinchart@ideasonboard.com, ludovic.desroches@atmel.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] Documentation: dmaengine: Add a documentation for the
 dma controller API
Message-ID: <20140802144925.GJ3952@lukather>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140730160607.GM8181@intel.com>
 <20140731074440.GY3952@lukather>
 <20140731115628.GQ8181@intel.com>
 <20140731162330.GE3952@lukather>
 <20140801171306.GF8181@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bsy/rPjPw3Zgz4JZ"
Content-Disposition: inline
In-Reply-To: <20140801171306.GF8181@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bsy/rPjPw3Zgz4JZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 01, 2014 at 10:43:06PM +0530, Vinod Koul wrote:
> On Thu, Jul 31, 2014 at 06:23:30PM +0200, Maxime Ripard wrote:
> > On Thu, Jul 31, 2014 at 05:26:28PM +0530, Vinod Koul wrote:
> >=20
> > Also, feel free to add anything that you feel like you keep saying
> > during the review. If mistakes keep coming, it's probably worth
> > documenting what you expect.
> I think the common issues seen would be:
> - prpeare calls in atomic context and usuage of GFP_NOWAIT for memory
>   allocations

I think we have that part covered already.

> - residue callculation, though situation is much better now but still lots
>   of driver do it worng and folks do get it wrong

What mistake in often made regarding the residue calculation?

> > > > Because, for the moment, we're pretty much left in the dark with
> > > > different drivers doing the same thing in completetely different wa=
ys,
> > > > with basically no way to tell if it's either the framework that
> > > > requires such behaviour, or if the author was just feeling creative.
> > > >=20
> > > > There's numerous examples for this at the moment:
> > > >   - The GFP flags, with different drivers using either GFP_ATOMIC,
> > > >     GFP_NOWAIT or GFP_KERNEL in the same functions
> > > >   - Having to set device_slave_caps or not?
> > > >   - Some drivers use dma_run_depedencies, some other don't
> > > >   - That might just be my experience, but judging from previous
> > > >     commits, DMA_PRIVATE is completely obscure, and we just set it
> > > >     because it was making it work, without knowing what it was
> > > >     supposed to do.
> > > >   - etc.
> > >=20
> > > Thanks for highlighting we should definitely add these in Documentati=
on
> >=20
> > It's quite clear in the case of the GFP flags now, Lars-Peter and you
> > cleared up device_slave_caps, but I still could use some help with
> > DMA_PRIVATE.
> >=20
> > > > And basically, we have no way to tell at the moment which one is
> > > > right and which one needs fixing.
> > > >=20
> > > > The corollary being that it cripples the whole community ability to
> > > > maintain the framework and make it evolve.
> > > >=20
> > > > > > +  * device_slave_caps
> > > > > > +    - Isn't that redundant with the cap_mask already?
> > > > > > +    - Only a few drivers seem to implement it
> > > > > For audio to know what your channel can do rather than hardcoding=
 it
> > > >=20
> > > > Ah, yes, I see it now. It's not related to the caps mask at all.
> > > >=20
> > > > Just out of curiosity, wouldn't it be better to move this to the
> > > > framework, and have these informations provided through the struct
> > > > dma_device? Or would it have some non-trivial side-effects?
> > > Well the problem is ability to have this queried uniformly from all d=
rivers
> > > across subsystems. If we can do this that would be nice.
> >=20
> > I can work on some premelinary work to do just that, and see if it
> > works for you then.
> Sure sounds excellent to me

Another extra questions arose during starting this.

In the case of the call to device_control, especially in the
DMA_SLAVE_CONFIG case, but that also applies to pause/resume, are the
changes supposed to be immediates or can they happen later?

I actually have in mind the case where we would use a vchan, that
might or might not be actually mapped to a physical channel at the
moment where the DMA_SLAVE_CONFIG call is made. In the case where it's
not mapped and not transfering anything, it's pretty trivial, to
handle, but in the case where it's actually mapped to a physical
channel, should we push the new configuration to the physical channel
right away, or can it wait until the transfer ends ?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Bsy/rPjPw3Zgz4JZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT3Pp1AAoJEBx+YmzsjxAgLA4QAJuiBcIa3lxnybFgdYgjnAwY
YzD0LEtnFKuzWFn7E6Hi86hf6vdtntJUeGHvN6mtQ87s6ph5NcP7r0QKHZDPJruZ
L9TTcpywfTuLos6XgQHZOOTj4UFXnKyuRMdOPL4/attC4ndXn/praNXUhlZV4LN+
2fqF168De3jSxvKTAievNMwTscryENrkTa6qV8TZqmj7kLxGNeQtht0ik/JaF48d
rIhYzxQES+TlDVMOmpIABgx1VqOB9Pg7DEDQcIzl5ihTr60gAwSoYgFuaMlpCdrc
+H3dGu23il0oIhtQrPvOWgIcSfuOSRxrUJ6DOcY4TyEnUcYBIDzkRzS1LorOEo+U
FdgpkH0estKspoTcKWeUxn9leWEzS/ZaGfvtuqPfSAR0aiCe5TvNhAGJtINnjzvO
5hfc5I1GZDtHgfGEzV1RTC4ZXd+PPG2uU5igm7tzlQvGsX3UmrdeMFqenTxVdI/y
XTx7IsQBarK7ayilW6EMfnoZdcnhL0nEBcBFykZkguyF6y2aq7QCE22OyRP1YCx/
zLerdc/W1bSTiElyKmsABLL8vuISjcIIIPgAjtuREeqzwPO1qtVVLQ3nAsty9Fj3
cWyhtAQE4Ou3xOJWNqA45HvbF6jNGdBvt5/NSeAA6W+gHlGWzR1TbB1MCRAEByhN
Hh4hxVzDdxiOMetifkqA
=L9dC
-----END PGP SIGNATURE-----

--Bsy/rPjPw3Zgz4JZ--
