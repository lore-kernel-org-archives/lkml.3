Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbaJHMzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 08:55:15 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40626 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbaJHMzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 08:55:12 -0400
Date: Wed, 8 Oct 2014 13:54:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lejun Zhu <lejun.zhu@intel.com>,
        Radivoje Jovanovic <radivoje.jovanovic@intel.com>,
        Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Message-ID: <20141008125429.GX4609@sirena.org.uk>
References: <1410229968-11638-1-git-send-email-aaron.lu@intel.com>
 <1410229968-11638-3-git-send-email-aaron.lu@intel.com>
 <20141008080515.GC20647@lee--X1>
 <CACRpkdaPFzq=Qya_UoZpxHom+VcynTwQL9EfdLb_Vpr=g6+Prg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WiuFC6bSmcjanUfV"
Content-Disposition: inline
In-Reply-To: <CACRpkdaPFzq=Qya_UoZpxHom+VcynTwQL9EfdLb_Vpr=g6+Prg@mail.gmail.com>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] PMIC / opregion: support PMIC customized operation
 region for CrystalCove
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WiuFC6bSmcjanUfV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 08, 2014 at 11:16:11AM +0200, Linus Walleij wrote:
> On Wed, Oct 8, 2014 at 10:05 AM, Lee Jones <lee.jones@linaro.org> wrote:

Please don't send upstream mail to my work account (which I've never
used for upstream mail and isn't advertised in MAINTAINERS), it mostly
gets deleted unread.

> > With the influx of new same-chip devices, I think the MFD subsystem is
> > fast becoming overloaded.  I think all of the PMIC handling should in
> > fact either live in Regulators or have its own subsystem.

> You have a valid point, and it's been raised before that MFD risk being
> a dumping ground of the same kind that drivers/misc used to be (is?).

> If they shall live in MFD the driver there should (IMHO) just be
> an exchange station, multiplexing messages and spawning
> MFD cells into platform devices for respective *real* subsystem,
> various misc stuff should not be allowed to be shoehorned
> into MFD just because there is no other place to put it.

Right, there's a very clear role for MFD in multiplexing the various
functions of the device and dealing with any core behaviour it needs for
bootstrapping or things like chip level suspend and resume.  Dumping
that into some random subsystem doesn't seem to make any sense, but
doing things that fall outside that remit also don't seem clever.

--WiuFC6bSmcjanUfV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNTQEAAoJECTWi3JdVIfQvqsH/R3Ib9aqPHFEIMXn4xjG5rIJ
iLpASimgXCZZv/n9JJ7e1ajnKHmp0BnlT6R6EHjsRvKb5+r6yfUmfpo33xmHlkzh
BDsD/6eWpi62TOxQl0r/bVW49OCvzsqy307In0a0uiUZqkhCTnpxwSV54QuT1kJC
06Y95UlMmDLTaoLnwlU57VeCyfYhIAXyzxQRJpOz3pOJeqkaXQQeM5qU3JBPg5Se
IowyiTlRanAv4rulyDfxYhghQxw+fKP+nEFgEgjK8Vsyx9YlcUTMBREHo7VsQec6
Gj+Uxo5wU3V8yZxdvVrWW4hJ6JLLiwyXqCILyi3MF1uuJohDbGg2DTSncKZ9eMg=
=8Q4j
-----END PGP SIGNATURE-----

--WiuFC6bSmcjanUfV--
