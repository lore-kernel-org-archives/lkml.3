Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaJOJKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:10:49 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:37040 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaJOJKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:10:47 -0400
Date: Wed, 15 Oct 2014 11:10:44 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iommu: Implement a dummy bus_set_iommu()
Message-ID: <20141015091043.GA13162@ulmo>
References: <1406897113-20099-1-git-send-email-thierry.reding@gmail.com>
 <1406897113-20099-2-git-send-email-thierry.reding@gmail.com>
 <20140818165750.GE9809@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <20140818165750.GE9809@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2014 at 06:57:50PM +0200, Joerg Roedel wrote:
> On Fri, Aug 01, 2014 at 02:45:13PM +0200, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > This allows IOMMU drivers to compile even if IOMMU_API is not selected
> > and helps improve compile coverage.
>=20
> IOMMU drivers usually implement the IOMMU-API, so they have a strong
> dependency to it. Why do you want to compile-test an iommu driver
> without testing the iommu core-code as well?

It seems like I never got back to you on this. The reason here is that
for Tegra the IOMMU is part of a larger IP block. The IP block is
primarily a memory controller with a bunch of configuration knobs for
arbitration, prioritization and whatnot. A smaller part of the device
does the IOMMU translation. Therefore the IOMMU implementation would
be part of a larger driver, and having this dummy would reduce the
amount of #ifdefs required.

bus_set_iommu() is also the only function in include/linux/iommu.h that
doesn't have a dummy, so it seemed like a natural thing to do.

That said, I can work around this being absent for !IOMMU_API.

Thierry

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUPjoTAAoJEN0jrNd/PrOhsYwP/An4PQHLxcv3daeOk4FJPBgH
N8TNJ944wn7IBW7jPZloebPOsCYzRK0Es7ZYMtrky7WpCtwfsIHo9STD+pCp0kOj
7kHIOOa58kZjVY5emlpdFkMUKE8X50/afa17zQoGsBSKrtpsuIzK8yQ1LFuZgRd3
PleaATreoVwJz8eJvUXtQJWydUewGREGVsQOVp1VMf9K/WO2UEFvj1FUh7o1iCr5
iArS3Ua/50C6JY3udez0ENXIESgj9KWbXxpzMexFv5mjrqi7moUkYrjiBoMA8TnX
V941luld7hkVsp2EetrT7U7nZyyEjymHfry/0/SkwIP0Fhvq1qYWf6AiOxWnn8uD
XBZJY63DbM0XmPtO04qy0CBZl5HupUX/t0dyaz5ZW0oUaShkeY4bvmvi626Dwxj5
u9WPnJErVvqGWJMXhVddgswyWihTHhRigZFiM88YNaf3Ne21fwFbeFhZiLxBtZsu
jkkrknj1gwgx16Y5Yqk92ZwhLsAZNhh2sZz0lBBKZpjyNVOzbjbx5bTffAQnfsaP
vNPYyQQnbcGavCTBxZSyKpOBS5jtsu0ugGrGUWsoKy1h5m3+Pz3XI7ctaiH2qTbf
nG/+H+LQOeGVHnmqq0+3hmKHD/gcJUIkAVRECJhCh/yd9oRy2/ip4HFEDS3lEItt
gUNuaUWyTZlhuiQflZKz
=4LI/
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
