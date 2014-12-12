Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030717AbaLLQxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:53:10 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56972 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933082AbaLLQxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:53:08 -0500
Date: Fri, 12 Dec 2014 16:52:30 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: open list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "moderated list:ARM/CLKDEV SUPPORT" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        boris.brezillon@free-electrons.com
Message-ID: <20141212165230.GP11764@sirena.org.uk>
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
 <1418226513-14105-3-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BtjZvq0+OkLkL8An"
Content-Disposition: inline
In-Reply-To: <1418226513-14105-3-git-send-email-a.hajda@samsung.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 02/15] drivers/base: add restrack framework
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BtjZvq0+OkLkL8An
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 10, 2014 at 04:48:20PM +0100, Andrzej Hajda wrote:
> restrack framework allows tracking presence of resources with dynamic life
> time. Typical example of such resources are all resources provided by device

I don't know about anyone else but I'm having a hard time reading the
restrack name, it looks like a misspelling of restack to me.

At a high level my biggest questions here are the relationship between
this and the component code and usability.  The usability concern I have
is that I see no diagnostics or trace here at all.  This means that if a
user looks at their system, sees that the device model claims the driver
for a device bound to the device but can't see any sign of the device
doing anything they don't have any way of telling why that is other than
to look in the driver code, see what resources it was trying to depend
on and then go back to the running system to try to understand which of
those resources hasn't appeared.

> +int restrack_up(unsigned long type, const void *id, void *data)

> +int restrack_down(unsigned long type, const void *id, void *data)

Again I'm not sure that the up and down naming is meaningful in the
context of this interface.

> +static void restrack_itb_cb(struct track_block *itb, void *data, bool on)
> +{

itb_cb?

--BtjZvq0+OkLkL8An
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUix1NAAoJECTWi3JdVIfQAPMH/R+IVHCd39YcJ+18grWKmwT4
9bWUGZ9CGXaPnvTcFkiJ31g6Y0M7FaKYSGbt/mIGWQKrOGEbdn3ba751zj36RfIg
b1sjS1g+09CkvVnKGkvaLyxILeh+Tw46hFiy6QqAejbqzSMGCigGpJOMilGkSYt9
bJ1nESyD1U6iHHJkJ89p5latFSjHY4tYOlecIf0dTJ7Ct/EKvsuxJo2uVzspeV0Y
MM88Mklo0cCgvZNrXMPmoDQGQ90UZ/O6PkYZ4sMi40XNNJ7QasRTR54l7FcAJdEg
mBrJSyfh1IFr40NKFMJOnvYpZrWN0SNOYEJXll6y/KpKBZpF9qlfc2TC/KkzQM8=
=WFLX
-----END PGP SIGNATURE-----

--BtjZvq0+OkLkL8An--
