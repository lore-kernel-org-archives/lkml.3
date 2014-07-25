Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbaGYQiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:38:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56985 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752890AbaGYQiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:38:00 -0400
Date: Fri, 25 Jul 2014 18:37:46 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Arnd Bergmann <arnd@arndb.de>, andriy.shevchenko@intel.com,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH v11 0/2] Add support for the Allwinner A31 DMA Controller
Message-ID: <20140725163746.GC20328@lukather>
References: <1405626376-471-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140725131217.GS8181@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="snImcH6YoPvXmXT+"
Content-Disposition: inline
In-Reply-To: <20140725131217.GS8181@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--snImcH6YoPvXmXT+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

On Fri, Jul 25, 2014 at 06:42:17PM +0530, Vinod Koul wrote:
> On Thu, Jul 17, 2014 at 09:46:14PM +0200, Maxime Ripard wrote:
> > Hi,
> >=20
> > This patchset adds support for the DMA controller found in the
> > Allwinner A31 and A23 SoCs.
> >=20
> > This has been tested using the newly introduced SPI driver on an A31
> > EVK. Support for DMA-driven SPI transfers will be the subject of
> > another patch serie.
> >=20
> > This has been around for around 5 monthes now, and didn't get any
> > review but nitpicks for three versions, so I feel like it could be
> > merged quite quickly.
> I have applied this now.

Thanks.

> Can you please send follow patches for these:
> - don't recall if I pointed earlier, but can we use direct conversion for
>   calculating convert_burst() and convert_buswidth(), latter one at least
>   seem doable

Ok. Do you still want the error reporting for the invalid width and
burst size?

> - don't use devm_request_irq(). You have irq enabled and you have killed
>   tasklet. This is too racy. You need to ensure no irqs can be generated =
before killing
>   tasklets.

Ok, would calling disable_irq before killing the tasklet an option for
you ? that would allow to keep the devm_request_irq.

> - use synchronize_irq() before killing tasklet

Actually, I already do it, like you suggested previously. See
sun6i_kill_tasklet.

I'll also send patches for the various breakages and warnings spotted
by the autobuilders.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--snImcH6YoPvXmXT+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT0ofaAAoJEBx+YmzsjxAgskEP/0CGF+AlaGcDJ728nANIkKyP
a2iVc0UIbTR8bDvtr4ZyUw5dwfpYpcVJP3oPTm0uQApAVesrTVPKzga/RdgnBSt3
SjHMN1w1gmzPRc/r+wDPqS/b+jze1t5xaFswnR6hfmhYGnPNwRezRrF8ZRW+TNQ4
Ea5I4IdqMfuLnF3FpRSSTKYi3bGX/mbvrKvqqi263PvlqQaRWu78Z7g8YwHRD+en
R32sIRWWgcfMX0jCCpGmvh4zvpHsj2W2jUU412dFee0BjIrtZyePdr7d//lMLCsc
uk+ZOE0Mb3PNWbbmDAuhIr0A5JQiAebhVN1mafh5Hd2polxxBGri6m6VG7me19Ws
PLJzp/jwitZ6AHJPL7mI7F8RwYqeYvXP0u0rcOvO9SuHShmL+OMGwnqKEutLym9F
8y+18xDcMhIcabPBzNduWbPFypQaFrcn7kqMzZMxbpKYZ2723JOS6Ze3iVIUGIBs
p8tMpM6GDtrBeFUS2+PANG6fC8yIdsl3/LZsZcQrcNA9YNk8e3nCoU3DvD8Uwnv1
5QGpjgSsZeFXqWFZWDAZnAYMatquhxCTUNFYcjLY2vtVlTE08cwpzWEQPx7SJJsL
+mPi9AdKiN5bG6tA9ZdZkesWrdblEGYYf5i6pgULrGpqpOw5noIT2njm81TX3guF
7AmRmGf0zZ/cVuojlnPt
=8HtB
-----END PGP SIGNATURE-----

--snImcH6YoPvXmXT+--
