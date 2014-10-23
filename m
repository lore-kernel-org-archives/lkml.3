Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbaJWIMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:12:31 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:55705 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbaJWIJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:09:58 -0400
Date: Thu, 23 Oct 2014 10:09:54 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iommu: Implement a dummy bus_set_iommu()
Message-ID: <20141023080953.GA30397@ulmo>
References: <1406897113-20099-1-git-send-email-thierry.reding@gmail.com>
 <1406897113-20099-2-git-send-email-thierry.reding@gmail.com>
 <20140818165750.GE9809@8bytes.org>
 <20141015091043.GA13162@ulmo>
 <20141022142922.GH10074@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <20141022142922.GH10074@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2014 at 04:29:22PM +0200, Joerg Roedel wrote:
> On Wed, Oct 15, 2014 at 11:10:44AM +0200, Thierry Reding wrote:
> > It seems like I never got back to you on this. The reason here is that
> > for Tegra the IOMMU is part of a larger IP block. The IP block is
> > primarily a memory controller with a bunch of configuration knobs for
> > arbitration, prioritization and whatnot. A smaller part of the device
> > does the IOMMU translation. Therefore the IOMMU implementation would
> > be part of a larger driver, and having this dummy would reduce the
> > amount of #ifdefs required.
> >=20
> > bus_set_iommu() is also the only function in include/linux/iommu.h that
> > doesn't have a dummy, so it seemed like a natural thing to do.
> >=20
> > That said, I can work around this being absent for !IOMMU_API.
>=20
> Or you make this "larger driver" just depend on IOMMU_API? Otherwise you
> need the #ifdefs anyway to not carry around the iommu-ops functions in
> the driver without having the iommu core enabled, no?

I can do that using IS_ENABLED() magic, which will cause the iommu_ops
to be thrown away automatically when IOMMU_API is disabled. That allows
the driver to be compiled with full coverage and still only include the
needed parts in the final binary.

Then again, going forward it doesn't seem likely that we'll ever want to
disable IOMMU on Tegra once it's been enabled, so this isn't really a
big issue.

Thierry

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUSLfRAAoJEN0jrNd/PrOhrpUP/2X6qYRxRULeM/oV5GDviyn5
L3jfLuRxUhnqEJtJOOGUrx6mzzGT2sj4aOc/lWcC3RAZSHEaZUGrsmcWHNIYAQCj
OHefo6H4BClO4iyiIyqOv02Dj54jDe5mahfYgon5q/4IGuIOFZFdwoz9SUXqFfso
bleiBTMxO52De6UptV9XMyD98yX6iOnLSsS6UDm3qgnxCT4wFHKVtLrq5pI5oV5e
iwbAuPOoh77C9JL6qp9Tk6ixJeqyYSN/bsz7YmmMoCVi/8BRiNW5IuuTxxH2hmw1
HUq5vjbcbsZI7QSMgWiG6aXhQndiLvCr/ekfJ5HT0lyOyDaoo06YTXZEM48C7v6R
xJfMSZVegBTWVM1Ry8PgGcNFL58JccMvElkrV07VmotSDQtPv8jrXANG7Bu0Ya32
z38cpBTHMRiW8RxisdT4qaOKN6fIZh/85iWH4jvOcDM1Da+eLeDs2ef2g7O4p60p
hX3SqG/soy+IekbyoSu4SAa6q7bYxpfce1bg3hNi+tpNM/sekhEFwPJ9nlGexYFt
bMm4ouU+SjKmOpDe+PTj8p03Ym4kU9+b8OBK2y8iNbmmCc8LJE2hXoxFxKvpyIvu
DJpmOA/Rq87FEgA48yeS9rKa62KHLP261gxpH0+m4a9E8BTMpC8g0khgLn1QOo2c
4GhpE2awi+8Ydr3dGPTr
=n6kj
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
