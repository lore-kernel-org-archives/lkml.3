Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab3FGEtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 00:49:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38482 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab3FGEtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 00:49:51 -0400
Date: Fri, 7 Jun 2013 14:49:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: manual merge of the driver-core tree with the pm tree
Message-Id: <20130607144936.6ea0c2d9a7fcf321e59cc6d6@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Jun_2013_14_49_36_+1000_T=ArogYkIUPRU0bH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Jun_2013_14_49_36_+1000_T=ArogYkIUPRU0bH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/base/memory.c between commit 4960e05e2260 ("Driver core:
Introduce offline/online callbacks for memory blocks") from the pm tree
and commit 96b2c0fc8e74 ("drivers/base: Use attribute groups to create
sysfs memory files") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/base/memory.c
index 4ebf97f,e315051..0000000
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@@ -595,6 -493,41 +541,42 @@@ struct memory_block *find_memory_block(
  	return find_memory_block_hinted(section, NULL);
  }
 =20
+ static struct attribute *memory_memblk_attrs[] =3D {
+ 	&dev_attr_phys_index.attr,
+ 	&dev_attr_end_phys_index.attr,
+ 	&dev_attr_state.attr,
+ 	&dev_attr_phys_device.attr,
+ 	&dev_attr_removable.attr,
+ 	NULL
+ };
+=20
+ static struct attribute_group memory_memblk_attr_group =3D {
+ 	.attrs =3D memory_memblk_attrs,
+ };
+=20
+ static const struct attribute_group *memory_memblk_attr_groups[] =3D {
+ 	&memory_memblk_attr_group,
+ 	NULL,
+ };
+=20
+ /*
+  * register_memory - Setup a sysfs device for a memory block
+  */
+ static
+ int register_memory(struct memory_block *memory)
+ {
+ 	int error;
+=20
+ 	memory->dev.bus =3D &memory_subsys;
+ 	memory->dev.id =3D memory->start_section_nr / sections_per_block;
+ 	memory->dev.release =3D memory_block_release;
+ 	memory->dev.groups =3D memory_memblk_attr_groups;
++	memory->dev.offline =3D memory->state =3D=3D MEM_OFFLINE;
+=20
+ 	error =3D device_register(&memory->dev);
+ 	return error;
+ }
+=20
  static int init_memory_block(struct memory_block **memory,
  			     struct mem_section *section, unsigned long state)
  {

--Signature=_Fri__7_Jun_2013_14_49_36_+1000_T=ArogYkIUPRU0bH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRsWZmAAoJEECxmPOUX5FE5IEP/iWJM4Tm7WZEtPEIrshGtuhk
7sz8RFlVcJza6BXQcAuZBHoGrUEjBEW8AjAkupXK7GrrBB5qd2YMALMauV3VoDW6
DpG4kKPCH/ejJHCKF5YHoCa++l79JKut6CNWYeEeH1FsH8p55qALglRUayB3MxTR
sKurcSy8PZjxUFQXzuu8kST+N2f+igsRFT0uVT+DJD3ZL0pV4uSkjHWWh7yISezK
j9lBSRSCckIwyvEtLwqIjq7CHCV9rjWtexnI6Ksva39ZYJdXqNCCcgH+cI8SbtP4
OPc7iMy6IZLiMLAx4B+o/8oGaonQOjxdUb5jnwhu0Yepcoy1MHuYTt5Ix4TPzCZO
S0nayln7TmxWsOh4/HTuSPsQGrnkB7jK7Aoo9KEYNlUxHfVh+1VKnWi/RUPcFrRJ
q44WLempREvUCYD47SaUPOHDT2qFOgS3//rtQXW+doDd9E3nT+Oc4n+w/MWpO85y
NXIDC1t+Ke7F2lLqk/fM0kThRrunQnMniaTnfu1BveUmCOr9pTDgvBfVumNjjNMs
OKV5vGK/mk0sG/3D/BJD1sFa82xOCUBrpi+813ryrRsedtvdYalXD4/0cid5Xyqi
RiBB2K4b2aN9Hf+C2fG0le8pDSUIZaHi6ZVo57sqHjC/mQ3D2JAUnT0a2b3wZtBm
pH6NsP84rUOl9CUzWkKn
=jrG9
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Jun_2013_14_49_36_+1000_T=ArogYkIUPRU0bH--
