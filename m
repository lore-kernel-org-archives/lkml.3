Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaJITBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:01:52 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42967 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaJITBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:01:45 -0400
Date: Thu, 9 Oct 2014 20:01:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141009190107.GY4609@sirena.org.uk>
References: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk>
 <1412775847-15213-4-git-send-email-javier.martinez@collabora.co.uk>
 <1412844355.1316.15.camel@AMDC1943>
 <5436A403.1050109@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OvHFI8f/INxOklTC"
Content-Disposition: inline
In-Reply-To: <5436A403.1050109@collabora.co.uk>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/5] regulator: dt-bindings: Add regulator-initial-mode
 support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OvHFI8f/INxOklTC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2014 at 05:04:35PM +0200, Javier Martinez Canillas wrote:

> Agree, Mark also pointed out that there is a difference between changing
> how the regulator will behave on runtime vs changing how the regulator
> will behave during system suspend. AFAIU from his explanation, the modes
> defined in consumer.h only applies to the former and conceptually there
> should be a difference between those two cases even when the Maxim PMIC
> seems to mix it both in the data-sheet and by using the same field.

No, that's not accurate at all - you're still not getting the concepts
of modes or suspend handling in the regulator API.  I really think you
need to take a step back and try to understand what's currently there
before trying to make changes here.  We've got a set of operations we
can use to change the regulator configuration, if you look at the
existing driver interface you'll see that these are matched with
equivalent operations for setting the behaviour when in suspend
(including a set_suspend_mode() operation). =20

Like I keep saying abstractions are really important to making sure the
code is maintainable.

--OvHFI8f/INxOklTC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNttyAAoJECTWi3JdVIfQAMkH/iLzHrE2nB3YGtgMgRTOPTqv
IfQzzjtqLgDTqi7czNSSF6eG5b++gmnHLwacddjmg0HkpWNk3ROsMXdskiUOnhd+
XO3SVpsCagX4yao9PWPpwVZf6LmqVFhA01lmioBpsK55WZN2ds5Un59MangnCjzT
FjUfJ3YwKOovWt+wQcElaMnaKQSN3iZOWNEJEHQwmczF+mh7AbgfAUvmhbW4d/RP
4qCWrQfWAr7qRtPdMaqnaMbKbXmRvorRjGq3KoW0Ew1L2ouJ8Apc0xgkG8sZ7LFV
clP0rWqZFZ3MP4jhKME2tf//JVECh4U9nkWcUvxtLNnTptihm44jApJnktdm4Ac=
=pNME
-----END PGP SIGNATURE-----

--OvHFI8f/INxOklTC--
