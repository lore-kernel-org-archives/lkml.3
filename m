Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaBZGrC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 01:47:02 -0500
Received: from ozlabs.org ([203.10.76.45]:52307 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbaBZGrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 01:47:00 -0500
Date: Wed, 26 Feb 2014 17:46:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>
Subject: linux-next: build failure after merge of the cgroup tree
Message-Id: <20140226174655.b5430a1a2413ddb459dababe@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__26_Feb_2014_17_46_55_+1100_7jDWOrjbyOGJQ73G"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Feb_2014_17_46_55_+1100_7jDWOrjbyOGJQ73G
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

After merging the cgroup tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

kernel/cgroup.c: In function 'cgroup_mount':
kernel/cgroup.c:1572:2: error: too few arguments to function 'kernfs_mount'
  dentry =3D kernfs_mount(fs_type, flags, root->kf_root);
  ^

Caused by commit 2bd59d48ebfb ("cgroup: convert to kernfs") interacting
with commit fed95bab8d29 ("sysfs: fix namespace refcnt leak") from the
driver-core.current tree.

I added the following merge fix patch, but it may not be completely
correct, please check.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 26 Feb 2014 17:41:51 +1100
Subject: [PATCH] cgroup: fix up for kernfs_mount API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 306ad0ed19ef..8f4ddbe23d58 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1569,7 +1569,7 @@ out_unlock:
 	if (ret)
 		return ERR_PTR(ret);
=20
-	dentry =3D kernfs_mount(fs_type, flags, root->kf_root);
+	dentry =3D kernfs_mount(fs_type, flags, root->kf_root, NULL);
 	if (IS_ERR(dentry))
 		cgroup_put(&root->top_cgroup);
 	return dentry;
--=20
1.9.0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__26_Feb_2014_17_46_55_+1100_7jDWOrjbyOGJQ73G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDY3jAAoJEMDTa8Ir7ZwV494P/1tky6yrFNJEpJZ7o61zJbz1
/wIieAEuKGYIrAAuCva5lkYuyjvxlwUhCGvwa6lda/K65cKiaCYMlX7PyJiot80P
W144G7OXpJWgC13Sw/BjNwm1l055CQAU3sH7x+4QYaI/ADO2I8qjWbwgkHCMC0XH
Q4W7C0DWQLeiej/1M8P2OCorKDA2vvEDdgSmODT9Xj2mUFQSRT/xP2rqQlZEmYXl
+/XqaH4pdAHIISmEj21ZEC6EDjHi5CVHY4pumh6Q+M92YWS968jGB3x3eyweUSNr
D16JfTmzptwaqGFxUbSE10szV42q0z2GZuuy5JnipK5Gykdqzph+9cHbDi2kB2E+
ttrnAYootLOtn1CQ8/5rUlx34fFnlcfhws+/tDLqfXjD9DSrNH0K/ou65PLehB0c
j9p+o1NVVQtlzJ2ovtuEkbmhm7oKtSLyej88A12fkaWhdf1BJa8crkpLZFBO2g7D
upUH7XIhMAnhq/mpeXkycq3GwQBpPeRI7RNOdcelQYoGE230L9kz9NVsMQ6Sddmz
Pkp11pHljXCtkUnOMEsZ+7KSwVsRrVw/M5hiljyf12B4FnkDqa+YqgTMrWRkvqw4
AOw3cJW9ODOVrTT1JquMi5LZyRfgxjePRR+dHCcqJ/sk6+2JrtlLsBt2HlE3MQf9
1kKsMRBKEsEyIer+TlK7
=XzJY
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Feb_2014_17_46_55_+1100_7jDWOrjbyOGJQ73G--
