Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbaDQVzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 17:55:10 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41369 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbaDQVzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 17:55:08 -0400
Date: Thu, 17 Apr 2014 16:52:28 -0500
From: Felipe Balbi <balbi@ti.com>
To: Nishanth Menon <nm@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 05/19] bus: omap_l3_noc: switch over to relaxed
 variants of readl/writel
Message-ID: <20140417215228.GD8504@saruman.home>
Reply-To: <balbi@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
 <1397767775-10965-1-git-send-email-nm@ti.com>
 <1397767775-10965-6-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ieNMXl1Fr3cevapt"
Content-Disposition: inline
In-Reply-To: <1397767775-10965-6-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ieNMXl1Fr3cevapt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 17, 2014 at 03:49:21PM -0500, Nishanth Menon wrote:
> Currently we use __raw_readl and writel in this driver, however, there

__raw_* and *_relaxed variants are the same, just have a look <asm/io.h>

297 #define readb_relaxed(c) ({ u8  __r =3D __raw_readb(c); __r; })
298 #define readw_relaxed(c) ({ u16 __r =3D le16_to_cpu((__force __le16) \
299                                         __raw_readw(c)); __r; })
300 #define readl_relaxed(c) ({ u32 __r =3D le32_to_cpu((__force __le32) \
301                                         __raw_readl(c)); __r; })
302=20
303 #define writeb_relaxed(v,c)     __raw_writeb(v,c)
304 #define writew_relaxed(v,c)     __raw_writew((__force u16) cpu_to_le16(=
v),c)
305 #define writel_relaxed(v,c)     __raw_writel((__force u32) cpu_to_le32(=
v),c)

--=20
balbi

--ieNMXl1Fr3cevapt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTUE0cAAoJEIaOsuA1yqREPNQQAJ6YO6d3r7ym37ziV38L87kT
QcI8dPbJYm/a20WFKZOk/K3a9YPfOVdDvoFY9bKVaU6Gsj18mMr2qcpi4N0cxcuz
tL6F87DeRaoRjal2OtKexaAwRF3NBfhLLxP/Vtai80GMJxzCGVdSqWnHMr7SzTF7
UVWW5EWDj90NBC5m2KsdVTzaKUmX8scOC3EkRrESkzB8u15vNzhLW7zNiFkOtU6t
3HUJ5/WCuCW3LstoVuVE4b9tsjsVeF2JDada0tzzeH+BrtnEAJo8rlKu0N0s/Fdz
g5RnB/9GR5xff8B4qVeyfRswakLJmUTX/fM+ljS3D7Ft0Pcl5Zny1SkBsVFbdZ/Q
5gr2G19BjeQfD7r5xgtxVuQm5Ibeu3k6W8TCg0KTbYsWaYMPAMRsgLWJuOvJ0K4m
qMV/RB6C3Hg+/c7AnyxQUrw0fWFE7q6WsRHOhiXPBDN8NmrqXvns3vAVVpx0RxdH
0H/IJJ2/HWkwEwtgaI5izLlidcWUdWEsj6CInKyBGS/YL4R+oIkAWgKrwVkjjnEi
iKFs6Y5KNm7O8xCbHtdhyVkkNTgJNMRtAg+f4PjzF1b1xt+ZkxpTSBJPM7RXuxxx
oSbu/SqwX9DyMNY4Nbm25UmfZbEm/9ELQnLIkv6A/FBlV4vklsoWKLivRCsaIEQF
TR5GThiF8i2uQToSt9YD
=DLhY
-----END PGP SIGNATURE-----

--ieNMXl1Fr3cevapt--
