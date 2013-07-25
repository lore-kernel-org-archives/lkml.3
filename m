Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab3GYNVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:21:50 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:60094 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab3GYNVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:21:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mark Brown <broonie@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: How to create IRQ mappings in a GPIO driver that doesn't control its IRQ domain ?
Date: Thu, 25 Jul 2013 15:22:29 +0200
Message-ID: <1681089.qGWOhLKTTo@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130725131556.GD9858@sirena.org.uk>
References: <1624911.6TtmtVmU1T@avalon> <1408178.cxAUTUGJc5@avalon> <20130725131556.GD9858@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4034058.P0iQurBOgl"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart4034058.P0iQurBOgl
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Mark,

On Thursday 25 July 2013 14:15:56 Mark Brown wrote:
> On Thu, Jul 25, 2013 at 11:45:33AM +0200, Laurent Pinchart wrote:
> > The two devices are independent, so there's no real parent/child
> > relationship. However, as Grant proposed, I could list all the interrupts
> > associated with GPIOs in the GPIO controller DT node. I would then just
> > call irq_of_parse_and_map() in the .to_irq() handler to magically
> > translate the GPIO number to a mapped IRQ number.
> > 
> > The number of interrupts can be pretty high (up to 58 in the worst case so
> > far), so an alternative would be to specify the interrupt-parent only, and
> > call irq_create_of_mapping() directly. What solution would you prefer ?
> 
> Are the interrupts in a contiguous block in the controller so you can just
> pass around the controller and a base number?

In two of the three SoCs I need to fix they are. I've just realized that in 
the last one the interrupts are in two contiguous blocks in two different 
parents. I will thus need at least a list of <parent-phandle base count>. Our 
standard interrupt bindings don't seem to support multiple parents, is that 
something that we want to fix or should I go for custom bindings ?

-- 
Regards,

Laurent Pinchart

--nextPart4034058.P0iQurBOgl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQEcBAABAgAGBQJR8SaaAAoJEIkPb2GL7hl16iUH/R9oHeXgAY0fDLzdDOFeGfC0
hYLDHGlQ9kpD+mfaN5xHDvTkh7WSYd1W5fBk/ZRzqWxfnPAbRjuH2RIvw9Y7yFum
aJhzHv3cuusxXrHksX+YpRaRMlNO9TE6wxLw0FBQRposgG/UshknaOWnfih5hy0Q
FifovpgM3qUp6vt0kz17uFqTU/P7vOG2KirCLB+65Xt3gOV+9igdxixwyMy1KpET
fN/2/mz0AUi38BJZvc1SFNxbYa+RWqOXXAoHYmRghHw3D7JcT4OxImUVGlbd4DH9
0opLmJXDVcnCzRSpRoDXkn3dre3eBLxDzxaQTVlAk0mB50gRtiS0ySW557AYJLs=
=2z7q
-----END PGP SIGNATURE-----

--nextPart4034058.P0iQurBOgl--

