Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbbALQNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:13:05 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8709 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbbALQMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:12:46 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 12 Jan 2015 08:11:23 -0800
Date: Mon, 12 Jan 2015 17:12:34 +0100
From: Thierry Reding <treding@nvidia.com>
To: Alan Cox <alan@linux.intel.com>
CC: Nicholas Krause <xerofoify@gmail.com>, <airlied@linux.ie>,
        <airlied@redhat.com>, <damien.lespiau@intel.com>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpu:drm:Change calls to mdelay to msleep in the
 functions,send_pkg_prepare and send_pkg_done for the
 file,mdfld_dsi_pkg_sender.c
Message-ID: <20150112161233.GC16118@ulmo.nvidia.com>
References: <1420950664-18875-1-git-send-email-xerofoify@gmail.com>
 <1421069367.31978.21.camel@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <1421069367.31978.21.camel@linux.intel.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.2.68.64]
X-ClientProxiedBy: UKMAIL102.nvidia.com (10.26.138.15) To
 UKMAIL101.nvidia.com (10.26.138.13)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CblX+4bnyfN0pR09"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--CblX+4bnyfN0pR09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2015 at 01:29:27PM +0000, Alan Cox wrote:
> On Sat, 2015-01-10 at 23:31 -0500, Nicholas Krause wrote:
> > Changes various calls in the functions,send_pkg_prepare and send_pkg_do=
ne
> > for mdelay to msleep. These changes are needed due to use working with
> > various sleep modes supported by this hardware and thus needing to sleep
> > for a small duration instead of using the respectful delay function due
> > to the need to sleep rather then busy loop the CPU(s) and waste CPU cyc=
les
> > on the system that could be used to handle other tasks.
> >=20
> > Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>=20
> NAK
>=20
> Like every other TODO you've been mucking with at random this one is
> there for a reason.
>=20
> We can't sleep at this point.

=46rom a quick look it seems like the only reason why we can't sleep is
because sender->lock is a spinlock. But it would seem that it could
simply be a mutex, in which case the delays could become sleeps.

Do you happen to remember if there were specific reasons to make this a
spinlock rather than a mutex?

Thierry

--CblX+4bnyfN0pR09
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUs/JxAAoJEN0jrNd/PrOhBfoP/0/U7Hpx4PlYCj+u8tJ8oxUU
FYK2w+OmmiRSDhT8VC9IRU7rsq5z3fmnFM4k+ed1aV9GQx7K8XUdw6CCkuvdjL1d
K+PT7fdC1c1IKim9zk6+DyhL18lzFyLyO0+3Ar6kqKiQecih7ZGr2sNRtJwQiFh+
U3cDwi2dH5b1mwuuZU9R/5jjShZDFJuY0Snoe8qrRd9bD8QrfHJ0V2a4U+SQNDnM
j8tHddaAufarV9YTpT/AkJZNH8wdo6Pv3AtCH6tyOeZ5n4s4+rQTdzDh0BRYWCOn
N4aeJwpCmmVQ/JrVh9tcZ6cpghpjyQ/ZK2TEemh6hq///Drjz+ZPHuFXBC2ntaDG
DwRetCbs15yilih5KIYtpcO3AruDNchZYN++Wt6e+qR2z3eepw/2Tu+2K3k8XtJa
FH0SfWtrnOSKgK0vwPFwDnCncn3w12t9BFa6OKGN57j9ZJJ8cPb0RjQRpmOQfZIR
SD4xGVA7jgglU4/vk4rop+iME1N5eK0nxt2/P6jKMCicALRspRbNsFxnu4tq8Rdx
z2xHGih97gSEkthBwMCaaOOZewtwSbuwhUmD/v1fPjuCXqNEN5yYUa/cxcYcoKof
tlqLMzDvopy2jUKA3wUkp3+bLM8v4YRjoTSVLZ7d5GyQRbfhzoVZ+pnXkZZ2GElP
xwqV7f5gujifp/LPmkjV
=AkMV
-----END PGP SIGNATURE-----

--CblX+4bnyfN0pR09--
