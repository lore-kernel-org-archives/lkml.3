Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaD2NAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:00:04 -0400
Received: from ip-78-45-166-173.net.upcbroadband.cz ([78.45.166.173]:55021
	"EHLO moskyto.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaD2NAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:00:02 -0400
Date: Tue, 29 Apr 2014 14:59:58 +0200
From: Jan Moskyto Matejka <mq@suse.cz>
To: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RESEND][PATCH][linux-next] drivers: staging: removing never #def'd
 BP_PROC_SUPPORT
Message-ID: <20140429125958.GC11806@moskyto.dyndns.org>
References: <1396868457-7216-1-git-send-email-mq@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3Pql8miugIZX0722"
Content-Disposition: inline
In-Reply-To: <1396868457-7216-1-git-send-email-mq@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3Pql8miugIZX0722
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

BP_PROC_SUPPORT was never defined so removing all the #ifdef'd code
including the bp_proc_create() function.

Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>
---
 drivers/staging/silicom/bpctl_mod.c | 39 ---------------------------------=
----
 1 file changed, 39 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/=
bpctl_mod.c
index 6b9365b..530d621 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -119,7 +119,6 @@ static void if_scan_init(void);
=20
 static int bypass_proc_create_dev_sd(struct bpctl_dev *pbp_device_block);
 static int bypass_proc_remove_dev_sd(struct bpctl_dev *pbp_device_block);
-static int bp_proc_create(void);
=20
 static int is_bypass_fn(struct bpctl_dev *pbpctl_dev);
 static int get_dev_idx_bsf(int bus, int slot, int func);
@@ -6399,25 +6398,6 @@ static int __init bypass_init_module(void)
 	}
=20
 	register_netdevice_notifier(&bp_notifier_block);
-#ifdef BP_PROC_SUPPORT
-	{
-		int i =3D 0;
-		/* unsigned long flags; */
-		/* rcu_read_lock(); */
-		bp_proc_create();
-		for (i =3D 0; i < device_num; i++) {
-			if (bpctl_dev_arr[i].ifindex) {
-				/* spin_lock_irqsave(&bpvm_lock, flags); */
-				bypass_proc_remove_dev_sd(&bpctl_dev_arr[i]);
-				bypass_proc_create_dev_sd(&bpctl_dev_arr[i]);
-				/* spin_unlock_irqrestore(&bpvm_lock, flags); */
-			}
-
-		}
-		/* rcu_read_unlock(); */
-	}
-#endif
-
 	return 0;
 }
=20
@@ -6431,13 +6411,6 @@ static void __exit bypass_cleanup_module(void)
=20
 	for (i =3D 0; i < device_num; i++) {
 		/* unsigned long flags; */
-#ifdef BP_PROC_SUPPORT
-/*	spin_lock_irqsave(&bpvm_lock, flags);
-	rcu_read_lock(); */
-		bypass_proc_remove_dev_sd(&bpctl_dev_arr[i]);
-/*	spin_unlock_irqrestore(&bpvm_lock, flags);
-	rcu_read_unlock(); */
-#endif
 		remove_bypass_wd_auto(&bpctl_dev_arr[i]);
 		bpctl_dev_arr[i].reset_time =3D 0;
=20
@@ -6783,18 +6756,6 @@ EXPORT_SYMBOL(bp_if_scan_sd);
=20
 static struct proc_dir_entry *bp_procfs_dir;
=20
-static int bp_proc_create(void)
-{
-	bp_procfs_dir =3D proc_mkdir(BP_PROC_DIR, init_net.proc_net);
-	if (bp_procfs_dir =3D=3D (struct proc_dir_entry *)0) {
-		printk(KERN_DEBUG
-		       "Could not create procfs nicinfo directory %s\n",
-		       BP_PROC_DIR);
-		return -1;
-	}
-	return 0;
-}
-
 static int procfs_add(char *proc_name, const struct file_operations *fops,
 		      struct bpctl_dev *dev)
 {
--=20
1.8.4.5

--3Pql8miugIZX0722
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTX6JOAAoJEDFERKcRJ1ap/icP/iQE7IuCIYEolrbbT/RLGHBG
K/fQsLhzzivXjSC6TohRuSy4oCY10XX6TU9DhoP5r52EdqJsIA/D5oDN6KczTWCt
AZATXfM5DsvpVUNBDdhtzwbqiMibIXf5E9a4s611cQkWm8XeOsUEWQSEz91CqFrF
M/HUfVeSQ63MXQcK9dHkXLiaCImVq9jpJrJzHaN+sReu3AyXLGHYX/zObMrHBs1u
bVvDFsw7fItxcvZocnfxKMStweUsEjxeQErvTmSl9o07CHPkTepeTwCFYuIZ5bVt
0SvjqIA3FDLiTzee5np6hf7Uih/2Ob37u6fVkOs6VW+eqIyDaPhzdHe01ExsV0st
FwdYehd95rPYCPgn4grpOLm4ssB6TqwRpfe8N3sT5WWTg4j1AKOAx/gPgis25ZQh
3T4G0sOKDCPYOkPKsK8NoFZgZuAkcHgn0NRufc6m3w1SY4M2tKDlxZ/6bYDv691h
z9z6GUbah2SVT3O1pNwGionyRq8vZijvCeBmbWaVmj5fqXCD2/baDf4WEBlUSfoV
Ofy1iLGrue2yqyRLoNuk5rcE/tRxgKyzWxntYjmL+SuctOxvBlo/Ddm4xgUwj1rq
fwecbEEjV2LymOfGOlU9rMANy6aPSPVB3r3KR9quso4WGx7Xs3Yi7FojE2Ggj587
lxPsgql2C2DkaqiYbBxG
=eikq
-----END PGP SIGNATURE-----

--3Pql8miugIZX0722--
