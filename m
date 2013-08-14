Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414Ab3HNXWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 19:22:44 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42792 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361Ab3HNXWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 19:22:42 -0400
Date: Thu, 15 Aug 2013 00:22:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, tobetter@gmail.com, patches@linaro.org
Message-ID: <20130814232237.GR2401@sirena.org.uk>
References: <1376476171-19072-1-git-send-email-tushar.behera@linaro.org>
 <20130814182239.GC23847@kroah.com>
 <20130814190410.GO2401@sirena.org.uk>
 <20130814191513.GA24873@kroah.com>
 <20130814193950.GQ2401@sirena.org.uk>
 <20130814194744.GA28373@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jPC/Tkukgh9ZDT79"
Content-Disposition: inline
In-Reply-To: <20130814194744.GA28373@kroah.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] usb: misc: usb3503: Force late initialization
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jPC/Tkukgh9ZDT79
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 14, 2013 at 12:47:44PM -0700, Greg KH wrote:
> On Wed, Aug 14, 2013 at 08:39:50PM +0100, Mark Brown wrote:

> > That resource is the USB bus I think (I suspect the issue is that the
> > fact that power is always present confuses the USB enumeration protocol
> > if the device gets brought out of reset prior to the bus being live).

> Which USB bus is it?  How is this device even probed before the device
> is found by the bus?

> Ah crud, this is an i2c driver, not a USB driver, no wonder I'm
> confused...

Well, in this case it's actually only got the GPIOs wired up so
fortunately we don't care about the I2C case.  This was why I did all
that stuff with the platform device - it was only once I'd done that
that I realised that it wasn't enough just to set the GPIOs but that
they needed to be set at a particular time.  Having to cope with I2C
would indeed be a pain and it's one that I'm not even trying to confront
right now.

> You are going to have to find some kind of relationship here, not just
> by linker order, otherwise you are going to have problems later on.

Oh, clearly - it's not a solution, it's just a really cheap workaround.

> > The normal way to grab that resource would be to make the device a
> > device on the bus but currently the only way USB gets children is via
> > USB enumeration.

> Perhaps make this device a child of the USB controller in the DT
> description?

Yeah, that's the ideal thing and one of the cases I'm thinking of with
the whole thing about telling buses that they have children with device
data before the devices get probed.  People probably also want this to
work for ACPI, or at least would find it convenient to have that - I
first looked at USB due to chatting to one those guys.

> > Right, and I did discuss that with Tushar elsehwere prior to this being
> > posted here.  We figured given how cheap and non-invasive the workaround
> > is it was worth just doing it.

> Nope, sorry, I'm not going to take it.

Fair enough, that was my first reaction to it too but we figured it was
worth considering.

> > > So this patch wouldn't really solve the problem, only paper over it for
> > > one type of configuration (i.e. driver built into the system), right?

> > Yes, though realistically nobody actually does that for the relevant
> > systems and if they do it's always possible to control the module load
> > order if you really want to.

> But you aren't telling anyone that is what is needed.  How would anyone
> know that they need to control the load order?

By debugging it and finding the late initcall.  Worst case it'd work
just as well as it does now, best case it might do better until the
problem actually gets fixed.

Like I say for all practical purposes nobody does that, everyone running
these boards builds everything into the kernel - that's the model for
Android (which is the only thing the board vendor supports) and
realistically it's not a system you build general purpose things for
even in development.

--jPC/Tkukgh9ZDT79
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSDBE6AAoJELSic+t+oim94GIP/2WjnJ1GG+d1G0M04+M7Atz0
BRnrGdYmgndxYwmtpqZaJAMGCEyLSKx5oaYTHagezap9kjizg+THqJZRm+Tnad8z
TQnrAUe61qVqOW9C6LkPoKeoJx3L52erXmBcA5cJF4CLeYak81B/wKbkLPciLcFt
LUU/CDD4rKvllWEHW9ksXSC77Jz/iBGKXm5yE02Z0RcKpxi9hqfH52+40KYKV3ju
LLRL8iHfFegeaJpinkDCd96DQ5KTC4NftcSNxsMJ1vmqStpm1lrkoBuyGuNBpDLC
/FEiN3pl6OBYmYMZ6XphX0gybzCK+yf4d80dWkeHnZ3rfBhtshHFVuRVEDMVxyWC
oTnmOhpdagiOlYeMIuN41A+aTiFrZbbUY2EICidoPTkaXnK5VwiPv/kzQCa6GwaI
qqfnxG9ofo8cx4V0Dfx6pjSf6ru9mrVlXJ/ODmBdpd0rn8mEOX03G+NM5LM3dJmD
wTp2R0KXqRsqKmgEWMiIMP8nW5fI0SsZdlHpSh8bIef+LYYndyZE4JyUm+9AwzNV
sTTNuYAcvCDNiMv60CZe0t6ziwTTywuS00DsqBIJn6l5O97dMAppbnOIs5/x1+gw
X9FNohgjuFvPSUnzJqUnmJmBph71Yvsp0CEZ4NgTA/hltkIpmic2+h+r+wQ3IUWS
KLkNW9ZUesM5WZeYJAhy
=0U4R
-----END PGP SIGNATURE-----

--jPC/Tkukgh9ZDT79--
