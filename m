Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaJIIA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:00:26 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:52817 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbaJIIAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 04:00:22 -0400
Date: Thu, 9 Oct 2014 10:00:18 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH 1/2] ARM: tegra: venice2: add GK20A GPU DT node
Message-ID: <20141009080016.GA1203@ulmo>
References: <1412835112-7209-1-git-send-email-acourbot@nvidia.com>
 <20141009074326.GA1010@ulmo>
 <54363DE8.9030102@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <54363DE8.9030102@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2014 at 04:48:56PM +0900, Alexandre Courbot wrote:
> On 10/09/2014 04:43 PM, Thierry Reding wrote:
> >* PGP Signed by an unknown key
> >
> >On Thu, Oct 09, 2014 at 03:11:51PM +0900, Alexandre Courbot wrote:
> >>From: Thierry Reding <treding@nvidia.com>
> >>
> >>Add the device-tree node for the GK20A GPU and leave it disabled by
> >>default. It is the responsability of the bootloader to enable it if the
> >>VPR registers have been programmed such as the GPU can operate.
> >>
> >>Signed-off-by: Thierry Reding <treding@nvidia.com>
> >>Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> >>---
> >>  arch/arm/boot/dts/tegra124-venice2.dts | 8 +++++++-
> >>  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> >Are you going to send the corresponding patches for U-Boot to update
> >the status property if it's initialized VPR?
>=20
> Yes. But maybe I should wait until upstream Nouveau actually works proper=
ly
> for that? Right now it will probe successfully, but will crash as soon as
> the GPU is used because there still are memory coherency problems.

I think the same really goes for these patches. Applying these will make
the node available to U-Boot, so technically some future U-Boot version
could modify a kernel DTB and boot a version where nouveau didn't yet
work out-of-the-box.

There's also still the issue about firmware loading and so on, so maybe
holding off on applying these patches until gk20a is fully enabled is a
good idea. Normally I guess this would be done by not adding the kernel
driver until it's expected to be at least usable to some degree, but I
guess it is a bit late for that now.

Thierry

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUNkCQAAoJEN0jrNd/PrOhaFcP/jUwxaWn7XzNHTI4DcDQHA4c
hqof2BJH1eYXH7cQprEBwlukZEG+Qiy2wf2t+d8bjel3M1xbfHKDoJw3eKhzrs5L
5+qgjkurBuLG3Nv2+KqV96SWUw+7vALvWclw83ZqnoqDu2haMoPv6yuDsxuq81ST
JWsoQDugJ+D4rWLcNDsX7uC58bqDXUGkcuzT94ym04h4QGYdHebXHY+Yxb8ie7rP
V59BkpSZNQ9naEuVdcUgBgRqT4DmmG/MxO5xQSrie+RGpIzv567njoPXEP9cbZqr
p5KeqUUNMYR2jP/drjtJVPx1HQcA3FHobZ4zN6v1lrt/G7wq6Vy8bZZUACLx1T9O
3fZ171Qebzt+j6+NDKUqhobAKy6nEAm/ClMnT+hrx4TiEV++8wulwcxTEGBbyYv3
fcAotpTLzyzuBu7Z1LEAvvaHtVEYuR1SA8AAou4zNmDaeAV3AHD9gSTBGehlpPDr
BgH5bA/JfeK3oJJK7f06KFUEHndJ5jI3+bASYIQvnCRlXIrU/XsisjGa3FuxkvRi
7yzucFhuIr/z2kgbICp5HWUkMzzrxCixz3obptHgTAu7DigjZG2/cVzc748gEb8/
0yUsyX/HMaI9BKD6dZdyU49nI1TNiVx7sfrsS8U/R3422usTymwjDYcADTrJB0Yx
Dnq14z/DrrqH7AB+x2zG
=XWKp
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
