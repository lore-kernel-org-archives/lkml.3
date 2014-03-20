Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaCTEP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 00:15:57 -0400
Received: from ozlabs.org ([203.10.76.45]:56608 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbaCTEPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 00:15:38 -0400
Date: Thu, 20 Mar 2014 15:15:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roger Pau Monne <roger.pau@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: linux-next: manual merge of the xen-tip tree with the tip tree
Message-Id: <20140320151530.e919b8d4c0d9cf701a2c5163@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Mar_2014_15_15_30_+1100_n_MEFlDrnRY6B7Wg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Mar_2014_15_15_30_+1100_n_MEFlDrnRY6B7Wg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the xen-tip tree got a conflict in
drivers/xen/events/events_base.c between commit 02893afdd310 ("xen: Get
rid of the last irq_desc abuse") from the tip tree and commit
8fb980538510 ("xen: add support for MSI message groups") from the xen-tip
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/xen/events/events_base.c
index c3458f58de90,793053065629..000000000000
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@@ -767,7 -788,16 +776,12 @@@ int xen_destroy_irq(int irq
 =20
  	mutex_lock(&irq_mapping_update_lock);
 =20
- 	if (xen_initial_domain()) {
 -	desc =3D irq_to_desc(irq);
 -	if (!desc)
 -		goto out;
 -
+ 	/*
+ 	 * If trying to remove a vector in a MSI group different
+ 	 * than the first one skip the PIRQ unmap unless this vector
+ 	 * is the first one in the group.
+ 	 */
+ 	if (xen_initial_domain() && !(info->u.pirq.flags & PIRQ_MSI_GROUP)) {
  		unmap_irq.pirq =3D info->u.pirq.pirq;
  		unmap_irq.domid =3D info->u.pirq.domid;
  		rc =3D HYPERVISOR_physdev_op(PHYSDEVOP_unmap_pirq, &unmap_irq);

--Signature=_Thu__20_Mar_2014_15_15_30_+1100_n_MEFlDrnRY6B7Wg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTKmtmAAoJEMDTa8Ir7ZwVDnIP/1tk7qYzG2aEslwh283LqD0H
2wPh+nKvnbKNDu24mJwUMfxvBUIPFvWtnRwu9DCbZLxbumSbCtMFCRyeh+T8aYyx
vuCdHM9Dtzehd8ODIq7/RNTTodG5tiRZRMerc7ErLkt9CmBaFnBEk8Pw7wZjo/YJ
IeCmkODZ2gsOyvO6TBmK8eR4WT7GEnjdFPlei+kqHKGRYaHwyi/Lv6/PFdBUlk1h
YajXPcAXJJZA1kcAuuIgxboBRij5QXMfnNm83Gb2lDyiTRl0A4O77sIL0dJMHncR
p+6+ybBLvzgQ2VFU8cLbr1I2fFfTH6AjF8yPidHlPY3XBX3aEMzOSfaBLHG29x/W
ED6Qi6zL+VStLRT0y1qJpDvD3sHEv2KgwRs7WxHTSLwyETvcX03+CadjtAuY2uMg
1n199UpzPlUmqMg7927Gv5bRiMMiFMFBZ6SRPnZeibgQrlb4mWH2lQrtr0vrBUbP
VrDJ1V7CrAWA6/vB8e7uFw51aPf5XYRAVXNGhBSNdx8ageXwr3K0kyQdxBrIOyJf
OAp/8SThVgt0eyFteZp1AffMRJq+jGfJfVdQB251VNEAxxM882VPSNAMfU4Q67V8
SCAPdoGXVXyML6OqiyGrjKWwIrr+dLma2wDxgq+RMXm2aoavLUnPv/p66t4RK9kK
pEoHvqpmY9OxvhKjQDVU
=oV8o
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Mar_2014_15_15_30_+1100_n_MEFlDrnRY6B7Wg--
