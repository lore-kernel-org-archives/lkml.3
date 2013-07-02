Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab3GBXpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 19:45:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60050 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab3GBXpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 19:45:31 -0400
Date: Wed, 3 Jul 2013 09:45:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Subject: Re: [GIT PULL] ext4 updates for 3.11
Message-Id: <20130703094529.99444050e676467d281a3b51@canb.auug.org.au>
In-Reply-To: <nsxbo6mxu38.fsf@lambda.thunk.org>
References: <nsxbo6mxu38.fsf@lambda.thunk.org>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__3_Jul_2013_09_45_29_+1000_m6fKLunZ+6LBQdwf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Jul_2013_09_45_29_+1000_m6fKLunZ+6LBQdwf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Mon, 01 Jul 2013 09:55:55 -0400 Theodore Ts'o <tytso@mit.edu> wrote:
>
>=20
> The following changes since commit c7788792a5e7b0d5d7f96d0766b4cb6112d47d=
75:
>=20
>   Linux 3.10-rc2 (2013-05-20 14:37:38 -0700)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_=
for_linus

The merge of the ext4 tree and the staging tree needs the following fixup
(at least).  It is not a biggie, as that code in staging is actually
disabled at the moment.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 4 Jun 2013 14:41:00 +1000
Subject: [PATCH] staging/lustre: fix for invalidatepage() API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h | 2 =
+-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_patchless_c=
ompat.h b/drivers/staging/lustre/lustre/include/linux/lustre_patchless_comp=
at.h
index f050808..67c4644 100644
--- a/drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h
+++ b/drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h
@@ -53,7 +53,7 @@ truncate_complete_page(struct address_space *mapping, str=
uct page *page)
 		return;
=20
 	if (PagePrivate(page))
-		page->mapping->a_ops->invalidatepage(page, 0);
+		page->mapping->a_ops->invalidatepage(page, 0, PAGE_CACHE_SIZE);
=20
 	cancel_dirty_page(page, PAGE_SIZE);
 	ClearPageMappedToDisk(page);
diff --git a/drivers/staging/lustre/lustre/llite/rw26.c b/drivers/staging/l=
ustre/lustre/llite/rw26.c
index 27e4e64..f1a1c5f 100644
--- a/drivers/staging/lustre/lustre/llite/rw26.c
+++ b/drivers/staging/lustre/lustre/llite/rw26.c
@@ -72,7 +72,8 @@
  * aligned truncate). Lustre leaves partially truncated page in the cache,
  * relying on struct inode::i_size to limit further accesses.
  */
-static void ll_invalidatepage(struct page *vmpage, unsigned long offset)
+static void ll_invalidatepage(struct page *vmpage, unsigned int offset,
+			      unsigned int length)
 {
 	struct inode     *inode;
 	struct lu_env    *env;
@@ -89,7 +90,7 @@ static void ll_invalidatepage(struct page *vmpage, unsign=
ed long offset)
 	 * below because they are run with page locked and all our io is
 	 * happening with locked page too
 	 */
-	if (offset =3D=3D 0) {
+	if (offset =3D=3D 0 && length =3D=3D PAGE_CACHE_SIZE) {
 		env =3D cl_env_get(&refcheck);
 		if (!IS_ERR(env)) {
 			inode =3D vmpage->mapping->host;

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__3_Jul_2013_09_45_29_+1000_m6fKLunZ+6LBQdwf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR02YZAAoJEECxmPOUX5FEFH0P/2Nwj+U3bHCEEHlCepuda+pG
gc/ZBecwRkGScfSusbbsAEFNxd6gFce0GhxmptnUmMRVPUJTwegQqBRK9OmRYHOc
rHvDSKOUHi1HYVM6flDOR+xt6Gatij/A9uGEGbzqGFcRX2t416BEcpQStgYAhkkH
PHLwpVU0kMmMvkitwQ/yRWMMwheXZq2AhWLpeK0UjUseoscaan6/3C1UKTdIllFv
stD6f+Lst6APRXPi2lkuQ6hNfsbkL2tDjenyGuOuhy1Pnv2drjtLnZsBzlNSNqHh
rEHIbxgO/4n4WvFTJ+MXvO3oxoNxf2CPeyso3E3SGcnTPliSumm53eD2FeqDIchz
qylI6bZkgHGxn4xw2HPmolHV9IH3KZkm+iC+iJRtfV6pDHTLUOZcFq6JPOEjOE4F
h9c3l1SNKPsdNCBMqEapFe2Ydh/dBkNYz1BPgZpD9b0EgJ/8aU/SP77fDl8kSDoA
CFgw085jpge2sD+btQVwx6vLYUTdYERz2JdVjigeiD5cX5pNgYqCP5JM1qaKoOZg
0T8VmHriluMq/ifdzFtcdiAxl8jlIy17VylJR+PAl3UhqO39fAVo2NOySo2GOLSn
Oi3yCl12JUTmMyMQeXKZ/MR5dZaesW+oiwrwOsYbx8aqJeJSwYsLLoJ7DerIOcaS
bCxQFaIw+kc7RvhvsGc/
=+KEt
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Jul_2013_09_45_29_+1000_m6fKLunZ+6LBQdwf--
