Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab3G2C7H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 22:59:07 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49800 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab3G2C7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 22:59:04 -0400
Date: Mon, 29 Jul 2013 12:58:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20130729125851.a4b10b1fe06303772afd74b0@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Jul_2013_12_58_51_+1000_mayw1nBnNXU.r=Yc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Jul_2013_12_58_51_+1000_mayw1nBnNXU.r=Yc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/qxl/qxl_release.c between commit 8002db6336dd ("qxl:
convert qxl driver to proper use for reservations") from Linus' tree and
commit 72525b3f333d ("drm/ttm: convert to unified vma offset manager")
from the drm tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/qxl/qxl_release.c
index b61449e,1a648e1..0000000
--- a/drivers/gpu/drm/qxl/qxl_release.c
+++ b/drivers/gpu/drm/qxl/qxl_release.c
@@@ -85,13 -85,12 +85,13 @@@ qxl_release_free(struct qxl_device *qde
  	if (release->surface_release_id)
  		qxl_surface_id_dealloc(qdev, release->surface_release_id);
 =20
 -	for (i =3D 0 ; i < release->bo_count; ++i) {
 +	list_for_each_entry_safe(entry, tmp, &release->bos, tv.head) {
 +		struct qxl_bo *bo =3D to_qxl_bo(entry->tv.bo);
  		QXL_INFO(qdev, "release %llx\n",
- 			entry->tv.bo->addr_space_offset
 -			drm_vma_node_offset_addr(&release->bos[i]->tbo.vma_node)
++			drm_vma_node_offset_addr(&entry->tv.bo->vma_node)
  						- DRM_FILE_OFFSET);
 -		qxl_fence_remove_release(&release->bos[i]->fence, release->id);
 -		qxl_bo_unref(&release->bos[i]);
 +		qxl_fence_remove_release(&bo->fence, release->id);
 +		qxl_bo_unref(&bo);
  	}
  	spin_lock(&qdev->release_idr_lock);
  	idr_remove(&qdev->release_idr, release->id);

--Signature=_Mon__29_Jul_2013_12_58_51_+1000_mayw1nBnNXU.r=Yc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR9dpxAAoJEECxmPOUX5FEXUAP/1q9evideNJZyokVNY6Ztg5r
wsnJEBmG48GqziJYiC67NUtHvOp4Q0GMhAV1PwUeFofxCBPpWXLknXhVorvm7SJA
i0o7y12l0wrLGvOKR582KCyto2IQU8u8umgKYg+XWJfIkUkKOb7Io0ML4rq9ix1g
MikmUlmC1jEu0XTvUBzHNWgmGXrMtsTJBMcwegXc6MNbcRT06wRIROXip2OPXres
zDkwy2heLarLWWAIb+YbwX0DWq37Fs8gKO6dOqKcqRvbklhIa+UY0SNfh02I3UdG
TBrTLuX/B6DnNss77EBFT0DPy6x6xwRyuqZzJpeRxh0rFS0UnQM15U5yamfb+W5B
HPzOYVa3uKtYY/sqUodhdHrd4171o2hqLHD2/vJmZGLg9IYGbbUNg3tYaLKavG2N
OqNlZZB5Hofhj8h85waWF5TV7+TS0wuH2m+gy8n9Hj7p6E95j/KbtvdgO5elemLK
TlTMGM11c1fzRcrZNoSZzMY9KxK1bduKjUyXcKnzK5ll6YBq873Wdm14VK3R7pNv
L9h81DD6SC+WPo1W+ihSu1c5Ybi2w2VXT1YeMGvSo2+qdDuB8zB5ZezQ6OEh8D84
4KyBhCsrY2T9+r8VE0RHwTnpyc+I2+uSdEOGOY66HhSbMiZSuAi3WM8rWctOODq6
QCYvIAixsP1TJrpwNwGM
=mDlg
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Jul_2013_12_58_51_+1000_mayw1nBnNXU.r=Yc--
