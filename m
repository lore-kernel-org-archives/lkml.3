Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab3GPNBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 09:01:30 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37313 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247Ab3GPNB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 09:01:27 -0400
Date: Tue, 16 Jul 2013 16:00:58 +0300
From: Felipe Balbi <balbi@ti.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: <balbi@ti.com>, Hein Tibosch <hein_tibosch@yahoo.es>,
        Tony Lindgren <tony@atomide.com>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-omap: always send stop after nack
Message-ID: <20130716130058.GD15036@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <51E50217.1000507@yahoo.es>
 <20130716090300.GG8880@arwen.pp.htv.fi>
 <51E5137B.7000302@yahoo.es>
 <20130716094212.GL8880@arwen.pp.htv.fi>
 <51E527F7.4080007@ti.com>
 <20130716112746.GN8880@arwen.pp.htv.fi>
 <51E537A4.40300@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d9ADC0YsG2v16Js0"
Content-Disposition: inline
In-Reply-To: <51E537A4.40300@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--d9ADC0YsG2v16Js0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

(when replying, can you add some blank lines around your reply and the
previous mail, it's quite difficult to find your replies with so many
quote marks (>) around)

On Tue, Jul 16, 2013 at 03:08:04PM +0300, Grygorii Strashko wrote:
> Hi Felipe,
> On 07/16/2013 02:27 PM, Felipe Balbi wrote:
> >Hi,
> >
> >On Tue, Jul 16, 2013 at 02:01:11PM +0300, Grygorii Strashko wrote:
> >>>>>>On a OMAP4460, i2c-bus-3:
> >>>>>>
> >>>>>>A driver (lm75) is causing many 'timeout waiting for bus ready' err=
ors.
> >>>>>>SDA remains high (as it should), but SCL remains low after a NACK.
> >>>>>>The bus becomes _unusable for other clients_.
> >>>>>>
> >>>>>>While probing, "lm75" writes a command, followed by a read + stop,
> >>>>>>but the write command is NACK'd. The chip does accept other writes/=
reads,
> >>>>>>it just refuses to ack invalid commands.
> >>>>>>
> >>>>>>Can you tell me if the patch below would make any sense? Or is it t=
he
> >>>>>>responsibility of the client to reset the i2c_smbus?
> >>>>>patch below breaks repeated start.
> >>Felipe, I'd very appreciate if you'd be able to provide the use case
> >>which will fail with such solution?
> >
> >can't you see how this would fail ?
> >
> >assume omap_i2c_xfer() is called with its last argument (num) being
> >greater than one and you get the NAK before the last transfer.
> That's our case - NACK from slave before last transfer

with one difference, your device requires a STP condition because it's
SMBus, right ? Not all devices act like that :-)

But now I noticed, because of your reply, something I have been
overlooking for quite some time. As you said below, in case of NAK we
break out of the loop and don't even try the following messages.

Which means your original patch starts to make a lot more sense. I
wonder is this is really what we should be doing though - breaking out
of the loop, I mean.

It'd be cool to get an answer from I2C maintainers if we're doing the
right thing here.

--=20
balbi

--d9ADC0YsG2v16Js0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR5UQKAAoJEIaOsuA1yqREBIwP+wVCJ64Ql/JvPR+EF74Bacn/
5Y36cStTBebsy/F2shSslrHroQJ3/JHlvG1Y464FykzSMTruj4yYcm8yo8XXh1sd
Rr+eSfGSAklfwLXdZ8MFX/LaFzPQTs3J5M0Kb8NaGpLetHcEL6wCXFlxwYySq4zh
NvCp2J9iXTlR4jLaR2qwJUU0LWfyKsY1Lsfx3cnP6Cv2tzwespNVUZrWi8fBfZqy
846gS5cPSs0lnsDGFzCYNiYikKyH4HMCl34M0bN70mzA0SmIwwNd4z9jL8bxkymG
OMkvrAi6x6gTV+n0C0RHB6Zl9GoISNsI/5sTuYhg1sD7We24mI1nYc6SoAYk/gJp
l9zQq4FfiTIF6kLbs8EDeWxuE9ukr/g14Ft8NIU0qkdVpBrz7Q2AQ5RbPNBysgr0
waljATqZjJSzpLB8wkPPIHuvdPlNz/bEMRhY66a3KhZd/SQgiezEZT8JJThj9GgS
OxAuuJfTgx+/isoffr3vC1JEECSZ7r6TPJdEBLJ22pIlGLW+t+DKJ8fuWkNKm8om
q4YSjYXKB/JtL/RPjCrSBwpxTuiCNehA4KkemxlOgS1ti/5AYfx6Z7XXrsvYjK4q
ZOvksdJcWbomikWl0HMznmvwOX4xKqKOj9byKaSP8XrXki7lXjTDwnrhM1NUYWHF
VhP/C/sQssvQOH7tHczT
=cn8R
-----END PGP SIGNATURE-----

--d9ADC0YsG2v16Js0--
