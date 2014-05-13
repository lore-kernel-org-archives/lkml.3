Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550AbaEMKPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:15:30 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53558 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933513AbaEMKP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:15:26 -0400
Date: Tue, 13 May 2014 12:15:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, jet.chen@intel.com, fengguang.wu@intel.com,
        linux-ia64@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: sched: fix: initialization of sched_domain_topology for NUMA
Message-ID: <20140513101520.GX30445@twins.programming.kicks-ass.net>
References: <20140513082609.GA2485@laptop.programming.kicks-ass.net>
 <1399972261-25693-1-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="efFJd/fQ0cD5Wc37"
Content-Disposition: inline
In-Reply-To: <1399972261-25693-1-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--efFJd/fQ0cD5Wc37
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2014 at 11:11:01AM +0200, Vincent Guittot wrote:
> Jet Chen has reported a kernel panics when booting qemu-system-x86_64 with
> kvm64 cpu. A panic occured while building the sched_domain.
>=20
> In sched_init_numa, we create a new topology table in which both default
> levels and numa levels are copied. The last row of the table must have a =
null
> pointer in the mask field.
>=20
> The current implementation doesn't add this last row in the computation o=
f the
> table size. So we add 1 row in the allocation size that will be used as t=
he
> last row of the table. The kzalloc will ensure that the mask field is NUL=
L.
>=20
> Reported-by: Jet Chen <jet.chen@intel.com>
> Tested-by: Jet Chen <jet.chen@intel.com>
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> link: https://lkml.org/lkml/2014/5/12/130
>=20
> ---
>=20
> Hi Peter,
>=20
> Does this commit message contain enough information ?

Yes, thanks!

--efFJd/fQ0cD5Wc37
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTcfC4AAoJEHZH4aRLwOS6MbQP/3ITpIvBcySpDxr9QxrywGsi
N4Bbhf/9ThpuEcLmZ11Cx7Ka7XAVzBXpLJm9aPBLysV6e8r/dhl0hXPT/WtBVJ+H
8gDPMtGRwdpxSo/t5X7fTiwODSJf29pQ2vxR2gbMPWe96b+0wkKLWlfpC8E/9Zpk
nycPwC+G4l80WD75mUXA6ZtpOwku+25iBsenPxbK9vjGDiZ4L4r2myQ4Rq9BrAzm
xyLsz0gZURAcgIPbdrZoJmmeQfnx0WuDQL7h0R7XMkRoYHeawBMBmSXXHIJtHyPx
SBKF7nQ+5RYILwByy75szX2Wr4J9nSdwHDq1FcpB9ueSa1JQ5RSUkaAvSJNJN+Hy
4aaMfrcqo2GBAOXDD1S3afzFQRpLD4SA6x9OfvHqSPBU463fGlNpHb8ueS3rZi1N
bvHPVpFrWGxvJQoSsapzqCu4fSprNFTjQuSV5q0sYgFMLAsTbISc5I7LnFfcEpBA
+uVs5GqHKECnhoLFiDr/998fKGvzEeZHKjyL4v+6vprOoBtnUXky7hy0gFt6clOd
oeD9pwnuR5OkZKMy2Dy0bbsr6gcbY6eUR6Mm9X3gf67wEaAwwHuc9F1LJVP7XKx5
QyoBmXfN8kIro/OMkj6PlEO/zvllIxSV2wh94UjCY/ixB9rNTXNF359JeToP9H3D
VDDm1qbYHsHTe+kLJXI5
=o8Mv
-----END PGP SIGNATURE-----

--efFJd/fQ0cD5Wc37--
