Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab3FFQqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:46:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46221 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3FFQqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:46:48 -0400
Date: Thu, 6 Jun 2013 17:46:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Message-ID: <20130606164629.GG31367@sirena.org.uk>
References: <1717403.GgHsbyUkDZ@dtor-d630.eng.vmware.com>
 <51AFA02B.3000604@itdev.co.uk>
 <20130605210715.GA16013@core.coreip.homeip.net>
 <51AFAF6D.7050204@itdev.co.uk>
 <20130606100346.GC1883@sirena.org.uk>
 <51B0651D.3090902@itdev.co.uk>
 <20130606105530.GT31367@sirena.org.uk>
 <51B06FE4.7040805@itdev.co.uk>
 <20130606131638.GX31367@sirena.org.uk>
 <51B0B52C.1090807@itdev.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gPVs24VLDFKgHP1I"
Content-Disposition: inline
In-Reply-To: <51B0B52C.1090807@itdev.co.uk>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gPVs24VLDFKgHP1I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 06, 2013 at 05:13:32PM +0100, Nick Dyer wrote:

> I am not a legal expert, but I have described what you suggest to people
> who are more expert in the NDA terms and they say I cannot implement a
> solution which exposes the names of all the parameters. In any case,

Who said anything about names?  I'd assume the userspace stuff is
eventually talking to the device based on numbers of some kind and I'd
expect that this would be what ends up in the API.

> Without the register names all you really have is the object protocol that
> we started with, you would end up accessing

> /sys/bus/i2c/drivers/atmel_mxt_ts/1-0020/objectX/registerX

> rather than parsing the object table once when your program started, then
> performing a read/write to offset X.

Well, assuming sysfs makes sense for this.  It's not immediately clear
to me that it does.

> And we wouldn't have won anything, because the user could still write to
> the register that turns off reporting (for example) by mistake with both
> methods.

You'd not have access to the entire device register map which seems like
a win and people would be able to integrate sensibly with things like
the overall device power management (which might help with whatever is
causing you to have to cope with failing I/O) more smoothly.

> > So this goes back to what I was saying before about the interface being
> > badly designed - if the API you have to present is really this complex
> > then you've got a big problem in kernel or out of kernel.

> Touch controllers are inherently complex system with a lot of configurable
> parameters. The fact that it's complex and changes quickly doesn't make it
> badly designed per se.

Having lots of configuration and having the parameters change regularly
doesn't immediately mean that it has to be complex - the requirement is
very common, touchscreens aren't too remarkable here.  The usual thing
is for the kernel to understand how to transfer data back and forth but
not the content of the data.

--gPVs24VLDFKgHP1I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRsLzhAAoJELSic+t+oim9fR0P/31vAmhnEdcIB4fbV+V4DSt2
4YLZ+QLQZpSZBd2Kwft9uxgow6/Y80vHCdFgl8/iCePR53xcCG3bDaRB1IAQ+mWU
zxyfSvjs/oFiW8+7zh+DHGHWnmO1DbaC4KDATFAegfXHJEwCIVrD7l7nQ4+86sxw
xxcZdyOt32Dcav+ttUScc5EIk39kmz8/Ip2Ny2DGuaJF3xjxCvq+Pmv2AysEDuu7
wuDBeVZ55C3QMOwoQSDdP8rziVKOFTwHnYN3xt2lUcqHsemkLNzuBDVMxl759GEj
XaYE/kifmEyaGgPD2cFsl1G2LrmdsvlBiT05IWmM2oAgbX8oY5tA9msnyujffgNb
IWv94AEAO8WiJN+znATiN7CpsTXO8IgA4cHTcQHmp7kuG15A+u6nf8hsfZjh/P2c
49gxfM9L5oI6gNTGofz4/eW8jf/0lXpGXqlMg//A2EO53SSEFceZcNmVAEmJ8jb1
4xTl90E4P9E22i75Isr/Nnqv0KDfWeltyj+p+rSqF1i4y8Hl8syztYgPpM87BKBJ
totLlz314o5Q3lE6CQOPSjK6giPdzqB55XGSiKYb50USi1DEKoV8dxZ80r9YD/H3
RWkw9nWvl6uygTwwljWJ5mPz21xQXMdwwLHHuz8q5eJ4WTd5OfZ7JesZI6DguJql
zSlrMxCNqgFxFYt2uemg
=+s6J
-----END PGP SIGNATURE-----

--gPVs24VLDFKgHP1I--
