Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbaHZUEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 16:04:15 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:27911
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753771AbaHZUEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 16:04:13 -0400
X-IronPort-AV: E=Sophos;i="5.04,406,1406584800"; 
   d="scan'208";a="76735328"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        "Drokin, Oleg" <oleg.drokin@intel.com>, Peng Tao <bergwolf@gmail.com>
Subject: [PATCH] staging: lustre: remove parentheses from return arguments
Date: Tue, 26 Aug 2014 22:00:33 +0200
Message-Id: <1409083233-25107-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier i;
constant c;
@@

return
- (
    \(i\|-i\|i(...)\|c\)
- )
  ;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c    |    2 -
 drivers/staging/lustre/lnet/lnet/api-ni.c                 |    4 +-
 drivers/staging/lustre/lnet/lnet/router.c                 |    2 -
 drivers/staging/lustre/lustre/ldlm/ldlm_lib.c             |    6 +--
 drivers/staging/lustre/lustre/libcfs/linux/linux-module.c |   10 +++---
 drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c  |   10 +++---
 drivers/staging/lustre/lustre/libcfs/module.c             |    8 ++---
 drivers/staging/lustre/lustre/llite/llite_lib.c           |    6 +--
 drivers/staging/lustre/lustre/llite/xattr.c               |    2 -
 drivers/staging/lustre/lustre/obdclass/idmap.c            |    2 -
 drivers/staging/lustre/lustre/obdclass/lprocfs_status.c   |    4 +-
 drivers/staging/lustre/lustre/obdclass/obd_mount.c        |    2 -
 drivers/staging/lustre/lustre/obdecho/echo.c              |    6 +--
 drivers/staging/lustre/lustre/obdecho/echo_client.c       |   22 +++++++-------
 drivers/staging/lustre/lustre/osc/osc_request.c           |   20 ++++++------
 drivers/staging/lustre/lustre/ptlrpc/client.c             |    4 +-
 drivers/staging/lustre/lustre/ptlrpc/events.c             |    4 +-
 drivers/staging/lustre/lustre/ptlrpc/llog_client.c        |    2 -
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c             |   10 +++---
 drivers/staging/lustre/lustre/ptlrpc/pinger.c             |    4 +-
 drivers/staging/lustre/lustre/ptlrpc/service.c            |    4 +-
 21 files changed, 67 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
index 306d728..53c5e98 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -1487,7 +1487,7 @@ kiblnd_send (lnet_ni_t *ni, void *private, lnet_msg_t *lntmsg)
 	switch (type) {
 	default:
 		LBUG();
-		return (-EIO);
+		return -EIO;
 
 	case LNET_MSG_ACK:
 		LASSERT (payload_nob == 0);
diff --git a/drivers/staging/lustre/lnet/lnet/api-ni.c b/drivers/staging/lustre/lnet/lnet/api-ni.c
index b28734a..4aebcd7 100644
--- a/drivers/staging/lustre/lnet/lnet/api-ni.c
+++ b/drivers/staging/lustre/lnet/lnet/api-ni.c
@@ -377,7 +377,7 @@ lnet_freelist_init (lnet_freelist_t *fl, int n, int size)
 
 	LIBCFS_ALLOC(space, n * size);
 	if (space == NULL)
-		return (-ENOMEM);
+		return -ENOMEM;
 
 	INIT_LIST_HEAD (&fl->fl_list);
 	fl->fl_objs = space;
@@ -391,7 +391,7 @@ lnet_freelist_init (lnet_freelist_t *fl, int n, int size)
 		space += size;
 	} while (--n != 0);
 
-	return (0);
+	return 0;
 }
 
 void
diff --git a/drivers/staging/lustre/lnet/lnet/router.c b/drivers/staging/lustre/lnet/lnet/router.c
index ac38ad2..b5b8fb5 100644
--- a/drivers/staging/lustre/lnet/lnet/router.c
+++ b/drivers/staging/lustre/lnet/lnet/router.c
@@ -321,7 +321,7 @@ lnet_add_route(__u32 net, unsigned int hops, lnet_nid_t gateway,
 	    LNET_NETTYP(net) == LOLND ||
 	    LNET_NIDNET(gateway) == net ||
 	    hops < 1 || hops > 255)
-		return (-EINVAL);
+		return -EINVAL;
 
 	if (lnet_islocalnet(net))	       /* it's a local network */
 		return 0;		       /* ignore the route entry */
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
index fda9926..8307896 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
@@ -640,18 +640,18 @@ int target_send_reply_msg(struct ptlrpc_request *req, int rc, int fail_id)
 {
 	if (OBD_FAIL_CHECK_ORSET(fail_id & ~OBD_FAIL_ONCE, OBD_FAIL_ONCE)) {
 		DEBUG_REQ(D_ERROR, req, "dropping reply");
-		return (-ECOMM);
+		return -ECOMM;
 	}
 
 	if (unlikely(rc)) {
 		DEBUG_REQ(D_NET, req, "processing error (%d)", rc);
 		req->rq_status = rc;
-		return (ptlrpc_send_error(req, 1));
+		return ptlrpc_send_error(req, 1);
 	} else {
 		DEBUG_REQ(D_NET, req, "sending reply");
 	}
 
-	return (ptlrpc_send_reply(req, PTLRPC_REPLY_MAYBE_DIFFICULT));
+	return ptlrpc_send_reply(req, PTLRPC_REPLY_MAYBE_DIFFICULT);
 }
 
 void target_send_reply(struct ptlrpc_request *req, int rc, int fail_id)
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
index de3c199..a5effcd 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-module.c
@@ -105,12 +105,12 @@ libcfs_psdev_open(struct inode *inode, struct file *file)
 	int    rc = 0;
 
 	if (!inode)
-		return (-EINVAL);
+		return -EINVAL;
 	pdu = (struct libcfs_device_userstate **)&file->private_data;
 	if (libcfs_psdev_ops.p_open != NULL)
 		rc = libcfs_psdev_ops.p_open(0, (void *)pdu);
 	else
-		return (-EPERM);
+		return -EPERM;
 	return rc;
 }
 
@@ -122,7 +122,7 @@ libcfs_psdev_release(struct inode *inode, struct file *file)
 	int    rc = 0;
 
 	if (!inode)
-		return (-EINVAL);
+		return -EINVAL;
 	pdu = file->private_data;
 	if (libcfs_psdev_ops.p_close != NULL)
 		rc = libcfs_psdev_ops.p_close(0, (void *)pdu);
@@ -145,14 +145,14 @@ static long libcfs_ioctl(struct file *file,
 	     _IOC_NR(cmd) > IOC_LIBCFS_MAX_NR) {
 		CDEBUG(D_IOCTL, "invalid ioctl ( type %d, nr %d, size %d )\n",
 		       _IOC_TYPE(cmd), _IOC_NR(cmd), _IOC_SIZE(cmd));
-		return (-EINVAL);
+		return -EINVAL;
 	}
 
 	/* Handle platform-dependent IOC requests */
 	switch (cmd) {
 	case IOC_LIBCFS_PANIC:
 		if (!capable(CFS_CAP_SYS_BOOT))
-			return (-EPERM);
+			return -EPERM;
 		panic("debugctl-invoked panic");
 		return 0;
 	case IOC_LIBCFS_MEMHOG:
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
index a93b621..939b33d 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
@@ -298,7 +298,7 @@ libcfs_sock_write (struct socket *sock, void *buffer, int nob, int timeout)
 
 		if (rc == 0) {
 			CERROR ("Unexpected zero rc\n");
-			return (-ECONNABORTED);
+			return -ECONNABORTED;
 		}
 
 		if (ticks <= 0)
@@ -308,7 +308,7 @@ libcfs_sock_write (struct socket *sock, void *buffer, int nob, int timeout)
 		nob -= rc;
 	}
 
-	return (0);
+	return 0;
 }
 EXPORT_SYMBOL(libcfs_sock_write);
 
@@ -384,7 +384,7 @@ libcfs_sock_create (struct socket **sockp, int *fatal,
 	*sockp = sock;
 	if (rc != 0) {
 		CERROR ("Can't create socket: %d\n", rc);
-		return (rc);
+		return rc;
 	}
 
 	option = 1;
@@ -436,7 +436,7 @@ libcfs_sock_setbuf (struct socket *sock, int txbufsize, int rxbufsize)
 		if (rc != 0) {
 			CERROR ("Can't set send buffer %d: %d\n",
 				option, rc);
-			return (rc);
+			return rc;
 		}
 	}
 
@@ -447,7 +447,7 @@ libcfs_sock_setbuf (struct socket *sock, int txbufsize, int rxbufsize)
 		if (rc != 0) {
 			CERROR ("Can't set receive buffer %d: %d\n",
 				option, rc);
-			return (rc);
+			return rc;
 		}
 	}
 
diff --git a/drivers/staging/lustre/lustre/libcfs/module.c b/drivers/staging/lustre/lustre/libcfs/module.c
index 3396858..a79ce08 100644
--- a/drivers/staging/lustre/lustre/libcfs/module.c
+++ b/drivers/staging/lustre/lustre/libcfs/module.c
@@ -119,7 +119,7 @@ kportal_memhog_alloc(struct libcfs_device_userstate *ldu, int npages,
 	       count1 < PAGE_CACHE_SIZE/sizeof(struct page *)) {
 
 		if (cfs_signal_pending())
-			return (-EINTR);
+			return -EINTR;
 
 		*level1p = alloc_page(flags);
 		if (*level1p == NULL)
@@ -134,11 +134,11 @@ kportal_memhog_alloc(struct libcfs_device_userstate *ldu, int npages,
 		       count2 < PAGE_CACHE_SIZE/sizeof(struct page *)) {
 
 			if (cfs_signal_pending())
-				return (-EINTR);
+				return -EINTR;
 
 			*level2p = alloc_page(flags);
 			if (*level2p == NULL)
-				return (-ENOMEM);
+				return -ENOMEM;
 			ldu->ldu_memhog_pages++;
 
 			level2p++;
@@ -351,7 +351,7 @@ static int init_libcfs_module(void)
 	rc = libcfs_debug_init(5 * 1024 * 1024);
 	if (rc < 0) {
 		printk(KERN_ERR "LustreError: libcfs_debug_init: %d\n", rc);
-		return (rc);
+		return rc;
 	}
 
 	rc = cfs_cpu_init();
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index ff375d3..7874555 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -761,9 +761,9 @@ void ll_kill_super(struct super_block *sb)
 static inline int ll_set_opt(const char *opt, char *data, int fl)
 {
 	if (strncmp(opt, data, strlen(opt)) != 0)
-		return(0);
+		return 0;
 	else
-		return(fl);
+		return fl;
 }
 
 /* non-client-specific mount options are parsed in lmd_parse */
@@ -2212,7 +2212,7 @@ int ll_process_config(struct lustre_cfg *lcfg)
 				      lcfg, sb);
 	if (rc > 0)
 		rc = 0;
-	return(rc);
+	return rc;
 }
 
 /* this function prepares md_op_data hint for passing ot down to MD stack. */
diff --git a/drivers/staging/lustre/lustre/llite/xattr.c b/drivers/staging/lustre/lustre/llite/xattr.c
index 665ca57..37bd349 100644
--- a/drivers/staging/lustre/lustre/llite/xattr.c
+++ b/drivers/staging/lustre/lustre/llite/xattr.c
@@ -526,7 +526,7 @@ out:
 			ptlrpc_req_finished(request);
 		else if (lmm)
 			obd_free_diskmd(ll_i2dtexp(inode), &lmm);
-		return(rc);
+		return rc;
 	}
 
 	return ll_getxattr_common(inode, name, buffer, size, OBD_MD_FLXATTR);
diff --git a/drivers/staging/lustre/lustre/obdclass/idmap.c b/drivers/staging/lustre/lustre/obdclass/idmap.c
index 1190885..4c94baf 100644
--- a/drivers/staging/lustre/lustre/obdclass/idmap.c
+++ b/drivers/staging/lustre/lustre/obdclass/idmap.c
@@ -443,7 +443,7 @@ struct lustre_idmap_table *lustre_idmap_init(void)
 
 	OBD_ALLOC_PTR(t);
 	if(unlikely(t == NULL))
-		return (ERR_PTR(-ENOMEM));
+		return ERR_PTR(-ENOMEM);
 
 	spin_lock_init(&t->lit_lock);
 	for (i = 0; i < ARRAY_SIZE(t->lit_idmaps); i++)
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 8309d4c..90a1e11 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -1922,8 +1922,8 @@ int lprocfs_obd_seq_create(struct obd_device *dev,
 			   const struct file_operations *seq_fops,
 			   void *data)
 {
-	return (lprocfs_seq_create(dev->obd_proc_entry, name,
-				   mode, seq_fops, data));
+	return lprocfs_seq_create(dev->obd_proc_entry, name,
+				  mode, seq_fops, data);
 }
 EXPORT_SYMBOL(lprocfs_obd_seq_create);
 
diff --git a/drivers/staging/lustre/lustre/obdclass/obd_mount.c b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
index d972f71..47d5573 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_mount.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
@@ -174,7 +174,7 @@ int do_lcfg(char *cfgname, lnet_nid_t nid, int cmd,
 	lcfg->lcfg_nid = nid;
 	rc = class_process_config(lcfg);
 	lustre_cfg_free(lcfg);
-	return(rc);
+	return rc;
 }
 EXPORT_SYMBOL(do_lcfg);
 
diff --git a/drivers/staging/lustre/lustre/obdecho/echo.c b/drivers/staging/lustre/lustre/obdecho/echo.c
index 358be90..3d0686d 100644
--- a/drivers/staging/lustre/lustre/obdecho/echo.c
+++ b/drivers/staging/lustre/lustre/obdecho/echo.c
@@ -276,7 +276,7 @@ echo_page_debug_check(struct page *page, u64 id,
 
 	kunmap(page);
 
-	return (rc);
+	return rc;
 }
 
 /* This allows us to verify that desc_private is passed unmolested */
@@ -659,7 +659,7 @@ int echo_persistent_pages_init(void)
 		OBD_PAGE_ALLOC(pg, gfp_mask);
 		if (pg == NULL) {
 			echo_persistent_pages_fini ();
-			return (-ENOMEM);
+			return -ENOMEM;
 		}
 
 		memset (kmap (pg), 0, PAGE_CACHE_SIZE);
@@ -668,5 +668,5 @@ int echo_persistent_pages_init(void)
 		echo_persistent_pages[i] = pg;
 	}
 
-	return (0);
+	return 0;
 }
diff --git a/drivers/staging/lustre/lustre/obdecho/echo_client.c b/drivers/staging/lustre/lustre/obdecho/echo_client.c
index 2273669..17c78a4 100644
--- a/drivers/staging/lustre/lustre/obdecho/echo_client.c
+++ b/drivers/staging/lustre/lustre/obdecho/echo_client.c
@@ -922,7 +922,7 @@ out:
 	default:
 		break;
 	}
-	return(ERR_PTR(rc));
+	return ERR_PTR(rc);
 }
 
 static int echo_device_init(const struct lu_env *env, struct lu_device *d,
@@ -1384,15 +1384,15 @@ echo_copyout_lsm (struct lov_stripe_md *lsm, void *_ulsm, int ulsm_nob)
 
 	nob = offsetof (struct lov_stripe_md, lsm_oinfo[lsm->lsm_stripe_count]);
 	if (nob > ulsm_nob)
-		return (-EINVAL);
+		return -EINVAL;
 
 	if (copy_to_user (ulsm, lsm, sizeof(*ulsm)))
-		return (-EFAULT);
+		return -EFAULT;
 
 	for (i = 0; i < lsm->lsm_stripe_count; i++) {
 		if (copy_to_user (ulsm->lsm_oinfo[i], lsm->lsm_oinfo[i],
 				      sizeof(lsm->lsm_oinfo[0])))
-			return (-EFAULT);
+			return -EFAULT;
 	}
 	return 0;
 }
@@ -1405,16 +1405,16 @@ echo_copyin_lsm (struct echo_device *ed, struct lov_stripe_md *lsm,
 	int		     i;
 
 	if (ulsm_nob < sizeof (*lsm))
-		return (-EINVAL);
+		return -EINVAL;
 
 	if (copy_from_user (lsm, ulsm, sizeof (*lsm)))
-		return (-EFAULT);
+		return -EFAULT;
 
 	if (lsm->lsm_stripe_count > ec->ec_nstripes ||
 	    lsm->lsm_magic != LOV_MAGIC ||
 	    (lsm->lsm_stripe_size & (~CFS_PAGE_MASK)) != 0 ||
 	    ((__u64)lsm->lsm_stripe_size * lsm->lsm_stripe_count > ~0UL))
-		return (-EINVAL);
+		return -EINVAL;
 
 
 	for (i = 0; i < lsm->lsm_stripe_count; i++) {
@@ -1422,9 +1422,9 @@ echo_copyin_lsm (struct echo_device *ed, struct lov_stripe_md *lsm,
 				       ((struct lov_stripe_md *)ulsm)-> \
 				       lsm_oinfo[i],
 				       sizeof(lsm->lsm_oinfo[0])))
-			return (-EFAULT);
+			return -EFAULT;
 	}
-	return (0);
+	return 0;
 }
 
 static inline void echo_md_build_name(struct lu_name *lname, char *name,
@@ -2282,7 +2282,7 @@ static int echo_create_object(const struct lu_env *env, struct echo_device *ed,
 		echo_free_memmd(ed, &lsm);
 	if (rc)
 		CERROR("create object failed with: rc = %d\n", rc);
-	return (rc);
+	return rc;
 }
 
 static int echo_get_object(struct echo_object **ecop, struct echo_device *ed,
@@ -3008,7 +3008,7 @@ static int echo_client_setup(const struct lu_env *env,
 	if (rc != 0) {
 		CERROR("fail to connect to device %s\n",
 		       lustre_cfg_string(lcfg, 1));
-		return (rc);
+		return rc;
 	}
 
 	return rc;
diff --git a/drivers/staging/lustre/lustre/osc/osc_request.c b/drivers/staging/lustre/lustre/osc/osc_request.c
index c502f34..e656190 100644
--- a/drivers/staging/lustre/lustre/osc/osc_request.c
+++ b/drivers/staging/lustre/lustre/osc/osc_request.c
@@ -1114,7 +1114,7 @@ static int check_write_rcs(struct ptlrpc_request *req,
 						  niocount);
 	if (remote_rcs == NULL) {
 		CDEBUG(D_INFO, "Missing/short RC vector on BRW_WRITE reply\n");
-		return(-EPROTO);
+		return -EPROTO;
 	}
 
 	/* return error if any niobuf was in error */
@@ -1125,17 +1125,17 @@ static int check_write_rcs(struct ptlrpc_request *req,
 		if (remote_rcs[i] != 0) {
 			CDEBUG(D_INFO, "rc[%d] invalid (%d) req %p\n",
 				i, remote_rcs[i], req);
-			return(-EPROTO);
+			return -EPROTO;
 		}
 	}
 
 	if (req->rq_bulk->bd_nob_transferred != requested_nob) {
 		CERROR("Unexpected # bytes transferred: %d (requested %d)\n",
 		       req->rq_bulk->bd_nob_transferred, requested_nob);
-		return(-EPROTO);
+		return -EPROTO;
 	}
 
-	return (0);
+	return 0;
 }
 
 static inline int can_merge_pages(struct brw_page *p1, struct brw_page *p2)
@@ -1544,7 +1544,7 @@ static int osc_brw_fini_request(struct ptlrpc_request *req, int rc)
 	if (rc != req->rq_bulk->bd_nob_transferred) {
 		CERROR ("Unexpected rc %d (%d transferred)\n",
 			rc, req->rq_bulk->bd_nob_transferred);
-		return (-EPROTO);
+		return -EPROTO;
 	}
 
 	if (rc < aa->aa_requested_nob)
@@ -1634,7 +1634,7 @@ restart_bulk:
 	rc = osc_brw_prep_request(cmd, &exp->exp_obd->u.cli, oa, lsm,
 				  page_count, pga, &req, ocapa, 0, resends);
 	if (rc != 0)
-		return (rc);
+		return rc;
 
 	if (resends) {
 		req->rq_generation_set = 1;
@@ -2290,10 +2290,10 @@ static int osc_find_cbdata(struct obd_export *exp, struct lov_stripe_md *lsm,
 	ostid_build_res_name(&lsm->lsm_oi, &res_id);
 	rc = ldlm_resource_iterate(obd->obd_namespace, &res_id, replace, data);
 	if (rc == LDLM_ITER_STOP)
-		return(1);
+		return 1;
 	if (rc == LDLM_ITER_CONTINUE)
-		return(0);
-	return(rc);
+		return 0;
+	return rc;
 }
 
 static int osc_enqueue_fini(struct ptlrpc_request *req, struct ost_lvb *lvb,
@@ -3559,7 +3559,7 @@ int osc_process_config_base(struct obd_device *obd, struct lustre_cfg *lcfg)
 		break;
 	}
 
-	return(rc);
+	return rc;
 }
 
 static int osc_process_config(struct obd_device *obd, u32 len, void *buf)
diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index 8fa9b71..d04b5d0 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -313,14 +313,14 @@ static int unpack_reply(struct ptlrpc_request *req)
 		rc = ptlrpc_unpack_rep_msg(req, req->rq_replen);
 		if (rc) {
 			DEBUG_REQ(D_ERROR, req, "unpack_rep failed: %d", rc);
-			return(-EPROTO);
+			return -EPROTO;
 		}
 	}
 
 	rc = lustre_unpack_rep_ptlrpc_body(req, MSG_PTLRPC_BODY_OFF);
 	if (rc) {
 		DEBUG_REQ(D_ERROR, req, "unpack ptlrpc body failed: %d", rc);
-		return(-EPROTO);
+		return -EPROTO;
 	}
 	return 0;
 }
diff --git a/drivers/staging/lustre/lustre/ptlrpc/events.c b/drivers/staging/lustre/lustre/ptlrpc/events.c
index c3ec21d..97b7f45 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/events.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/events.c
@@ -541,7 +541,7 @@ int ptlrpc_ni_init(void)
 	rc = LNetNIInit(pid);
 	if (rc < 0) {
 		CDEBUG(D_NET, "Can't init network interface: %d\n", rc);
-		return (-ENOENT);
+		return -ENOENT;
 	}
 
 	/* CAVEAT EMPTOR: how we process portals events is _radically_
@@ -557,7 +557,7 @@ int ptlrpc_ni_init(void)
 	CERROR("Failed to allocate event queue: %d\n", rc);
 	LNetNIFini();
 
-	return (-ENOMEM);
+	return -ENOMEM;
 }
 
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/llog_client.c b/drivers/staging/lustre/lustre/ptlrpc/llog_client.c
index 6a1ab5c..3cced5b 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/llog_client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/llog_client.c
@@ -331,7 +331,7 @@ static int llog_client_close(const struct lu_env *env,
 	/* this doesn't call LLOG_ORIGIN_HANDLE_CLOSE because
 	   the servers all close the file at the end of every
 	   other LLOG_ RPC. */
-	return(0);
+	return 0;
 }
 
 struct llog_operations llog_client_ops = {
diff --git a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
index 89fc7f7..8fb37f0 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
@@ -443,7 +443,7 @@ int ptlrpc_reply(struct ptlrpc_request *req)
 	if (req->rq_no_reply)
 		return 0;
 	else
-		return (ptlrpc_send_reply(req, 0));
+		return ptlrpc_send_reply(req, 0);
 }
 EXPORT_SYMBOL(ptlrpc_reply);
 
@@ -691,7 +691,7 @@ int ptlrpc_register_rqbd(struct ptlrpc_request_buffer_desc *rqbd)
 	       service->srv_req_portal);
 
 	if (OBD_FAIL_CHECK(OBD_FAIL_PTLRPC_RQBD))
-		return (-ENOMEM);
+		return -ENOMEM;
 
 	/* NB: CPT affinity service should use new LNet flag LNET_INS_LOCAL,
 	 * which means buffer can only be attached on local CPT, and LND
@@ -702,7 +702,7 @@ int ptlrpc_register_rqbd(struct ptlrpc_request_buffer_desc *rqbd)
 			  LNET_INS_LOCAL : LNET_INS_AFTER, &me_h);
 	if (rc != 0) {
 		CERROR("LNetMEAttach failed: %d\n", rc);
-		return (-ENOMEM);
+		return -ENOMEM;
 	}
 
 	LASSERT(rqbd->rqbd_refcount == 0);
@@ -718,7 +718,7 @@ int ptlrpc_register_rqbd(struct ptlrpc_request_buffer_desc *rqbd)
 
 	rc = LNetMDAttach(me_h, md, LNET_UNLINK, &rqbd->rqbd_md_h);
 	if (rc == 0)
-		return (0);
+		return 0;
 
 	CERROR("LNetMDAttach failed: %d;\n", rc);
 	LASSERT(rc == -ENOMEM);
@@ -726,5 +726,5 @@ int ptlrpc_register_rqbd(struct ptlrpc_request_buffer_desc *rqbd)
 	LASSERT(rc == 0);
 	rqbd->rqbd_refcount = 0;
 
-	return (-ENOMEM);
+	return -ENOMEM;
 }
diff --git a/drivers/staging/lustre/lustre/ptlrpc/pinger.c b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
index 5e4e49f..e895ff4 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pinger.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
@@ -434,7 +434,7 @@ struct timeout_item* ptlrpc_new_timeout(int time, enum timeout_event event,
 
 	OBD_ALLOC_PTR(ti);
 	if (!ti)
-		return(NULL);
+		return NULL;
 
 	INIT_LIST_HEAD(&ti->ti_obd_list);
 	INIT_LIST_HEAD(&ti->ti_chain);
@@ -489,7 +489,7 @@ int ptlrpc_add_timeout_client(int time, enum timeout_event event,
 	ti = ptlrpc_pinger_register_timeout(time, event, cb, data);
 	if (!ti) {
 		mutex_unlock(&pinger_mutex);
-		return (-EINVAL);
+		return -EINVAL;
 	}
 	list_add(obd_list, &ti->ti_obd_list);
 	mutex_unlock(&pinger_mutex);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/service.c b/drivers/staging/lustre/lustre/ptlrpc/service.c
index c88eae27b..27a3041 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/service.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/service.c
@@ -1172,13 +1172,13 @@ static int ptlrpc_at_add_timed(struct ptlrpc_request *req)
 	__u32 index;
 
 	if (AT_OFF)
-		return(0);
+		return 0;
 
 	if (req->rq_no_reply)
 		return 0;
 
 	if ((lustre_msghdr_get_flags(req->rq_reqmsg) & MSGHDR_AT_SUPPORT) == 0)
-		return(-ENOSYS);
+		return -ENOSYS;
 
 	spin_lock(&svcpt->scp_at_lock);
 	LASSERT(list_empty(&req->rq_timed_list));

