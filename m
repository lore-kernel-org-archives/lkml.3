Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaHOQ4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:56:50 -0400
Received: from linuxhacker.ru ([217.76.32.60]:41334 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbaHOQ4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:56:19 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 2/2] staging/lustre: get rid of obd_* typedefs
Date: Fri, 15 Aug 2014 12:55:56 -0400
Message-Id: <1408121756-29186-3-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121756-29186-1-git-send-email-green@linuxhacker.ru>
References: <1408121756-29186-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a bunch of typedefs for common things that made no sense
and hid the actual type from plain view.
Replace them with proper uXX or sXX types.
Exception is in lustre_idl.h where
they are replaced with __uXX and __sXX to be able to be included
in userspace

Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
---
 drivers/staging/lustre/lustre/include/cl_object.h  |   4 +-
 drivers/staging/lustre/lustre/include/lclient.h    |   2 +-
 .../lustre/lustre/include/linux/obd_class.h        |   6 +-
 drivers/staging/lustre/lustre/include/lu_object.h  |   6 +-
 .../lustre/lustre/include/lustre/lustre_idl.h      | 122 +++++++++------------
 drivers/staging/lustre/lustre/include/lustre_lib.h |   8 +-
 .../staging/lustre/lustre/include/lustre_lite.h    |   2 +-
 drivers/staging/lustre/lustre/include/obd.h        |  48 ++++----
 drivers/staging/lustre/lustre/include/obd_cksum.h  |   6 +-
 drivers/staging/lustre/lustre/include/obd_class.h  |  24 ++--
 drivers/staging/lustre/lustre/include/obd_ost.h    |   2 +-
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c |   4 +-
 drivers/staging/lustre/lustre/llite/file.c         |   7 +-
 .../staging/lustre/lustre/llite/llite_internal.h   |   4 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   2 +-
 drivers/staging/lustre/lustre/llite/llite_rmtacl.c |   2 +-
 drivers/staging/lustre/lustre/llite/lloop.c        |   2 +-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |   8 +-
 .../staging/lustre/lustre/lov/lov_cl_internal.h    |   4 +-
 drivers/staging/lustre/lustre/lov/lov_ea.c         |   8 +-
 drivers/staging/lustre/lustre/lov/lov_internal.h   |  28 ++---
 drivers/staging/lustre/lustre/lov/lov_io.c         |   8 +-
 drivers/staging/lustre/lustre/lov/lov_lock.c       |  24 ++--
 drivers/staging/lustre/lustre/lov/lov_merge.c      |  14 +--
 drivers/staging/lustre/lustre/lov/lov_obd.c        |  44 ++++----
 drivers/staging/lustre/lustre/lov/lov_offset.c     |  29 +++--
 drivers/staging/lustre/lustre/lov/lov_pack.c       |   4 +-
 drivers/staging/lustre/lustre/lov/lov_page.c       |   2 +-
 drivers/staging/lustre/lustre/lov/lov_request.c    |  18 +--
 drivers/staging/lustre/lustre/lov/lovsub_dev.c     |   2 +-
 drivers/staging/lustre/lustre/mdc/mdc_internal.h   |   2 +-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |   2 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |  14 +--
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |   4 +-
 drivers/staging/lustre/lustre/obdclass/cl_io.c     |   2 +-
 .../lustre/lustre/obdclass/linux/linux-obdo.c      |   8 +-
 .../staging/lustre/lustre/obdclass/local_storage.c |   2 +-
 drivers/staging/lustre/lustre/obdclass/obdo.c      |  12 +-
 drivers/staging/lustre/lustre/obdecho/echo.c       |  21 ++--
 .../staging/lustre/lustre/obdecho/echo_client.c    |  58 +++++-----
 drivers/staging/lustre/lustre/osc/lproc_osc.c      |   2 +-
 drivers/staging/lustre/lustre/osc/osc_cache.c      |   2 +-
 .../staging/lustre/lustre/osc/osc_cl_internal.h    |   2 +-
 drivers/staging/lustre/lustre/osc/osc_internal.h   |   6 +-
 drivers/staging/lustre/lustre/osc/osc_io.c         |   2 +-
 drivers/staging/lustre/lustre/osc/osc_quota.c      |   8 +-
 drivers/staging/lustre/lustre/osc/osc_request.c    |  46 ++++----
 drivers/staging/lustre/lustre/ptlrpc/layout.c      |   4 +-
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    |   6 +-
 49 files changed, 315 insertions(+), 332 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/cl_object.h b/drivers/staging/lustre/lustre/include/cl_object.h
index e51cd69..41858e4 100644
--- a/drivers/staging/lustre/lustre/include/cl_object.h
+++ b/drivers/staging/lustre/lustre/include/cl_object.h
@@ -2508,7 +2508,7 @@ struct cl_req_operations {
 	void (*cro_attr_set)(const struct lu_env *env,
 			     const struct cl_req_slice *slice,
 			     const struct cl_object *obj,
-			     struct cl_req_attr *attr, obd_valid flags);
+			     struct cl_req_attr *attr, u64 flags);
 	/**
 	 * Called top-to-bottom from cl_req_completion() to notify layers that
 	 * transfer completed. Has to free all state allocated by
@@ -3182,7 +3182,7 @@ void cl_req_page_add  (const struct lu_env *env, struct cl_req *req,
 void cl_req_page_done (const struct lu_env *env, struct cl_page *page);
 int  cl_req_prep      (const struct lu_env *env, struct cl_req *req);
 void cl_req_attr_set  (const struct lu_env *env, struct cl_req *req,
-		       struct cl_req_attr *attr, obd_valid flags);
+		       struct cl_req_attr *attr, u64 flags);
 void cl_req_completion(const struct lu_env *env, struct cl_req *req, int ioret);
 
 /** \defgroup cl_sync_io cl_sync_io
diff --git a/drivers/staging/lustre/lustre/include/lclient.h b/drivers/staging/lustre/lustre/include/lclient.h
index 386a36c..fa45c94 100644
--- a/drivers/staging/lustre/lustre/include/lclient.h
+++ b/drivers/staging/lustre/lustre/include/lclient.h
@@ -350,7 +350,7 @@ void ccc_req_completion(const struct lu_env *env,
 			const struct cl_req_slice *slice, int ioret);
 void ccc_req_attr_set(const struct lu_env *env,const struct cl_req_slice *slice,
 		      const struct cl_object *obj,
-		      struct cl_req_attr *oa, obd_valid flags);
+		      struct cl_req_attr *oa, u64 flags);
 
 struct lu_device   *ccc2lu_dev      (struct ccc_device *vdv);
 struct lu_object   *ccc2lu	  (struct ccc_object *vob);
diff --git a/drivers/staging/lustre/lustre/include/linux/obd_class.h b/drivers/staging/lustre/lustre/include/linux/obd_class.h
index 021ead6..99c5bd1 100644
--- a/drivers/staging/lustre/lustre/include/linux/obd_class.h
+++ b/drivers/staging/lustre/lustre/include/linux/obd_class.h
@@ -49,9 +49,9 @@
 
 /* obdo.c */
 void obdo_from_la(struct obdo *dst, struct lu_attr *la, __u64 valid);
-void la_from_obdo(struct lu_attr *la, struct obdo *dst, obd_flag valid);
-void obdo_refresh_inode(struct inode *dst, struct obdo *src, obd_flag valid);
-void obdo_to_inode(struct inode *dst, struct obdo *src, obd_flag valid);
+void la_from_obdo(struct lu_attr *la, struct obdo *dst, u32 valid);
+void obdo_refresh_inode(struct inode *dst, struct obdo *src, u32 valid);
+void obdo_to_inode(struct inode *dst, struct obdo *src, u32 valid);
 #define ll_inode_flags(inode)	 (inode->i_flags)
 
 
diff --git a/drivers/staging/lustre/lustre/include/lu_object.h b/drivers/staging/lustre/lustre/include/lu_object.h
index d5c368b..a6ce42a 100644
--- a/drivers/staging/lustre/lustre/include/lu_object.h
+++ b/drivers/staging/lustre/lustre/include/lu_object.h
@@ -404,11 +404,11 @@ struct lu_attr {
 	/** size in bytes */
 	__u64	  la_size;
 	/** modification time in seconds since Epoch */
-	obd_time       la_mtime;
+	s64	  la_mtime;
 	/** access time in seconds since Epoch */
-	obd_time       la_atime;
+	s64	  la_atime;
 	/** change time in seconds since Epoch */
-	obd_time       la_ctime;
+	s64	  la_ctime;
 	/** 512-byte blocks allocated to object */
 	__u64	  la_blocks;
 	/** permission bits and file type */
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 186f5e3..570f54f 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -165,20 +165,6 @@
 #define LUSTRE_LOG_VERSION  0x00050000
 #define LUSTRE_MGS_VERSION  0x00060000
 
-typedef __u64 obd_id;
-typedef __u64 obd_seq;
-typedef __s64 obd_time;
-typedef __u64 obd_size;
-typedef __u64 obd_off;
-typedef __u64 obd_blocks;
-typedef __u64 obd_valid;
-typedef __u32 obd_blksize;
-typedef __u32 obd_mode;
-typedef __u32 obd_uid;
-typedef __u32 obd_gid;
-typedef __u32 obd_flag;
-typedef __u32 obd_count;
-
 /**
  * Describes a range of sequence, lsr_start is included but lsr_end is
  * not in the range.
@@ -411,7 +397,7 @@ static inline void fid_zero(struct lu_fid *fid)
 	memset(fid, 0, sizeof(*fid));
 }
 
-static inline obd_id fid_ver_oid(const struct lu_fid *fid)
+static inline __u64 fid_ver_oid(const struct lu_fid *fid)
 {
 	return ((__u64)fid_ver(fid) << 32 | fid_oid(fid));
 }
@@ -475,7 +461,7 @@ enum dot_lustre_oid {
 	FID_OID_DOT_LUSTRE_OBF = 2UL,
 };
 
-static inline int fid_seq_is_mdt0(obd_seq seq)
+static inline int fid_seq_is_mdt0(__u64 seq)
 {
 	return (seq == FID_SEQ_OST_MDT0);
 }
@@ -485,7 +471,7 @@ static inline int fid_seq_is_mdt(const __u64 seq)
 	return seq == FID_SEQ_OST_MDT0 || seq >= FID_SEQ_NORMAL;
 };
 
-static inline int fid_seq_is_echo(obd_seq seq)
+static inline int fid_seq_is_echo(__u64 seq)
 {
 	return (seq == FID_SEQ_ECHO);
 }
@@ -495,7 +481,7 @@ static inline int fid_is_echo(const struct lu_fid *fid)
 	return fid_seq_is_echo(fid_seq(fid));
 }
 
-static inline int fid_seq_is_llog(obd_seq seq)
+static inline int fid_seq_is_llog(__u64 seq)
 {
 	return (seq == FID_SEQ_LLOG);
 }
@@ -595,13 +581,13 @@ static inline int fid_is_norm(const struct lu_fid *fid)
 }
 
 /* convert an OST objid into an IDIF FID SEQ number */
-static inline obd_seq fid_idif_seq(obd_id id, __u32 ost_idx)
+static inline __u64 fid_idif_seq(__u64 id, __u32 ost_idx)
 {
 	return FID_SEQ_IDIF | (ost_idx << 16) | ((id >> 32) & 0xffff);
 }
 
 /* convert a packed IDIF FID into an OST objid */
-static inline obd_id fid_idif_id(obd_seq seq, __u32 oid, __u32 ver)
+static inline __u64 fid_idif_id(__u64 seq, __u32 oid, __u32 ver)
 {
 	return ((__u64)ver << 48) | ((seq & 0xffff) << 32) | oid;
 }
@@ -613,7 +599,7 @@ static inline __u32 fid_idif_ost_idx(const struct lu_fid *fid)
 }
 
 /* extract OST sequence (group) from a wire ost_id (id/seq) pair */
-static inline obd_seq ostid_seq(const struct ost_id *ostid)
+static inline __u64 ostid_seq(const struct ost_id *ostid)
 {
 	if (fid_seq_is_mdt0(ostid->oi.oi_seq))
 		return FID_SEQ_OST_MDT0;
@@ -628,7 +614,7 @@ static inline obd_seq ostid_seq(const struct ost_id *ostid)
 }
 
 /* extract OST objid from a wire ost_id (id/seq) pair */
-static inline obd_id ostid_id(const struct ost_id *ostid)
+static inline __u64 ostid_id(const struct ost_id *ostid)
 {
 	if (fid_seq_is_mdt0(ostid_seq(ostid)))
 		return ostid->oi.oi_id & IDIF_OID_MASK;
@@ -1855,9 +1841,9 @@ extern void lustre_swab_niobuf_remote (struct niobuf_remote *nbr);
 
 struct ost_lvb_v1 {
 	__u64		lvb_size;
-	obd_time	lvb_mtime;
-	obd_time	lvb_atime;
-	obd_time	lvb_ctime;
+	__s64		lvb_mtime;
+	__s64		lvb_atime;
+	__s64		lvb_ctime;
 	__u64		lvb_blocks;
 };
 
@@ -1865,9 +1851,9 @@ extern void lustre_swab_ost_lvb_v1(struct ost_lvb_v1 *lvb);
 
 struct ost_lvb {
 	__u64		lvb_size;
-	obd_time	lvb_mtime;
-	obd_time	lvb_atime;
-	obd_time	lvb_ctime;
+	__s64		lvb_mtime;
+	__s64		lvb_atime;
+	__s64		lvb_ctime;
 	__u64		lvb_blocks;
 	__u32		lvb_mtime_ns;
 	__u32		lvb_atime_ns;
@@ -2248,9 +2234,9 @@ struct mdt_body {
 	struct lustre_handle handle;
 	__u64	  valid;
 	__u64	  size;   /* Offset, in the case of MDS_READPAGE */
-       obd_time	mtime;
-       obd_time	atime;
-       obd_time	ctime;
+	__s64	  mtime;
+	__s64	  atime;
+	__s64	  ctime;
 	__u64	  blocks; /* XID, in the case of MDS_READPAGE */
 	__u64	  ioepoch;
 	__u64	       t_state; /* transient file state defined in
@@ -2333,9 +2319,9 @@ struct mdt_rec_setattr {
 	__u32	   sa_gid;
 	__u64	   sa_size;
 	__u64	   sa_blocks;
-	obd_time	sa_mtime;
-	obd_time	sa_atime;
-	obd_time	sa_ctime;
+	__s64	   sa_mtime;
+	__s64	   sa_atime;
+	__s64	   sa_ctime;
 	__u32	   sa_attr_flags;
 	__u32	   sa_mode;
 	__u32	   sa_bias;      /* some operation flags */
@@ -2464,7 +2450,7 @@ struct mdt_rec_create {
 	struct lu_fid   cr_fid1;
 	struct lu_fid   cr_fid2;
 	struct lustre_handle cr_old_handle; /* handle in case of open replay */
-	obd_time	cr_time;
+	__s64	   cr_time;
 	__u64	   cr_rdev;
 	__u64	   cr_ioepoch;
 	__u64	   cr_padding_1;   /* rr_blocks */
@@ -2504,7 +2490,7 @@ struct mdt_rec_link {
 	__u32	   lk_suppgid2_h;
 	struct lu_fid   lk_fid1;
 	struct lu_fid   lk_fid2;
-	obd_time	lk_time;
+	__s64	   lk_time;
 	__u64	   lk_padding_1;   /* rr_atime */
 	__u64	   lk_padding_2;   /* rr_ctime */
 	__u64	   lk_padding_3;   /* rr_size */
@@ -2531,7 +2517,7 @@ struct mdt_rec_unlink {
 	__u32	   ul_suppgid2_h;
 	struct lu_fid   ul_fid1;
 	struct lu_fid   ul_fid2;
-	obd_time	ul_time;
+	__s64	   ul_time;
 	__u64	   ul_padding_2;   /* rr_atime */
 	__u64	   ul_padding_3;   /* rr_ctime */
 	__u64	   ul_padding_4;   /* rr_size */
@@ -2558,7 +2544,7 @@ struct mdt_rec_rename {
 	__u32	   rn_suppgid2_h;
 	struct lu_fid   rn_fid1;
 	struct lu_fid   rn_fid2;
-	obd_time	rn_time;
+	__s64	   rn_time;
 	__u64	   rn_padding_1;   /* rr_atime */
 	__u64	   rn_padding_2;   /* rr_ctime */
 	__u64	   rn_padding_3;   /* rr_size */
@@ -2588,7 +2574,7 @@ struct mdt_rec_setxattr {
 	__u32	   sx_padding_2;
 	__u32	   sx_padding_3;
 	__u64	   sx_valid;
-	obd_time	sx_time;
+	__s64	   sx_time;
 	__u64	   sx_padding_5;   /* rr_ctime */
 	__u64	   sx_padding_6;   /* rr_size */
 	__u64	   sx_padding_7;   /* rr_blocks */
@@ -2621,9 +2607,9 @@ struct mdt_rec_reint {
 	__u32	   rr_suppgid2_h;
 	struct lu_fid   rr_fid1;
 	struct lu_fid   rr_fid2;
-	obd_time	rr_mtime;
-	obd_time	rr_atime;
-	obd_time	rr_ctime;
+	__s64	   rr_mtime;
+	__s64	   rr_atime;
+	__s64	   rr_ctime;
 	__u64	   rr_size;
 	__u64	   rr_blocks;
 	__u32	   rr_bias;
@@ -2977,8 +2963,8 @@ struct cfg_marker {
 	__u32	     cm_flags;
 	__u32	     cm_vers;       /* lustre release version number */
 	__u32	     cm_padding;    /* 64 bit align */
-	obd_time	  cm_createtime; /*when this record was first created */
-	obd_time	  cm_canceltime; /*when this record is no longer valid*/
+	__s64	     cm_createtime; /*when this record was first created */
+	__s64	     cm_canceltime; /*when this record is no longer valid*/
 	char	      cm_tgtname[MTI_NAME_MAXLEN];
 	char	      cm_comment[MTI_NAME_MAXLEN];
 };
@@ -3082,16 +3068,16 @@ struct llog_logid_rec {
 
 struct llog_unlink_rec {
 	struct llog_rec_hdr	lur_hdr;
-	obd_id			lur_oid;
-	obd_count		lur_oseq;
-	obd_count		lur_count;
+	__u64			lur_oid;
+	__u32			lur_oseq;
+	__u32			lur_count;
 	struct llog_rec_tail	lur_tail;
 } __attribute__((packed));
 
 struct llog_unlink64_rec {
 	struct llog_rec_hdr	lur_hdr;
 	struct lu_fid		lur_fid;
-	obd_count		lur_count; /* to destroy the lost precreated */
+	__u32			lur_count; /* to destroy the lost precreated */
 	__u32			lur_padding1;
 	__u64			lur_padding2;
 	__u64			lur_padding3;
@@ -3236,7 +3222,7 @@ enum llog_flag {
 
 struct llog_log_hdr {
 	struct llog_rec_hdr     llh_hdr;
-	obd_time		llh_timestamp;
+	__s64		   llh_timestamp;
 	__u32		   llh_count;
 	__u32		   llh_bitmap_offset;
 	__u32		   llh_size;
@@ -3294,25 +3280,25 @@ struct llogd_conn_body {
 
 /* Note: 64-bit types are 64-bit aligned in structure */
 struct obdo {
-	obd_valid	       o_valid;	/* hot fields in this obdo */
-	struct ost_id	   o_oi;
-	obd_id		  o_parent_seq;
-	obd_size		o_size;	 /* o_size-o_blocks == ost_lvb */
-	obd_time		o_mtime;
-	obd_time		o_atime;
-	obd_time		o_ctime;
-	obd_blocks	      o_blocks;       /* brw: cli sent cached bytes */
-	obd_size		o_grant;
+	__u64		o_valid;	/* hot fields in this obdo */
+	struct ost_id	o_oi;
+	__u64		o_parent_seq;
+	__u64		o_size;	 /* o_size-o_blocks == ost_lvb */
+	__s64		o_mtime;
+	__s64		o_atime;
+	__s64		o_ctime;
+	__u64		o_blocks;       /* brw: cli sent cached bytes */
+	__u64		o_grant;
 
 	/* 32-bit fields start here: keep an even number of them via padding */
-	obd_blksize	     o_blksize;      /* optimal IO blocksize */
-	obd_mode		o_mode;	 /* brw: cli sent cache remain */
-	obd_uid		 o_uid;
-	obd_gid		 o_gid;
-	obd_flag		o_flags;
-	obd_count	       o_nlink;	/* brw: checksum */
-	obd_count	       o_parent_oid;
-	obd_count		o_misc;		/* brw: o_dropped */
+	__u32		o_blksize;      /* optimal IO blocksize */
+	__u32		o_mode;	 /* brw: cli sent cache remain */
+	__u32		o_uid;
+	__u32		o_gid;
+	__u32		o_flags;
+	__u32		o_nlink;	/* brw: checksum */
+	__u32		o_parent_oid;
+	__u32		o_misc;		/* brw: o_dropped */
 
 	__u64		   o_ioepoch;      /* epoch in ost writes */
 	__u32		   o_stripe_idx;   /* holds stripe idx */
@@ -3361,7 +3347,7 @@ static inline void lustre_get_wire_obdo(struct obd_connect_data *ocd,
 					struct obdo *lobdo,
 					const struct obdo *wobdo)
 {
-	obd_flag local_flags = 0;
+	__u32 local_flags = 0;
 
 	if (lobdo->o_valid & OBD_MD_FLFLAGS)
 		 local_flags = lobdo->o_flags & OBD_FL_LOCAL_MASK;
@@ -3399,7 +3385,7 @@ struct ll_fiemap_info_key {
 };
 
 extern void lustre_swab_ost_body (struct ost_body *b);
-extern void lustre_swab_ost_last_id(obd_id *id);
+extern void lustre_swab_ost_last_id(__u64 *id);
 extern void lustre_swab_fiemap(struct ll_user_fiemap *fiemap);
 
 extern void lustre_swab_lov_user_md_v1(struct lov_user_md_v1 *lum);
diff --git a/drivers/staging/lustre/lustre/include/lustre_lib.h b/drivers/staging/lustre/lustre/include/lustre_lib.h
index de493fa..6ab8958 100644
--- a/drivers/staging/lustre/lustre/include/lustre_lib.h
+++ b/drivers/staging/lustre/lustre/include/lustre_lib.h
@@ -65,8 +65,8 @@ struct l_wait_info;
 int target_pack_pool_reply(struct ptlrpc_request *req);
 int do_set_info_async(struct obd_import *imp,
 		      int opcode, int version,
-		      obd_count keylen, void *key,
-		      obd_count vallen, void *val,
+		      u32 keylen, void *key,
+		      u32 vallen, void *val,
 		      struct ptlrpc_request_set *set);
 
 #define OBD_RECOVERY_MAX_TIME (obd_timeout * 18) /* b13079 */
@@ -133,8 +133,8 @@ struct obd_ioctl_data {
 	struct obdo ioc_obdo1;
 	struct obdo ioc_obdo2;
 
-	obd_size ioc_count;
-	obd_off  ioc_offset;
+	u64	 ioc_count;
+	u64	 ioc_offset;
 	__u32    ioc_dev;
 	__u32    ioc_command;
 
diff --git a/drivers/staging/lustre/lustre/include/lustre_lite.h b/drivers/staging/lustre/lustre/include/lustre_lite.h
index eee9006..c10c0d3 100644
--- a/drivers/staging/lustre/lustre/include/lustre_lite.h
+++ b/drivers/staging/lustre/lustre/include/lustre_lite.h
@@ -60,7 +60,7 @@
 struct lustre_rw_params {
 	int		lrp_lock_mode;
 	ldlm_policy_data_t lrp_policy;
-	obd_flag	   lrp_brw_flags;
+	u32		lrp_brw_flags;
 	int		lrp_ast_flags;
 };
 
diff --git a/drivers/staging/lustre/lustre/include/obd.h b/drivers/staging/lustre/lustre/include/obd.h
index b472136..808cb0e 100644
--- a/drivers/staging/lustre/lustre/include/obd.h
+++ b/drivers/staging/lustre/lustre/include/obd.h
@@ -252,10 +252,10 @@ struct obd_type {
 };
 
 struct brw_page {
-	obd_off  off;
+	u64 off;
 	struct page *pg;
 	int count;
-	obd_flag flag;
+	u32 flag;
 };
 
 /* llog contexts */
@@ -442,7 +442,7 @@ struct client_obd {
 
 struct obd_id_info {
 	__u32   idx;
-	obd_id  *data;
+	u64	*data;
 };
 
 struct echo_client_obd {
@@ -1059,7 +1059,7 @@ struct md_op_data {
 	struct lu_fid	   op_fid4; /* to the operation locks. */
 	u32			op_mds;  /* what mds server open will go to */
 	struct lustre_handle    op_handle;
-	obd_time		op_mod_time;
+	s64			op_mod_time;
 	const char	     *op_name;
 	int		     op_namelen;
 	__u32		   op_mode;
@@ -1138,14 +1138,13 @@ struct obd_ops {
 				__u32 keylen, void *key,
 				__u32 vallen, void *val,
 				struct ptlrpc_request_set *set);
-	int (*o_attach)(struct obd_device *dev, obd_count len, void *data);
+	int (*o_attach)(struct obd_device *dev, u32 len, void *data);
 	int (*o_detach)(struct obd_device *dev);
 	int (*o_setup) (struct obd_device *dev, struct lustre_cfg *cfg);
 	int (*o_precleanup)(struct obd_device *dev,
 			    enum obd_cleanup_stage cleanup_stage);
 	int (*o_cleanup)(struct obd_device *dev);
-	int (*o_process_config)(struct obd_device *dev, obd_count len,
-				void *data);
+	int (*o_process_config)(struct obd_device *dev, u32 len, void *data);
 	int (*o_postrecov)(struct obd_device *dev);
 	int (*o_add_conn)(struct obd_import *imp, struct obd_uuid *uuid,
 			  int priority);
@@ -1186,8 +1185,7 @@ struct obd_ops {
 			struct lov_stripe_md *mem_src);
 	int (*o_unpackmd)(struct obd_export *exp,struct lov_stripe_md **mem_tgt,
 			  struct lov_mds_md *disk_src, int disk_len);
-	int (*o_preallocate)(struct lustre_handle *, obd_count *req,
-			     obd_id *ids);
+	int (*o_preallocate)(struct lustre_handle *, u32 *req, u64 *ids);
 	/* FIXME: add fid capability support for create & destroy! */
 	int (*o_precreate)(struct obd_export *exp);
 	int (*o_create)(const struct lu_env *env, struct obd_export *exp,
@@ -1210,27 +1208,27 @@ struct obd_ops {
 	int (*o_getattr_async)(struct obd_export *exp, struct obd_info *oinfo,
 			       struct ptlrpc_request_set *set);
 	int (*o_brw)(int rw, struct obd_export *exp, struct obd_info *oinfo,
-		     obd_count oa_bufs, struct brw_page *pgarr,
+		     u32 oa_bufs, struct brw_page *pgarr,
 		     struct obd_trans_info *oti);
 	int (*o_merge_lvb)(struct obd_export *exp, struct lov_stripe_md *lsm,
 			   struct ost_lvb *lvb, int kms_only);
 	int (*o_adjust_kms)(struct obd_export *exp, struct lov_stripe_md *lsm,
-			    obd_off size, int shrink);
+			    u64 size, int shrink);
 	int (*o_punch)(const struct lu_env *, struct obd_export *exp,
 		       struct obd_info *oinfo, struct obd_trans_info *oti,
 		       struct ptlrpc_request_set *rqset);
 	int (*o_sync)(const struct lu_env *env, struct obd_export *exp,
-		      struct obd_info *oinfo, obd_size start, obd_size end,
+		      struct obd_info *oinfo, u64 start, u64 end,
 		      struct ptlrpc_request_set *set);
 	int (*o_migrate)(struct lustre_handle *conn, struct lov_stripe_md *dst,
-			 struct lov_stripe_md *src, obd_size start,
-			 obd_size end, struct obd_trans_info *oti);
+			 struct lov_stripe_md *src, u64 start,
+			 u64 end, struct obd_trans_info *oti);
 	int (*o_copy)(struct lustre_handle *dstconn, struct lov_stripe_md *dst,
 		      struct lustre_handle *srconn, struct lov_stripe_md *src,
-		      obd_size start, obd_size end, struct obd_trans_info *);
+		      u64 start, u64 end, struct obd_trans_info *);
 	int (*o_iterate)(struct lustre_handle *conn,
-			 int (*)(obd_id, obd_seq, void *),
-			 obd_id *startid, obd_seq seq, void *data);
+			 int (*)(u64, u64, void *),
+			 u64 *startid, u64 seq, void *data);
 	int (*o_preprw)(const struct lu_env *env, int cmd,
 			struct obd_export *exp, struct obdo *oa, int objcount,
 			struct obd_ioobj *obj, struct niobuf_remote *remote,
@@ -1256,7 +1254,7 @@ struct obd_ops {
 	int (*o_init_export)(struct obd_export *exp);
 	int (*o_destroy_export)(struct obd_export *exp);
 	int (*o_extent_calc)(struct obd_export *, struct lov_stripe_md *,
-			     int cmd, obd_off *);
+			     int cmd, u64 *);
 
 	/* llog related obd_methods */
 	int (*o_llog_init)(struct obd_device *obd, struct obd_llog_group *grp,
@@ -1385,12 +1383,12 @@ struct md_ops {
 			struct ptlrpc_request **);
 
 	int (*m_setxattr)(struct obd_export *, const struct lu_fid *,
-			  struct obd_capa *, obd_valid, const char *,
+			  struct obd_capa *, u64, const char *,
 			  const char *, int, int, int, __u32,
 			  struct ptlrpc_request **);
 
 	int (*m_getxattr)(struct obd_export *, const struct lu_fid *,
-			  struct obd_capa *, obd_valid, const char *,
+			  struct obd_capa *, u64, const char *,
 			  const char *, int, int, int,
 			  struct ptlrpc_request **);
 
@@ -1444,10 +1442,10 @@ struct lsm_operations {
 	void (*lsm_free)(struct lov_stripe_md *);
 	int (*lsm_destroy)(struct lov_stripe_md *, struct obdo *oa,
 			   struct obd_export *md_exp);
-	void (*lsm_stripe_by_index)(struct lov_stripe_md *, int *, obd_off *,
-				    obd_off *);
-	void (*lsm_stripe_by_offset)(struct lov_stripe_md *, int *, obd_off *,
-				     obd_off *);
+	void (*lsm_stripe_by_index)(struct lov_stripe_md *, int *, u64 *,
+				    u64 *);
+	void (*lsm_stripe_by_offset)(struct lov_stripe_md *, int *, u64 *,
+				     u64 *);
 	int (*lsm_lmm_verify) (struct lov_mds_md *lmm, int lmm_bytes,
 			       __u16 *stripe_count);
 	int (*lsm_unpackmd) (struct lov_obd *lov, struct lov_stripe_md *lsm,
@@ -1498,7 +1496,7 @@ static inline struct md_open_data *obd_mod_alloc(void)
 	}						       \
 })
 
-void obdo_from_inode(struct obdo *dst, struct inode *src, obd_flag valid);
+void obdo_from_inode(struct obdo *dst, struct inode *src, u32 valid);
 void obdo_set_parent_fid(struct obdo *dst, const struct lu_fid *parent);
 
 /* return 1 if client should be resend request */
diff --git a/drivers/staging/lustre/lustre/include/obd_cksum.h b/drivers/staging/lustre/lustre/include/obd_cksum.h
index 662a780..3a63462 100644
--- a/drivers/staging/lustre/lustre/include/obd_cksum.h
+++ b/drivers/staging/lustre/lustre/include/obd_cksum.h
@@ -64,10 +64,10 @@ static inline unsigned char cksum_obd2cfs(cksum_type_t cksum_type)
  * because that is supported by all clients since 1.8
  *
  * In case multiple algorithms are supported the best one is used. */
-static inline obd_flag cksum_type_pack(cksum_type_t cksum_type)
+static inline u32 cksum_type_pack(cksum_type_t cksum_type)
 {
 	unsigned int    performance = 0, tmp;
-	obd_flag	flag = OBD_FL_CKSUM_ADLER;
+	u32		flag = OBD_FL_CKSUM_ADLER;
 
 	if (cksum_type & OBD_CKSUM_CRC32) {
 		tmp = cfs_crypto_hash_speed(cksum_obd2cfs(OBD_CKSUM_CRC32));
@@ -98,7 +98,7 @@ static inline obd_flag cksum_type_pack(cksum_type_t cksum_type)
 	return flag;
 }
 
-static inline cksum_type_t cksum_type_unpack(obd_flag o_flags)
+static inline cksum_type_t cksum_type_unpack(u32 o_flags)
 {
 	switch (o_flags & OBD_FL_CKSUM_ALL) {
 	case OBD_FL_CKSUM_CRC32C:
diff --git a/drivers/staging/lustre/lustre/include/obd_class.h b/drivers/staging/lustre/lustre/include/obd_class.h
index 1d401c9e..3597226 100644
--- a/drivers/staging/lustre/lustre/include/obd_class.h
+++ b/drivers/staging/lustre/lustre/include/obd_class.h
@@ -308,12 +308,12 @@ static inline enum obd_option exp_flags_from_obd(struct obd_device *obd)
 }
 
 
-void obdo_cpy_md(struct obdo *dst, struct obdo *src, obd_flag valid);
+void obdo_cpy_md(struct obdo *dst, struct obdo *src, u32 valid);
 void obdo_to_ioobj(struct obdo *oa, struct obd_ioobj *ioobj);
 void obdo_from_iattr(struct obdo *oa, struct iattr *attr,
 		     unsigned int ia_valid);
-void iattr_from_obdo(struct iattr *attr, struct obdo *oa, obd_flag valid);
-void md_from_obdo(struct md_op_data *op_data, struct obdo *oa, obd_flag valid);
+void iattr_from_obdo(struct iattr *attr, struct obdo *oa, u32 valid);
+void md_from_obdo(struct md_op_data *op_data, struct obdo *oa, u32 valid);
 void obdo_from_md(struct obdo *oa, struct md_op_data *op_data,
 		  unsigned int valid);
 
@@ -510,8 +510,8 @@ static inline int obd_get_info(const struct lu_env *env,
 }
 
 static inline int obd_set_info_async(const struct lu_env *env,
-				     struct obd_export *exp, obd_count keylen,
-				     void *key, obd_count vallen, void *val,
+				     struct obd_export *exp, u32 keylen,
+				     void *key, u32 vallen, void *val,
 				     struct ptlrpc_request_set *set)
 {
 	int rc;
@@ -1123,7 +1123,7 @@ static inline int obd_destroy_export(struct obd_export *exp)
 
 static inline int obd_extent_calc(struct obd_export *exp,
 				  struct lov_stripe_md *md,
-				  int cmd, obd_off *offset)
+				  int cmd, u64 *offset)
 {
 	int rc;
 
@@ -1239,7 +1239,7 @@ static inline int obd_statfs(const struct lu_env *env, struct obd_export *exp,
 }
 
 static inline int obd_sync_rqset(struct obd_export *exp, struct obd_info *oinfo,
-				 obd_size start, obd_size end)
+				 u64 start, u64 end)
 {
 	struct ptlrpc_request_set *set = NULL;
 	int rc;
@@ -1259,7 +1259,7 @@ static inline int obd_sync_rqset(struct obd_export *exp, struct obd_info *oinfo,
 }
 
 static inline int obd_sync(const struct lu_env *env, struct obd_export *exp,
-			   struct obd_info *oinfo, obd_size start, obd_size end,
+			   struct obd_info *oinfo, u64 start, u64 end,
 			   struct ptlrpc_request_set *set)
 {
 	int rc;
@@ -1306,7 +1306,7 @@ static inline int obd_punch(const struct lu_env *env, struct obd_export *exp,
 }
 
 static inline int obd_brw(int cmd, struct obd_export *exp,
-			  struct obd_info *oinfo, obd_count oa_bufs,
+			  struct obd_info *oinfo, u32 oa_bufs,
 			  struct brw_page *pg, struct obd_trans_info *oti)
 {
 	int rc;
@@ -1371,7 +1371,7 @@ static inline int obd_merge_lvb(struct obd_export *exp,
 }
 
 static inline int obd_adjust_kms(struct obd_export *exp,
-				 struct lov_stripe_md *lsm, obd_off size,
+				 struct lov_stripe_md *lsm, u64 size,
 				 int shrink)
 {
 	int rc;
@@ -1962,7 +1962,7 @@ static inline int md_free_lustre_md(struct obd_export *exp,
 
 static inline int md_setxattr(struct obd_export *exp,
 			      const struct lu_fid *fid, struct obd_capa *oc,
-			      obd_valid valid, const char *name,
+			      u64 valid, const char *name,
 			      const char *input, int input_size,
 			      int output_size, int flags, __u32 suppgid,
 			      struct ptlrpc_request **request)
@@ -1976,7 +1976,7 @@ static inline int md_setxattr(struct obd_export *exp,
 
 static inline int md_getxattr(struct obd_export *exp,
 			      const struct lu_fid *fid, struct obd_capa *oc,
-			      obd_valid valid, const char *name,
+			      u64 valid, const char *name,
 			      const char *input, int input_size,
 			      int output_size, int flags,
 			      struct ptlrpc_request **request)
diff --git a/drivers/staging/lustre/lustre/include/obd_ost.h b/drivers/staging/lustre/lustre/include/obd_ost.h
index 60de429..a679bb1 100644
--- a/drivers/staging/lustre/lustre/include/obd_ost.h
+++ b/drivers/staging/lustre/lustre/include/obd_ost.h
@@ -49,7 +49,7 @@ struct osc_brw_async_args {
 	struct obdo       *aa_oa;
 	int		aa_requested_nob;
 	int		aa_nio_count;
-	obd_count	  aa_page_count;
+	u32		aa_page_count;
 	int		aa_resends;
 	struct brw_page  **aa_ppga;
 	struct client_obd *aa_cli;
diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
index 94f759d..24d26ab 100644
--- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
+++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
@@ -895,11 +895,11 @@ void ccc_req_completion(const struct lu_env *env,
 void ccc_req_attr_set(const struct lu_env *env,
 		      const struct cl_req_slice *slice,
 		      const struct cl_object *obj,
-		      struct cl_req_attr *attr, obd_valid flags)
+		      struct cl_req_attr *attr, u64 flags)
 {
 	struct inode *inode;
 	struct obdo  *oa;
-	obd_flag      valid_flags;
+	u32	      valid_flags;
 
 	oa = attr->cra_oa;
 	inode = ccc_object_inode(obj);
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 4a33638..6ffbe7cb 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -1248,8 +1248,7 @@ static ssize_t ll_file_splice_read(struct file *in_file, loff_t *ppos,
 	return result;
 }
 
-static int ll_lov_recreate(struct inode *inode, struct ost_id *oi,
-			   obd_count ost_idx)
+static int ll_lov_recreate(struct inode *inode, struct ost_id *oi, u32 ost_idx)
 {
 	struct obd_export *exp = ll_i2dtexp(inode);
 	struct obd_trans_info oti = { 0 };
@@ -1314,7 +1313,7 @@ static int ll_lov_recreate_fid(struct inode *inode, unsigned long arg)
 {
 	struct lu_fid	fid;
 	struct ost_id	oi;
-	obd_count	ost_idx;
+	u32		ost_idx;
 
 	if (!capable(CFS_CAP_SYS_ADMIN))
 		return -EPERM;
@@ -2893,7 +2892,7 @@ static int __ll_inode_revalidate(struct dentry *dentry, __u64 ibits)
 		ll_lookup_finish_locks(&oit, dentry);
 	} else if (!ll_have_md_lock(dentry->d_inode, &ibits, LCK_MINMODE)) {
 		struct ll_sb_info *sbi = ll_i2sbi(dentry->d_inode);
-		obd_valid valid = OBD_MD_FLGETATTR;
+		u64 valid = OBD_MD_FLGETATTR;
 		struct md_op_data *op_data;
 		int ealen = 0;
 
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index b42d879..acfb078 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -1128,7 +1128,7 @@ struct eacl_entry {
 	ext_acl_xattr_header *ee_acl;
 };
 
-obd_valid rce_ops2valid(int ops);
+u64 rce_ops2valid(int ops);
 struct rmtacl_ctl_entry *rct_search(struct rmtacl_ctl_table *rct, pid_t key);
 int rct_add(struct rmtacl_ctl_table *rct, pid_t key, int ops);
 int rct_del(struct rmtacl_ctl_table *rct, pid_t key);
@@ -1144,7 +1144,7 @@ void et_search_free(struct eacl_table *et, pid_t key);
 void et_init(struct eacl_table *et);
 void et_fini(struct eacl_table *et);
 #else
-static inline obd_valid rce_ops2valid(int ops)
+static inline u64 rce_ops2valid(int ops)
 {
 	return 0;
 }
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 0367f5a..ff375d3 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -162,7 +162,7 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 	struct obd_uuid *uuid;
 	struct md_op_data *op_data;
 	struct lustre_md lmd;
-	obd_valid valid;
+	u64 valid;
 	int size, err, checksum;
 
 	obd = class_name2obd(md);
diff --git a/drivers/staging/lustre/lustre/llite/llite_rmtacl.c b/drivers/staging/lustre/lustre/llite/llite_rmtacl.c
index be0c3ef..df66717 100644
--- a/drivers/staging/lustre/lustre/llite/llite_rmtacl.c
+++ b/drivers/staging/lustre/lustre/llite/llite_rmtacl.c
@@ -58,7 +58,7 @@ static inline __u32 ee_hashfunc(uid_t id)
 	return id & (EE_HASHES - 1);
 }
 
-obd_valid rce_ops2valid(int ops)
+u64 rce_ops2valid(int ops)
 {
 	switch (ops) {
 	case RMT_LSETFACL:
diff --git a/drivers/staging/lustre/lustre/llite/lloop.c b/drivers/staging/lustre/lustre/llite/lloop.c
index 8086638..3c29c38 100644
--- a/drivers/staging/lustre/lustre/llite/lloop.c
+++ b/drivers/staging/lustre/lustre/llite/lloop.c
@@ -192,7 +192,7 @@ static int do_bio_lustrebacked(struct lloop_device *lo, struct bio *head)
 	pgoff_t	       offset;
 	int		   ret;
 	int		   rw;
-	obd_count	     page_count = 0;
+	u32		   page_count = 0;
 	struct bio_vec       bvec;
 	struct bvec_iter   iter;
 	struct bio	   *bio;
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_obd.c b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
index 0b1e4a1..a48818a 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_obd.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
@@ -1377,7 +1377,7 @@ static int lmv_cleanup(struct obd_device *obd)
 	return 0;
 }
 
-static int lmv_process_config(struct obd_device *obd, obd_count len, void *buf)
+static int lmv_process_config(struct obd_device *obd, u32 len, void *buf)
 {
 	struct lustre_cfg	*lcfg = buf;
 	struct obd_uuid		obd_uuid;
@@ -1478,7 +1478,7 @@ static int lmv_getstatus(struct obd_export *exp,
 }
 
 static int lmv_getxattr(struct obd_export *exp, const struct lu_fid *fid,
-			struct obd_capa *oc, obd_valid valid, const char *name,
+			struct obd_capa *oc, u64 valid, const char *name,
 			const char *input, int input_size, int output_size,
 			int flags, struct ptlrpc_request **request)
 {
@@ -1502,7 +1502,7 @@ static int lmv_getxattr(struct obd_export *exp, const struct lu_fid *fid,
 }
 
 static int lmv_setxattr(struct obd_export *exp, const struct lu_fid *fid,
-			struct obd_capa *oc, obd_valid valid, const char *name,
+			struct obd_capa *oc, u64 valid, const char *name,
 			const char *input, int input_size, int output_size,
 			int flags, __u32 suppgid,
 			struct ptlrpc_request **request)
@@ -2369,7 +2369,7 @@ static int lmv_get_info(const struct lu_env *env, struct obd_export *exp,
 }
 
 int lmv_set_info_async(const struct lu_env *env, struct obd_export *exp,
-		       obd_count keylen, void *key, obd_count vallen,
+		       u32 keylen, void *key, u32 vallen,
 		       void *val, struct ptlrpc_request_set *set)
 {
 	struct lmv_tgt_desc    *tgt;
diff --git a/drivers/staging/lustre/lustre/lov/lov_cl_internal.h b/drivers/staging/lustre/lustre/lov/lov_cl_internal.h
index 99ade92..314ce85 100644
--- a/drivers/staging/lustre/lustre/lov/lov_cl_internal.h
+++ b/drivers/staging/lustre/lustre/lov/lov_cl_internal.h
@@ -515,12 +515,12 @@ struct lov_io {
 	 * starting position within a file, for the current io loop iteration
 	 * (stripe), used by ci_io_loop().
 	 */
-	obd_off	    lis_pos;
+	u64	    lis_pos;
 	/**
 	 * end position with in a file, for the current stripe io. This is
 	 * exclusive (i.e., next offset after last byte affected by io).
 	 */
-	obd_off	    lis_endpos;
+	u64	    lis_endpos;
 
 	int		lis_mem_frozen;
 	int		lis_stripe_count;
diff --git a/drivers/staging/lustre/lustre/lov/lov_ea.c b/drivers/staging/lustre/lustre/lov/lov_ea.c
index 2401ca8..9e21e5e 100644
--- a/drivers/staging/lustre/lustre/lov/lov_ea.c
+++ b/drivers/staging/lustre/lustre/lov/lov_ea.c
@@ -143,18 +143,18 @@ static void lsm_unpackmd_common(struct lov_stripe_md *lsm,
 
 static void
 lsm_stripe_by_index_plain(struct lov_stripe_md *lsm, int *stripeno,
-			   obd_off *lov_off, obd_off *swidth)
+			   u64 *lov_off, u64 *swidth)
 {
 	if (swidth)
-		*swidth = (obd_off)lsm->lsm_stripe_size * lsm->lsm_stripe_count;
+		*swidth = (u64)lsm->lsm_stripe_size * lsm->lsm_stripe_count;
 }
 
 static void
 lsm_stripe_by_offset_plain(struct lov_stripe_md *lsm, int *stripeno,
-			   obd_off *lov_off, obd_off *swidth)
+			   u64 *lov_off, u64 *swidth)
 {
 	if (swidth)
-		*swidth = (obd_off)lsm->lsm_stripe_size * lsm->lsm_stripe_count;
+		*swidth = (u64)lsm->lsm_stripe_size * lsm->lsm_stripe_count;
 }
 
 static int lsm_destroy_plain(struct lov_stripe_md *lsm, struct obdo *oa,
diff --git a/drivers/staging/lustre/lustre/lov/lov_internal.h b/drivers/staging/lustre/lustre/lov/lov_internal.h
index 017961a..1b96fac 100644
--- a/drivers/staging/lustre/lustre/lov/lov_internal.h
+++ b/drivers/staging/lustre/lustre/lov/lov_internal.h
@@ -90,8 +90,8 @@ struct lov_request {
 	int		      rq_rc;
 	int		      rq_buflen;     /* length of sub_md */
 
-	obd_count		rq_oabufs;
-	obd_count		rq_pgaidx;
+	u32		      rq_oabufs;
+	u32		      rq_pgaidx;
 };
 
 struct lov_request_set {
@@ -109,7 +109,7 @@ struct lov_request_set {
 	struct llog_cookie		*set_cookies;
 	int				set_cookie_sent;
 	struct obd_trans_info		*set_oti;
-	obd_count			set_oabufs;
+	u32				set_oabufs;
 	struct brw_page			*set_pga;
 	struct lov_lock_handles		*set_lockh;
 	struct list_head			set_list;
@@ -166,26 +166,26 @@ static inline void lov_llh_put(struct lov_lock_handles *llh)
 	(char *)((lv)->lov_tgts[index]->ltd_uuid.uuid)
 
 /* lov_merge.c */
-void lov_merge_attrs(struct obdo *tgt, struct obdo *src, obd_valid valid,
+void lov_merge_attrs(struct obdo *tgt, struct obdo *src, u64 valid,
 		     struct lov_stripe_md *lsm, int stripeno, int *set);
 int lov_merge_lvb(struct obd_export *exp, struct lov_stripe_md *lsm,
 		  struct ost_lvb *lvb, int kms_only);
 int lov_adjust_kms(struct obd_export *exp, struct lov_stripe_md *lsm,
-		   obd_off size, int shrink);
+		   u64 size, int shrink);
 int lov_merge_lvb_kms(struct lov_stripe_md *lsm,
 		      struct ost_lvb *lvb, __u64 *kms_place);
 
 /* lov_offset.c */
-obd_size lov_stripe_size(struct lov_stripe_md *lsm, obd_size ost_size,
+u64 lov_stripe_size(struct lov_stripe_md *lsm, u64 ost_size,
 			 int stripeno);
-int lov_stripe_offset(struct lov_stripe_md *lsm, obd_off lov_off,
-		      int stripeno, obd_off *obd_off);
-obd_off lov_size_to_stripe(struct lov_stripe_md *lsm, obd_off file_size,
+int lov_stripe_offset(struct lov_stripe_md *lsm, u64 lov_off,
+		      int stripeno, u64 *u64);
+u64 lov_size_to_stripe(struct lov_stripe_md *lsm, u64 file_size,
 			   int stripeno);
 int lov_stripe_intersects(struct lov_stripe_md *lsm, int stripeno,
-			  obd_off start, obd_off end,
-			  obd_off *obd_start, obd_off *obd_end);
-int lov_stripe_number(struct lov_stripe_md *lsm, obd_off lov_off);
+			  u64 start, u64 end,
+			  u64 *obd_start, u64 *obd_end);
+int lov_stripe_number(struct lov_stripe_md *lsm, u64 lov_off);
 
 /* lov_qos.c */
 #define LOV_USES_ASSIGNED_STRIPE	0
@@ -214,7 +214,7 @@ int lov_prep_create_set(struct obd_export *exp, struct obd_info *oifo,
 int cb_create_update(void *cookie, int rc);
 int lov_fini_create_set(struct lov_request_set *set, struct lov_stripe_md **ea);
 int lov_prep_brw_set(struct obd_export *exp, struct obd_info *oinfo,
-		     obd_count oa_bufs, struct brw_page *pga,
+		     u32 oa_bufs, struct brw_page *pga,
 		     struct obd_trans_info *oti,
 		     struct lov_request_set **reqset);
 int lov_fini_brw_set(struct lov_request_set *set);
@@ -239,7 +239,7 @@ int lov_prep_punch_set(struct obd_export *exp, struct obd_info *oinfo,
 		       struct lov_request_set **reqset);
 int lov_fini_punch_set(struct lov_request_set *set);
 int lov_prep_sync_set(struct obd_export *exp, struct obd_info *obd_info,
-		      obd_off start, obd_off end,
+		      u64 start, u64 end,
 		      struct lov_request_set **reqset);
 int lov_fini_sync_set(struct lov_request_set *set);
 int lov_prep_enqueue_set(struct obd_export *exp, struct obd_info *oinfo,
diff --git a/drivers/staging/lustre/lustre/lov/lov_io.c b/drivers/staging/lustre/lustre/lov/lov_io.c
index ce074c5..f1f6db3 100644
--- a/drivers/staging/lustre/lustre/lov/lov_io.c
+++ b/drivers/staging/lustre/lustre/lov/lov_io.c
@@ -366,7 +366,7 @@ static void lov_io_fini(const struct lu_env *env, const struct cl_io_slice *ios)
 		wake_up_all(&lov->lo_waitq);
 }
 
-static obd_off lov_offset_mod(obd_off val, int delta)
+static u64 lov_offset_mod(u64 val, int delta)
 {
 	if (val != OBD_OBJECT_EOF)
 		val += delta;
@@ -379,9 +379,9 @@ static int lov_io_iter_init(const struct lu_env *env,
 	struct lov_io	*lio = cl2lov_io(env, ios);
 	struct lov_stripe_md *lsm = lio->lis_object->lo_lsm;
 	struct lov_io_sub    *sub;
-	obd_off endpos;
-	obd_off start;
-	obd_off end;
+	u64 endpos;
+	u64 start;
+	u64 end;
 	int stripe;
 	int rc = 0;
 
diff --git a/drivers/staging/lustre/lustre/lov/lov_lock.c b/drivers/staging/lustre/lustre/lov/lov_lock.c
index 08ac374..49e6942 100644
--- a/drivers/staging/lustre/lustre/lov/lov_lock.c
+++ b/drivers/staging/lustre/lustre/lov/lov_lock.c
@@ -290,10 +290,10 @@ static int lov_lock_sub_init(const struct lu_env *env,
 	int result = 0;
 	int i;
 	int nr;
-	obd_off start;
-	obd_off end;
-	obd_off file_start;
-	obd_off file_end;
+	u64 start;
+	u64 end;
+	u64 file_start;
+	u64 file_end;
 
 	struct lov_object       *loo    = cl2lov(lck->lls_cl.cls_obj);
 	struct lov_layout_raid0 *r0     = lov_r0(loo);
@@ -860,10 +860,10 @@ static int lock_lock_multi_match()
 	struct lov_layout_raid0 *r0      = lov_r0(loo);
 	struct lov_lock_sub     *sub;
 	struct cl_object	*subobj;
-	obd_off  fstart;
-	obd_off  fend;
-	obd_off  start;
-	obd_off  end;
+	u64  fstart;
+	u64  fend;
+	u64  start;
+	u64  end;
 	int i;
 
 	fstart = cl_offset(need->cld_obj, need->cld_start);
@@ -900,8 +900,8 @@ static int lov_lock_stripe_is_matching(const struct lu_env *env,
 				       const struct cl_lock_descr *descr)
 {
 	struct lov_stripe_md *lsm = lov->lo_lsm;
-	obd_off start;
-	obd_off end;
+	u64 start;
+	u64 end;
 	int result;
 
 	if (lov_r0(lov)->lo_nr == 1)
@@ -919,8 +919,8 @@ static int lov_lock_stripe_is_matching(const struct lu_env *env,
 		 stripe == lov_stripe_number(lsm, end);
 	if (result) {
 		struct cl_lock_descr *subd = &lov_env_info(env)->lti_ldescr;
-		obd_off sub_start;
-		obd_off sub_end;
+		u64 sub_start;
+		u64 sub_end;
 
 		subd->cld_obj  = NULL;   /* don't need sub object at all */
 		subd->cld_mode = descr->cld_mode;
diff --git a/drivers/staging/lustre/lustre/lov/lov_merge.c b/drivers/staging/lustre/lustre/lov/lov_merge.c
index 85144b8..15ebb5d 100644
--- a/drivers/staging/lustre/lustre/lov/lov_merge.c
+++ b/drivers/staging/lustre/lustre/lov/lov_merge.c
@@ -52,9 +52,9 @@ int lov_merge_lvb_kms(struct lov_stripe_md *lsm,
 	__u64 size = 0;
 	__u64 kms = 0;
 	__u64 blocks = 0;
-	obd_time current_mtime = lvb->lvb_mtime;
-	obd_time current_atime = lvb->lvb_atime;
-	obd_time current_ctime = lvb->lvb_ctime;
+	s64 current_mtime = lvb->lvb_mtime;
+	s64 current_atime = lvb->lvb_atime;
+	s64 current_ctime = lvb->lvb_ctime;
 	int i;
 	int rc = 0;
 
@@ -66,7 +66,7 @@ int lov_merge_lvb_kms(struct lov_stripe_md *lsm,
 	       lvb->lvb_atime, lvb->lvb_ctime, lvb->lvb_blocks);
 	for (i = 0; i < lsm->lsm_stripe_count; i++) {
 		struct lov_oinfo *loi = lsm->lsm_oinfo[i];
-		obd_size lov_size, tmpsize;
+		u64 lov_size, tmpsize;
 
 		if (OST_LVB_IS_ERR(loi->loi_lvb.lvb_blocks)) {
 			rc = OST_LVB_GET_ERR(loi->loi_lvb.lvb_blocks);
@@ -138,7 +138,7 @@ int lov_merge_lvb(struct obd_export *exp,
 
 /* Must be called under the lov_stripe_lock() */
 int lov_adjust_kms(struct obd_export *exp, struct lov_stripe_md *lsm,
-		   obd_off size, int shrink)
+		   u64 size, int shrink)
 {
 	struct lov_oinfo *loi;
 	int stripe = 0;
@@ -173,7 +173,7 @@ int lov_adjust_kms(struct obd_export *exp, struct lov_stripe_md *lsm,
 	return 0;
 }
 
-void lov_merge_attrs(struct obdo *tgt, struct obdo *src, obd_valid valid,
+void lov_merge_attrs(struct obdo *tgt, struct obdo *src, u64 valid,
 		     struct lov_stripe_md *lsm, int stripeno, int *set)
 {
 	valid &= src->o_valid;
@@ -181,7 +181,7 @@ void lov_merge_attrs(struct obdo *tgt, struct obdo *src, obd_valid valid,
 	if (*set) {
 		if (valid & OBD_MD_FLSIZE) {
 			/* this handles sparse files properly */
-			obd_size lov_size;
+			u64 lov_size;
 
 			lov_size = lov_stripe_size(lsm, src->o_size, stripeno);
 			if (lov_size > tgt->o_size)
diff --git a/drivers/staging/lustre/lustre/lov/lov_obd.c b/drivers/staging/lustre/lustre/lov/lov_obd.c
index e4f4fe3..cb778df 100644
--- a/drivers/staging/lustre/lustre/lov/lov_obd.c
+++ b/drivers/staging/lustre/lustre/lov/lov_obd.c
@@ -1442,7 +1442,7 @@ static int lov_sync_interpret(struct ptlrpc_request_set *rqset,
 }
 
 static int lov_sync(const struct lu_env *env, struct obd_export *exp,
-		    struct obd_info *oinfo, obd_off start, obd_off end,
+		    struct obd_info *oinfo, u64 start, u64 end,
 		    struct ptlrpc_request_set *rqset)
 {
 	struct lov_request_set *set = NULL;
@@ -1497,7 +1497,7 @@ static int lov_sync(const struct lu_env *env, struct obd_export *exp,
 }
 
 static int lov_brw_check(struct lov_obd *lov, struct obd_info *lov_oinfo,
-			 obd_count oa_bufs, struct brw_page *pga)
+			 u32 oa_bufs, struct brw_page *pga)
 {
 	struct obd_info oinfo = { { { 0 } } };
 	int i, rc = 0;
@@ -1509,7 +1509,7 @@ static int lov_brw_check(struct lov_obd *lov, struct obd_info *lov_oinfo,
 	for (i = 0; i < oa_bufs; i++) {
 		int stripe = lov_stripe_number(lov_oinfo->oi_md, pga[i].off);
 		int ost = lov_oinfo->oi_md->lsm_oinfo[stripe]->loi_ost_idx;
-		obd_off start, end;
+		u64 start, end;
 
 		if (!lov_stripe_intersects(lov_oinfo->oi_md, i, pga[i].off,
 					   pga[i].off + pga[i].count - 1,
@@ -1530,7 +1530,7 @@ static int lov_brw_check(struct lov_obd *lov, struct obd_info *lov_oinfo,
 }
 
 static int lov_brw(int cmd, struct obd_export *exp, struct obd_info *oinfo,
-		   obd_count oa_bufs, struct brw_page *pga,
+		   u32 oa_bufs, struct brw_page *pga,
 		   struct obd_trans_info *oti)
 {
 	struct lov_request_set *set;
@@ -2080,13 +2080,13 @@ static int lov_iocontrol(unsigned int cmd, struct obd_export *exp, int len,
  * \param fm_end logical end of mapping
  * \param start_stripe starting stripe will be returned in this
  */
-obd_size fiemap_calc_fm_end_offset(struct ll_user_fiemap *fiemap,
-				   struct lov_stripe_md *lsm, obd_size fm_start,
-				   obd_size fm_end, int *start_stripe)
+u64 fiemap_calc_fm_end_offset(struct ll_user_fiemap *fiemap,
+				   struct lov_stripe_md *lsm, u64 fm_start,
+				   u64 fm_end, int *start_stripe)
 {
-	obd_size local_end = fiemap->fm_extents[0].fe_logical;
-	obd_off lun_start, lun_end;
-	obd_size fm_end_offset;
+	u64 local_end = fiemap->fm_extents[0].fe_logical;
+	u64 lun_start, lun_end;
+	u64 fm_end_offset;
 	int stripe_no = -1, i;
 
 	if (fiemap->fm_extent_count == 0 ||
@@ -2137,12 +2137,12 @@ obd_size fiemap_calc_fm_end_offset(struct ll_user_fiemap *fiemap,
  *
  * \retval last_stripe return the last stripe of the mapping
  */
-int fiemap_calc_last_stripe(struct lov_stripe_md *lsm, obd_size fm_start,
-			    obd_size fm_end, int start_stripe,
+int fiemap_calc_last_stripe(struct lov_stripe_md *lsm, u64 fm_start,
+			    u64 fm_end, int start_stripe,
 			    int *stripe_count)
 {
 	int last_stripe;
-	obd_off obd_start, obd_end;
+	u64 obd_start, obd_end;
 	int i, j;
 
 	if (fm_end - fm_start > lsm->lsm_stripe_size * lsm->lsm_stripe_count) {
@@ -2206,8 +2206,8 @@ static int lov_fiemap(struct lov_obd *lov, __u32 keylen, void *key,
 	int count_local;
 	unsigned int get_num_extents = 0;
 	int ost_index = 0, actual_start_stripe, start_stripe;
-	obd_size fm_start, fm_end, fm_length, fm_end_offset;
-	obd_size curr_loc;
+	u64 fm_start, fm_end, fm_length, fm_end_offset;
+	u64 curr_loc;
 	int current_extent = 0, rc = 0, i;
 	int ost_eof = 0; /* EOF for object */
 	int ost_done = 0; /* done with required mapping for this OST? */
@@ -2256,9 +2256,9 @@ static int lov_fiemap(struct lov_obd *lov, __u32 keylen, void *key,
 	/* Check each stripe */
 	for (cur_stripe = start_stripe, i = 0; i < stripe_count;
 	     i++, cur_stripe = (cur_stripe + 1) % lsm->lsm_stripe_count) {
-		obd_size req_fm_len; /* Stores length of required mapping */
-		obd_size len_mapped_single_call;
-		obd_off lun_start, lun_end, obd_object_end;
+		u64 req_fm_len; /* Stores length of required mapping */
+		u64 len_mapped_single_call;
+		u64 lun_start, lun_end, obd_object_end;
 		unsigned int ext_count;
 
 		cur_stripe_wrap = cur_stripe;
@@ -2467,7 +2467,7 @@ static int lov_get_info(const struct lu_env *env, struct obd_export *exp,
 		GOTO(out, rc = -ENXIO);
 	} else if (KEY_IS(KEY_LAST_ID)) {
 		struct obd_id_info *info = val;
-		__u32 size = sizeof(obd_id);
+		__u32 size = sizeof(u64);
 		struct lov_tgt_desc *tgt;
 
 		LASSERT(*vallen == sizeof(struct obd_id_info));
@@ -2513,12 +2513,12 @@ out:
 }
 
 static int lov_set_info_async(const struct lu_env *env, struct obd_export *exp,
-			      obd_count keylen, void *key, obd_count vallen,
+			      u32 keylen, void *key, u32 vallen,
 			      void *val, struct ptlrpc_request_set *set)
 {
 	struct obd_device *obddev = class_exp2obd(exp);
 	struct lov_obd *lov = &obddev->u.lov;
-	obd_count count;
+	u32 count;
 	int i, rc = 0, err;
 	struct lov_tgt_desc *tgt;
 	unsigned incr, check_uuid,
@@ -2538,7 +2538,7 @@ static int lov_set_info_async(const struct lu_env *env, struct obd_export *exp,
 
 	if (KEY_IS(KEY_NEXT_ID)) {
 		count = vallen / sizeof(struct obd_id_info);
-		vallen = sizeof(obd_id);
+		vallen = sizeof(u64);
 		incr = sizeof(struct obd_id_info);
 		do_inactive = 1;
 		next_id = 1;
diff --git a/drivers/staging/lustre/lustre/lov/lov_offset.c b/drivers/staging/lustre/lustre/lov/lov_offset.c
index 8e1c3ba..9c8c77c 100644
--- a/drivers/staging/lustre/lustre/lov/lov_offset.c
+++ b/drivers/staging/lustre/lustre/lov/lov_offset.c
@@ -43,13 +43,13 @@
 #include "lov_internal.h"
 
 /* compute object size given "stripeno" and the ost size */
-obd_size lov_stripe_size(struct lov_stripe_md *lsm, obd_size ost_size,
+u64 lov_stripe_size(struct lov_stripe_md *lsm, u64 ost_size,
 			 int stripeno)
 {
 	unsigned long ssize = lsm->lsm_stripe_size;
 	unsigned long stripe_size;
-	obd_off swidth;
-	obd_size lov_size;
+	u64 swidth;
+	u64 lov_size;
 	int magic = lsm->lsm_magic;
 
 	if (ost_size == 0)
@@ -116,11 +116,11 @@ obd_size lov_stripe_size(struct lov_stripe_md *lsm, obd_size ost_size,
  * was moved forward to the start of the stripe in question;  0 when it
  * falls in the stripe and no shifting was done; > 0 when the offset
  * was outside the stripe and was pulled back to its final byte. */
-int lov_stripe_offset(struct lov_stripe_md *lsm, obd_off lov_off,
-		      int stripeno, obd_off *obdoff)
+int lov_stripe_offset(struct lov_stripe_md *lsm, u64 lov_off,
+		      int stripeno, u64 *obdoff)
 {
 	unsigned long ssize  = lsm->lsm_stripe_size;
-	obd_off stripe_off, this_stripe, swidth;
+	u64 stripe_off, this_stripe, swidth;
 	int magic = lsm->lsm_magic;
 	int ret = 0;
 
@@ -137,7 +137,7 @@ int lov_stripe_offset(struct lov_stripe_md *lsm, obd_off lov_off,
 	/* lov_do_div64(a, b) returns a % b, and a = a / b */
 	stripe_off = lov_do_div64(lov_off, swidth);
 
-	this_stripe = (obd_off)stripeno * ssize;
+	this_stripe = (u64)stripeno * ssize;
 	if (stripe_off < this_stripe) {
 		stripe_off = 0;
 		ret = -1;
@@ -173,11 +173,11 @@ int lov_stripe_offset(struct lov_stripe_md *lsm, obd_off lov_off,
  * |    0    |     1     |     2     |    0    |     1     |     2     |
  * ---------------------------------------------------------------------
  */
-obd_off lov_size_to_stripe(struct lov_stripe_md *lsm, obd_off file_size,
-			   int stripeno)
+u64 lov_size_to_stripe(struct lov_stripe_md *lsm, u64 file_size,
+		       int stripeno)
 {
 	unsigned long ssize  = lsm->lsm_stripe_size;
-	obd_off stripe_off, this_stripe, swidth;
+	u64 stripe_off, this_stripe, swidth;
 	int magic = lsm->lsm_magic;
 
 	if (file_size == OBD_OBJECT_EOF)
@@ -190,7 +190,7 @@ obd_off lov_size_to_stripe(struct lov_stripe_md *lsm, obd_off file_size,
 	/* lov_do_div64(a, b) returns a % b, and a = a / b */
 	stripe_off = lov_do_div64(file_size, swidth);
 
-	this_stripe = (obd_off)stripeno * ssize;
+	this_stripe = (u64)stripeno * ssize;
 	if (stripe_off < this_stripe) {
 		/* Move to end of previous stripe, or zero */
 		if (file_size > 0) {
@@ -215,8 +215,7 @@ obd_off lov_size_to_stripe(struct lov_stripe_md *lsm, obd_off file_size,
  * that is contained within the lov extent.  this returns true if the given
  * stripe does intersect with the lov extent. */
 int lov_stripe_intersects(struct lov_stripe_md *lsm, int stripeno,
-			  obd_off start, obd_off end,
-			  obd_off *obd_start, obd_off *obd_end)
+			  u64 start, u64 end, u64 *obd_start, u64 *obd_end)
 {
 	int start_side, end_side;
 
@@ -247,10 +246,10 @@ int lov_stripe_intersects(struct lov_stripe_md *lsm, int stripeno,
 }
 
 /* compute which stripe number "lov_off" will be written into */
-int lov_stripe_number(struct lov_stripe_md *lsm, obd_off lov_off)
+int lov_stripe_number(struct lov_stripe_md *lsm, u64 lov_off)
 {
 	unsigned long ssize  = lsm->lsm_stripe_size;
-	obd_off stripe_off, swidth;
+	u64 stripe_off, swidth;
 	int magic = lsm->lsm_magic;
 
 	LASSERT(lsm_op_find(magic) != NULL);
diff --git a/drivers/staging/lustre/lustre/lov/lov_pack.c b/drivers/staging/lustre/lustre/lov/lov_pack.c
index a5b190f..20e5870 100644
--- a/drivers/staging/lustre/lustre/lov/lov_pack.c
+++ b/drivers/staging/lustre/lustre/lov/lov_pack.c
@@ -125,7 +125,7 @@ void lov_dump_lmm(int level, void *lmm)
  *
  * XXX In the future, this will be enhanced to get the EA size from the
  *     underlying OSC device(s) to get their EA sizes so we can stack
- *     LOVs properly.  For now lov_mds_md_size() just assumes one obd_id
+ *     LOVs properly.  For now lov_mds_md_size() just assumes one u64
  *     per stripe.
  */
 int lov_packmd(struct obd_export *exp, struct lov_mds_md **lmmp,
@@ -538,7 +538,7 @@ int lov_setea(struct obd_export *exp, struct lov_stripe_md **lsmp,
 	int rc;
 	struct obd_export *oexp;
 	struct lov_obd *lov = &exp->exp_obd->u.lov;
-	obd_id last_id = 0;
+	u64 last_id = 0;
 	struct lov_user_ost_data_v1 *lmm_objects;
 
 	if (lump->lmm_magic == LOV_USER_MAGIC_V3)
diff --git a/drivers/staging/lustre/lustre/lov/lov_page.c b/drivers/staging/lustre/lustre/lov/lov_page.c
index 674e617..24f4e20 100644
--- a/drivers/staging/lustre/lustre/lov/lov_page.c
+++ b/drivers/staging/lustre/lustre/lov/lov_page.c
@@ -165,7 +165,7 @@ int lov_page_init_raid0(const struct lu_env *env, struct cl_object *obj,
 	struct lov_io_sub *sub;
 	struct lov_page   *lpg = cl_object_page_slice(obj, page);
 	loff_t	     offset;
-	obd_off	    suboff;
+	u64	    suboff;
 	int		stripe;
 	int		rc;
 
diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c b/drivers/staging/lustre/lustre/lov/lov_request.c
index e4bb02a..174a5fe 100644
--- a/drivers/staging/lustre/lustre/lov/lov_request.c
+++ b/drivers/staging/lustre/lustre/lov/lov_request.c
@@ -375,7 +375,7 @@ int lov_prep_enqueue_set(struct obd_export *exp, struct obd_info *oinfo,
 	for (i = 0; i < oinfo->oi_md->lsm_stripe_count; i++) {
 		struct lov_oinfo *loi;
 		struct lov_request *req;
-		obd_off start, end;
+		u64 start, end;
 
 		loi = oinfo->oi_md->lsm_oinfo[i];
 		if (!lov_stripe_intersects(oinfo->oi_md, i,
@@ -481,7 +481,7 @@ int lov_prep_match_set(struct obd_export *exp, struct obd_info *oinfo,
 	for (i = 0; i < lsm->lsm_stripe_count; i++) {
 		struct lov_oinfo *loi;
 		struct lov_request *req;
-		obd_off start, end;
+		u64 start, end;
 
 		loi = lsm->lsm_oinfo[i];
 		if (!lov_stripe_intersects(lsm, i, policy->l_extent.start,
@@ -696,14 +696,14 @@ int lov_fini_brw_set(struct lov_request_set *set)
 }
 
 int lov_prep_brw_set(struct obd_export *exp, struct obd_info *oinfo,
-		     obd_count oa_bufs, struct brw_page *pga,
+		     u32 oa_bufs, struct brw_page *pga,
 		     struct obd_trans_info *oti,
 		     struct lov_request_set **reqset)
 {
 	struct {
-		obd_count       index;
-		obd_count       count;
-		obd_count       off;
+		u32       index;
+		u32       count;
+		u32       off;
 	} *info = NULL;
 	struct lov_request_set *set;
 	struct lov_obd *lov = &exp->exp_obd->u.lov;
@@ -1167,7 +1167,7 @@ int lov_prep_punch_set(struct obd_export *exp, struct obd_info *oinfo,
 	for (i = 0; i < oinfo->oi_md->lsm_stripe_count; i++) {
 		struct lov_oinfo *loi = oinfo->oi_md->lsm_oinfo[i];
 		struct lov_request *req;
-		obd_off rs, re;
+		u64 rs, re;
 
 		if (!lov_stripe_intersects(oinfo->oi_md, i,
 					   oinfo->oi_policy.l_extent.start,
@@ -1246,7 +1246,7 @@ static int cb_sync_update(void *cookie, int rc)
 }
 
 int lov_prep_sync_set(struct obd_export *exp, struct obd_info *oinfo,
-		      obd_off start, obd_off end,
+		      u64 start, u64 end,
 		      struct lov_request_set **reqset)
 {
 	struct lov_request_set *set;
@@ -1264,7 +1264,7 @@ int lov_prep_sync_set(struct obd_export *exp, struct obd_info *oinfo,
 	for (i = 0; i < oinfo->oi_md->lsm_stripe_count; i++) {
 		struct lov_oinfo *loi = oinfo->oi_md->lsm_oinfo[i];
 		struct lov_request *req;
-		obd_off rs, re;
+		u64 rs, re;
 
 		if (!lov_check_and_wait_active(lov, loi->loi_ost_idx)) {
 			CDEBUG(D_HA, "lov idx %d inactive\n", loi->loi_ost_idx);
diff --git a/drivers/staging/lustre/lustre/lov/lovsub_dev.c b/drivers/staging/lustre/lustre/lov/lovsub_dev.c
index 52fb6c1..42336f1 100644
--- a/drivers/staging/lustre/lustre/lov/lovsub_dev.c
+++ b/drivers/staging/lustre/lustre/lov/lovsub_dev.c
@@ -67,7 +67,7 @@ static void lovsub_req_completion(const struct lu_env *env,
 static void lovsub_req_attr_set(const struct lu_env *env,
 				const struct cl_req_slice *slice,
 				const struct cl_object *obj,
-				struct cl_req_attr *attr, obd_valid flags)
+				struct cl_req_attr *attr, u64 flags)
 {
 	struct lovsub_object *subobj;
 
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_internal.h b/drivers/staging/lustre/lustre/mdc/mdc_internal.h
index f4da8f3..81780c9 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_internal.h
+++ b/drivers/staging/lustre/lustre/mdc/mdc_internal.h
@@ -108,7 +108,7 @@ int mdc_resource_get_unused(struct obd_export *exp, const struct lu_fid *fid,
 int mdc_fid_alloc(struct obd_export *exp, struct lu_fid *fid,
 		  struct md_op_data *op_data);
 
-int mdc_open(struct obd_export *exp, obd_id ino, int type, int flags,
+int mdc_open(struct obd_export *exp, u64 ino, int type, int flags,
 	     struct lov_mds_md *lmm, int lmm_size, struct lustre_handle *fh,
 	     struct ptlrpc_request **);
 
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index d02bf31..9c3e533 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -455,7 +455,7 @@ static struct ptlrpc_request *mdc_intent_getattr_pack(struct obd_export *exp,
 {
 	struct ptlrpc_request *req;
 	struct obd_device     *obddev = class_exp2obd(exp);
-	obd_valid	      valid = OBD_MD_FLGETATTR | OBD_MD_FLEASIZE |
+	u64		       valid = OBD_MD_FLGETATTR | OBD_MD_FLEASIZE |
 				       OBD_MD_FLMODEASIZE | OBD_MD_FLDIREA |
 				       OBD_MD_FLMDSCAPA | OBD_MD_MEA |
 				       (client_is_remote(exp) ?
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index 57f4952..fce8567 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -331,7 +331,7 @@ static int mdc_is_subdir(struct obd_export *exp,
 static int mdc_xattr_common(struct obd_export *exp,
 			    const struct req_format *fmt,
 			    const struct lu_fid *fid,
-			    struct obd_capa *oc, int opcode, obd_valid valid,
+			    struct obd_capa *oc, int opcode, u64 valid,
 			    const char *xattr_name, const char *input,
 			    int input_size, int output_size, int flags,
 			    __u32 suppgid, struct ptlrpc_request **request)
@@ -440,7 +440,7 @@ static int mdc_xattr_common(struct obd_export *exp,
 }
 
 int mdc_setxattr(struct obd_export *exp, const struct lu_fid *fid,
-		 struct obd_capa *oc, obd_valid valid, const char *xattr_name,
+		 struct obd_capa *oc, u64 valid, const char *xattr_name,
 		 const char *input, int input_size, int output_size,
 		 int flags, __u32 suppgid, struct ptlrpc_request **request)
 {
@@ -451,7 +451,7 @@ int mdc_setxattr(struct obd_export *exp, const struct lu_fid *fid,
 }
 
 int mdc_getxattr(struct obd_export *exp, const struct lu_fid *fid,
-		 struct obd_capa *oc, obd_valid valid, const char *xattr_name,
+		 struct obd_capa *oc, u64 valid, const char *xattr_name,
 		 const char *input, int input_size, int output_size,
 		 int flags, struct ptlrpc_request **request)
 {
@@ -1926,7 +1926,7 @@ out:
 }
 
 int mdc_get_info_rpc(struct obd_export *exp,
-		     obd_count keylen, void *key,
+		     u32 keylen, void *key,
 		     int vallen, void *val)
 {
 	struct obd_import      *imp = class_exp2cliimp(exp);
@@ -2101,8 +2101,8 @@ static int mdc_kuc_reregister(struct obd_import *imp)
 
 int mdc_set_info_async(const struct lu_env *env,
 		       struct obd_export *exp,
-		       obd_count keylen, void *key,
-		       obd_count vallen, void *val,
+		       u32 keylen, void *key,
+		       u32 vallen, void *val,
 		       struct ptlrpc_request_set *set)
 {
 	struct obd_import	*imp = class_exp2cliimp(exp);
@@ -2573,7 +2573,7 @@ static int mdc_llog_finish(struct obd_device *obd, int count)
 	return 0;
 }
 
-static int mdc_process_config(struct obd_device *obd, obd_count len, void *buf)
+static int mdc_process_config(struct obd_device *obd, u32 len, void *buf)
 {
 	struct lustre_cfg *lcfg = buf;
 	struct lprocfs_static_vars lvars = { NULL };
diff --git a/drivers/staging/lustre/lustre/mgc/mgc_request.c b/drivers/staging/lustre/lustre/mgc/mgc_request.c
index f520591..aeaa2bf 100644
--- a/drivers/staging/lustre/lustre/mgc/mgc_request.c
+++ b/drivers/staging/lustre/lustre/mgc/mgc_request.c
@@ -1100,7 +1100,7 @@ static int mgc_target_register(struct obd_export *exp,
 }
 
 int mgc_set_info_async(const struct lu_env *env, struct obd_export *exp,
-		       obd_count keylen, void *key, obd_count vallen,
+		       u32 keylen, void *key, u32 vallen,
 		       void *val, struct ptlrpc_request_set *set)
 {
 	int rc = -EINVAL;
@@ -1844,7 +1844,7 @@ int mgc_process_log(struct obd_device *mgc, struct config_llog_data *cld)
  * LCFG_LOG_START gets the config log from the MGS, processes it to start
  * any services, and adds it to the list logs to watch (follow).
  */
-static int mgc_process_config(struct obd_device *obd, obd_count len, void *buf)
+static int mgc_process_config(struct obd_device *obd, u32 len, void *buf)
 {
 	struct lustre_cfg *lcfg = buf;
 	struct config_llog_instance *cfg = NULL;
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_io.c b/drivers/staging/lustre/lustre/obdclass/cl_io.c
index 4265821..c0e0604 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_io.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_io.c
@@ -1560,7 +1560,7 @@ EXPORT_SYMBOL(cl_req_prep);
  * for the same request.
  */
 void cl_req_attr_set(const struct lu_env *env, struct cl_req *req,
-		     struct cl_req_attr *attr, obd_valid flags)
+		     struct cl_req_attr *attr, u64 flags)
 {
 	const struct cl_req_slice *slice;
 	struct cl_page	    *page;
diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-obdo.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-obdo.c
index bb15202..62ed706 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-obdo.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-obdo.c
@@ -52,7 +52,7 @@
 /*FIXME: Just copy from obdo_from_inode*/
 void obdo_from_la(struct obdo *dst, struct lu_attr *la, __u64 valid)
 {
-	obd_flag newvalid = 0;
+	u32 newvalid = 0;
 
 	if (valid & LA_ATIME) {
 		dst->o_atime = la->la_atime;
@@ -97,7 +97,7 @@ void obdo_from_la(struct obdo *dst, struct lu_attr *la, __u64 valid)
 EXPORT_SYMBOL(obdo_from_la);
 
 /*FIXME: Just copy from obdo_from_inode*/
-void la_from_obdo(struct lu_attr *dst, struct obdo *obdo, obd_flag valid)
+void la_from_obdo(struct lu_attr *dst, struct obdo *obdo, u32 valid)
 {
 	__u64 newvalid = 0;
 
@@ -145,7 +145,7 @@ void la_from_obdo(struct lu_attr *dst, struct obdo *obdo, obd_flag valid)
 }
 EXPORT_SYMBOL(la_from_obdo);
 
-void obdo_refresh_inode(struct inode *dst, struct obdo *src, obd_flag valid)
+void obdo_refresh_inode(struct inode *dst, struct obdo *src, u32 valid)
 {
 	valid &= src->o_valid;
 
@@ -180,7 +180,7 @@ void obdo_refresh_inode(struct inode *dst, struct obdo *src, obd_flag valid)
 }
 EXPORT_SYMBOL(obdo_refresh_inode);
 
-void obdo_to_inode(struct inode *dst, struct obdo *src, obd_flag valid)
+void obdo_to_inode(struct inode *dst, struct obdo *src, u32 valid)
 {
 	valid &= src->o_valid;
 
diff --git a/drivers/staging/lustre/lustre/obdclass/local_storage.c b/drivers/staging/lustre/lustre/obdclass/local_storage.c
index 78190225..6e0f6f2 100644
--- a/drivers/staging/lustre/lustre/obdclass/local_storage.c
+++ b/drivers/staging/lustre/lustre/obdclass/local_storage.c
@@ -745,7 +745,7 @@ int local_oid_storage_init(const struct lu_env *env, struct dt_device *dev,
 {
 	struct dt_thread_info	*dti = dt_info(env);
 	struct ls_device	*ls;
-	obd_id			 lastid;
+	u64			 lastid;
 	struct dt_object	*o = NULL;
 	struct thandle		*th;
 	__u32			 first_oid = fid_oid(first_fid);
diff --git a/drivers/staging/lustre/lustre/obdclass/obdo.c b/drivers/staging/lustre/lustre/obdclass/obdo.c
index c9fa36b..0746952 100644
--- a/drivers/staging/lustre/lustre/obdclass/obdo.c
+++ b/drivers/staging/lustre/lustre/obdclass/obdo.c
@@ -56,9 +56,9 @@ EXPORT_SYMBOL(obdo_set_parent_fid);
 
 /* WARNING: the file systems must take care not to tinker with
    attributes they don't manage (such as blocks). */
-void obdo_from_inode(struct obdo *dst, struct inode *src, obd_flag valid)
+void obdo_from_inode(struct obdo *dst, struct inode *src, u32 valid)
 {
-	obd_flag newvalid = 0;
+	u32 newvalid = 0;
 
 	if (valid & (OBD_MD_FLCTIME | OBD_MD_FLMTIME))
 		CDEBUG(D_INODE, "valid %x, new time %lu/%lu\n",
@@ -115,7 +115,7 @@ void obdo_from_inode(struct obdo *dst, struct inode *src, obd_flag valid)
 }
 EXPORT_SYMBOL(obdo_from_inode);
 
-void obdo_cpy_md(struct obdo *dst, struct obdo *src, obd_flag valid)
+void obdo_cpy_md(struct obdo *dst, struct obdo *src, u32 valid)
 {
 	CDEBUG(D_INODE, "src obdo "DOSTID" valid %#llx, dst obdo "DOSTID"\n",
 	       POSTID(&src->o_oi), src->o_valid, POSTID(&dst->o_oi));
@@ -157,7 +157,7 @@ void obdo_cpy_md(struct obdo *dst, struct obdo *src, obd_flag valid)
 EXPORT_SYMBOL(obdo_cpy_md);
 
 /* returns FALSE if comparison (by flags) is same, TRUE if changed */
-int obdo_cmp_md(struct obdo *dst, struct obdo *src, obd_flag compare)
+int obdo_cmp_md(struct obdo *dst, struct obdo *src, u32 compare)
 {
 	int res = 0;
 
@@ -247,7 +247,7 @@ void obdo_from_iattr(struct obdo *oa, struct iattr *attr, unsigned int ia_valid)
 }
 EXPORT_SYMBOL(obdo_from_iattr);
 
-void iattr_from_obdo(struct iattr *attr, struct obdo *oa, obd_flag valid)
+void iattr_from_obdo(struct iattr *attr, struct obdo *oa, u32 valid)
 {
 	valid &= oa->o_valid;
 
@@ -296,7 +296,7 @@ void iattr_from_obdo(struct iattr *attr, struct obdo *oa, obd_flag valid)
 }
 EXPORT_SYMBOL(iattr_from_obdo);
 
-void md_from_obdo(struct md_op_data *op_data, struct obdo *oa, obd_flag valid)
+void md_from_obdo(struct md_op_data *op_data, struct obdo *oa, u32 valid)
 {
 	iattr_from_obdo(&op_data->op_attr, oa, valid);
 	if (valid & OBD_MD_FLBLOCKS) {
diff --git a/drivers/staging/lustre/lustre/obdecho/echo.c b/drivers/staging/lustre/lustre/obdecho/echo.c
index dae1599..358be90 100644
--- a/drivers/staging/lustre/lustre/obdecho/echo.c
+++ b/drivers/staging/lustre/lustre/obdecho/echo.c
@@ -104,7 +104,7 @@ static int echo_destroy_export(struct obd_export *exp)
 
  static __u64 echo_next_id(struct obd_device *obddev)
 {
-	obd_id id;
+	u64 id;
 
 	spin_lock(&obddev->u.echo.eo_lock);
 	id = ++obddev->u.echo.eo_lastino;
@@ -173,7 +173,7 @@ static int echo_getattr(const struct lu_env *env, struct obd_export *exp,
 			struct obd_info *oinfo)
 {
 	struct obd_device *obd = class_exp2obd(exp);
-	obd_id id = ostid_id(&oinfo->oi_oa->o_oi);
+	u64 id = ostid_id(&oinfo->oi_oa->o_oi);
 
 	if (!obd) {
 		CERROR("invalid client cookie %#llx\n",
@@ -224,7 +224,7 @@ static int echo_setattr(const struct lu_env *env, struct obd_export *exp,
 }
 
 static void
-echo_page_debug_setup(struct page *page, int rw, obd_id id,
+echo_page_debug_setup(struct page *page, int rw, u64 id,
 		      __u64 offset, int len)
 {
 	int   page_offset = offset & ~CFS_PAGE_MASK;
@@ -251,7 +251,7 @@ echo_page_debug_setup(struct page *page, int rw, obd_id id,
 }
 
 static int
-echo_page_debug_check(struct page *page, obd_id id,
+echo_page_debug_check(struct page *page, u64 id,
 		      __u64 offset, int len)
 {
 	int   page_offset = offset & ~CFS_PAGE_MASK;
@@ -293,7 +293,7 @@ static int echo_map_nb_to_lb(struct obdo *oa, struct obd_ioobj *obj,
 			   (oa->o_valid & OBD_MD_FLFLAGS) != 0 &&
 			   (oa->o_flags & OBD_FL_DEBUG_CHECK) != 0);
 	struct niobuf_local *res = lb;
-	obd_off offset = nb->offset;
+	u64 offset = nb->offset;
 	int len = nb->len;
 
 	while (len > 0) {
@@ -354,11 +354,12 @@ static int echo_finalize_lb(struct obdo *oa, struct obd_ioobj *obj,
 			    struct niobuf_local *lb, int verify)
 {
 	struct niobuf_local *res = lb;
-	obd_off start  = rb->offset >> PAGE_CACHE_SHIFT;
-	obd_off end    = (rb->offset + rb->len + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-	int     count  = (int)(end - start);
-	int     rc     = 0;
-	int     i;
+	u64 start = rb->offset >> PAGE_CACHE_SHIFT;
+	u64 end = (rb->offset + rb->len + PAGE_CACHE_SIZE - 1) >>
+		  PAGE_CACHE_SHIFT;
+	int count = (int)(end - start);
+	int rc = 0;
+	int i;
 
 	for (i = 0; i < count; i++, (*pgs) ++, res++) {
 		struct page *page = res->page;
diff --git a/drivers/staging/lustre/lustre/obdecho/echo_client.c b/drivers/staging/lustre/lustre/obdecho/echo_client.c
index f1847f3..2273669 100644
--- a/drivers/staging/lustre/lustre/obdecho/echo_client.c
+++ b/drivers/staging/lustre/lustre/obdecho/echo_client.c
@@ -175,10 +175,10 @@ struct echo_object_conf *cl2echo_conf(const struct cl_object_conf *c)
 static struct echo_object *cl_echo_object_find(struct echo_device *d,
 					       struct lov_stripe_md **lsm);
 static int cl_echo_object_put(struct echo_object *eco);
-static int cl_echo_enqueue   (struct echo_object *eco, obd_off start,
-			      obd_off end, int mode, __u64 *cookie);
-static int cl_echo_cancel    (struct echo_device *d, __u64 cookie);
-static int cl_echo_object_brw(struct echo_object *eco, int rw, obd_off offset,
+static int cl_echo_enqueue(struct echo_object *eco, u64 start,
+			   u64 end, int mode, __u64 *cookie);
+static int cl_echo_cancel(struct echo_device *d, __u64 cookie);
+static int cl_echo_object_brw(struct echo_object *eco, int rw, u64 offset,
 			      struct page **pages, int npages, int async);
 
 static struct echo_thread_info *echo_env_info(const struct lu_env *env);
@@ -1141,7 +1141,7 @@ static int cl_echo_object_put(struct echo_object *eco)
 }
 
 static int cl_echo_enqueue0(struct lu_env *env, struct echo_object *eco,
-			    obd_off start, obd_off end, int mode,
+			    u64 start, u64 end, int mode,
 			    __u64 *cookie , __u32 enqflags)
 {
 	struct cl_io *io;
@@ -1186,7 +1186,7 @@ static int cl_echo_enqueue0(struct lu_env *env, struct echo_object *eco,
 	return rc;
 }
 
-static int cl_echo_enqueue(struct echo_object *eco, obd_off start, obd_off end,
+static int cl_echo_enqueue(struct echo_object *eco, u64 start, u64 end,
 			   int mode, __u64 *cookie)
 {
 	struct echo_thread_info *info;
@@ -1280,7 +1280,7 @@ static int cl_echo_async_brw(const struct lu_env *env, struct cl_io *io,
 	return result;
 }
 
-static int cl_echo_object_brw(struct echo_object *eco, int rw, obd_off offset,
+static int cl_echo_object_brw(struct echo_object *eco, int rw, u64 offset,
 			      struct page **pages, int npages, int async)
 {
 	struct lu_env	   *env;
@@ -1374,7 +1374,7 @@ out:
 /** @} echo_exports */
 
 
-static obd_id last_object_id;
+static u64 last_object_id;
 
 static int
 echo_copyout_lsm (struct lov_stripe_md *lsm, void *_ulsm, int ulsm_nob)
@@ -2324,14 +2324,14 @@ static void echo_put_object(struct echo_object *eco)
 }
 
 static void
-echo_get_stripe_off_id (struct lov_stripe_md *lsm, obd_off *offp, obd_id *idp)
+echo_get_stripe_off_id(struct lov_stripe_md *lsm, u64 *offp, u64 *idp)
 {
 	unsigned long stripe_count;
 	unsigned long stripe_size;
 	unsigned long width;
 	unsigned long woffset;
 	int	   stripe_index;
-	obd_off       offset;
+	u64       offset;
 
 	if (lsm->lsm_stripe_count <= 1)
 		return;
@@ -2354,12 +2354,12 @@ echo_get_stripe_off_id (struct lov_stripe_md *lsm, obd_off *offp, obd_id *idp)
 
 static void
 echo_client_page_debug_setup(struct lov_stripe_md *lsm,
-			     struct page *page, int rw, obd_id id,
-			     obd_off offset, obd_off count)
+			     struct page *page, int rw, u64 id,
+			     u64 offset, u64 count)
 {
 	char    *addr;
-	obd_off  stripe_off;
-	obd_id   stripe_id;
+	u64	 stripe_off;
+	u64	 stripe_id;
 	int      delta;
 
 	/* no partial pages on the client */
@@ -2384,11 +2384,11 @@ echo_client_page_debug_setup(struct lov_stripe_md *lsm,
 }
 
 static int echo_client_page_debug_check(struct lov_stripe_md *lsm,
-					struct page *page, obd_id id,
-					obd_off offset, obd_off count)
+					struct page *page, u64 id,
+					u64 offset, u64 count)
 {
-	obd_off stripe_off;
-	obd_id  stripe_id;
+	u64	stripe_off;
+	u64	stripe_id;
 	char   *addr;
 	int     delta;
 	int     rc;
@@ -2418,16 +2418,16 @@ static int echo_client_page_debug_check(struct lov_stripe_md *lsm,
 }
 
 static int echo_client_kbrw(struct echo_device *ed, int rw, struct obdo *oa,
-			    struct echo_object *eco, obd_off offset,
-			    obd_size count, int async,
+			    struct echo_object *eco, u64 offset,
+			    u64 count, int async,
 			    struct obd_trans_info *oti)
 {
 	struct lov_stripe_md   *lsm = eco->eo_lsm;
-	obd_count	       npages;
+	u32	       npages;
 	struct brw_page	*pga;
 	struct brw_page	*pgp;
 	struct page	    **pages;
-	obd_off		 off;
+	u64		 off;
 	int		     i;
 	int		     rc;
 	int		     verify;
@@ -2516,16 +2516,16 @@ static int echo_client_kbrw(struct echo_device *ed, int rw, struct obdo *oa,
 static int echo_client_prep_commit(const struct lu_env *env,
 				   struct obd_export *exp, int rw,
 				   struct obdo *oa, struct echo_object *eco,
-				   obd_off offset, obd_size count,
-				   obd_size batch, struct obd_trans_info *oti,
+				   u64 offset, u64 count,
+				   u64 batch, struct obd_trans_info *oti,
 				   int async)
 {
 	struct lov_stripe_md *lsm = eco->eo_lsm;
 	struct obd_ioobj ioo;
 	struct niobuf_local *lnb;
 	struct niobuf_remote *rnb;
-	obd_off off;
-	obd_size npages, tot_pages;
+	u64 off;
+	u64 npages, tot_pages;
 	int i, ret = 0, brw_flags = 0;
 
 	if (count <= 0 || (count & (~CFS_PAGE_MASK)) != 0 ||
@@ -2677,12 +2677,12 @@ static int echo_client_brw_ioctl(const struct lu_env *env, int rw,
 
 static int
 echo_client_enqueue(struct obd_export *exp, struct obdo *oa,
-		    int mode, obd_off offset, obd_size nob)
+		    int mode, u64 offset, u64 nob)
 {
 	struct echo_device     *ed = obd2echo_dev(exp->exp_obd);
 	struct lustre_handle   *ulh = &oa->o_handle;
 	struct echo_object     *eco;
-	obd_off		 end;
+	u64		 end;
 	int		     rc;
 
 	if (ed->ed_next == NULL)
@@ -2699,7 +2699,7 @@ echo_client_enqueue(struct obd_export *exp, struct obdo *oa,
 	if (rc != 0)
 		return rc;
 
-	end = (nob == 0) ? ((obd_off) -1) : (offset + nob - 1);
+	end = (nob == 0) ? ((u64) -1) : (offset + nob - 1);
 	rc = cl_echo_enqueue(eco, offset, end, mode, &ulh->cookie);
 	if (rc == 0) {
 		oa->o_valid |= OBD_MD_FLHANDLE;
diff --git a/drivers/staging/lustre/lustre/osc/lproc_osc.c b/drivers/staging/lustre/lustre/osc/lproc_osc.c
index 2ab4035..ad2777f 100644
--- a/drivers/staging/lustre/lustre/osc/lproc_osc.c
+++ b/drivers/staging/lustre/lustre/osc/lproc_osc.c
@@ -148,7 +148,7 @@ static ssize_t osc_max_dirty_mb_seq_write(struct file *file, const char *buffer,
 		return -ERANGE;
 
 	client_obd_list_lock(&cli->cl_loi_list_lock);
-	cli->cl_dirty_max = (obd_count)(pages_number << PAGE_CACHE_SHIFT);
+	cli->cl_dirty_max = (u32)(pages_number << PAGE_CACHE_SHIFT);
 	osc_wake_cache_waiters(cli);
 	client_obd_list_unlock(&cli->cl_loi_list_lock);
 
diff --git a/drivers/staging/lustre/lustre/osc/osc_cache.c b/drivers/staging/lustre/lustre/osc/osc_cache.c
index 57d7dba..7734d66 100644
--- a/drivers/staging/lustre/lustre/osc/osc_cache.c
+++ b/drivers/staging/lustre/lustre/osc/osc_cache.c
@@ -1885,7 +1885,7 @@ osc_send_write_rpc(const struct lu_env *env, struct client_obd *cli,
 	struct osc_extent *ext;
 	struct osc_extent *tmp;
 	struct osc_extent *first = NULL;
-	obd_count page_count = 0;
+	u32 page_count = 0;
 	int srvlock = 0;
 	int rc = 0;
 
diff --git a/drivers/staging/lustre/lustre/osc/osc_cl_internal.h b/drivers/staging/lustre/lustre/osc/osc_cl_internal.h
index 2d1f977..3aa80d9 100644
--- a/drivers/staging/lustre/lustre/osc/osc_cl_internal.h
+++ b/drivers/staging/lustre/lustre/osc/osc_cl_internal.h
@@ -435,7 +435,7 @@ void osc_page_submit(const struct lu_env *env, struct osc_page *opg,
 		     enum cl_req_type crt, int brw_flags);
 int osc_cancel_async_page(const struct lu_env *env, struct osc_page *ops);
 int osc_set_async_flags(struct osc_object *obj, struct osc_page *opg,
-			obd_flag async_flags);
+			u32 async_flags);
 int osc_prep_async_page(struct osc_object *osc, struct osc_page *ops,
 			struct page *page, loff_t offset);
 int osc_queue_async_io(const struct lu_env *env, struct cl_io *io,
diff --git a/drivers/staging/lustre/lustre/osc/osc_internal.h b/drivers/staging/lustre/lustre/osc/osc_internal.h
index f67a700..0f182da 100644
--- a/drivers/staging/lustre/lustre/osc/osc_internal.h
+++ b/drivers/staging/lustre/lustre/osc/osc_internal.h
@@ -59,7 +59,7 @@ struct osc_async_page {
 	struct list_head	      oap_pending_item;
 	struct list_head	      oap_rpc_item;
 
-	obd_off		 oap_obj_off;
+	u64		 oap_obj_off;
 	unsigned		oap_page_off;
 	enum async_flags	oap_async_flags;
 
@@ -192,12 +192,12 @@ extern struct kmem_cache *osc_quota_kmem;
 struct osc_quota_info {
 	/** linkage for quota hash table */
 	struct hlist_node oqi_hash;
-	obd_uid	  oqi_id;
+	u32	  oqi_id;
 };
 int osc_quota_setup(struct obd_device *obd);
 int osc_quota_cleanup(struct obd_device *obd);
 int osc_quota_setdq(struct client_obd *cli, const unsigned int qid[],
-		    obd_flag valid, obd_flag flags);
+		    u32 valid, u32 flags);
 int osc_quota_chkdq(struct client_obd *cli, const unsigned int qid[]);
 int osc_quotactl(struct obd_device *unused, struct obd_export *exp,
 		 struct obd_quotactl *oqctl);
diff --git a/drivers/staging/lustre/lustre/osc/osc_io.c b/drivers/staging/lustre/lustre/osc/osc_io.c
index 54fe836..886b1ef 100644
--- a/drivers/staging/lustre/lustre/osc/osc_io.c
+++ b/drivers/staging/lustre/lustre/osc/osc_io.c
@@ -711,7 +711,7 @@ static void osc_req_completion(const struct lu_env *env,
 static void osc_req_attr_set(const struct lu_env *env,
 			     const struct cl_req_slice *slice,
 			     const struct cl_object *obj,
-			     struct cl_req_attr *attr, obd_valid flags)
+			     struct cl_req_attr *attr, u64 flags)
 {
 	struct lov_oinfo *oinfo;
 	struct cl_req    *clerq;
diff --git a/drivers/staging/lustre/lustre/osc/osc_quota.c b/drivers/staging/lustre/lustre/osc/osc_quota.c
index 3563809..db4540a 100644
--- a/drivers/staging/lustre/lustre/osc/osc_quota.c
+++ b/drivers/staging/lustre/lustre/osc/osc_quota.c
@@ -31,7 +31,7 @@
 #include "../include/obd_ost.h"
 #include "osc_internal.h"
 
-static inline struct osc_quota_info *osc_oqi_alloc(obd_uid id)
+static inline struct osc_quota_info *osc_oqi_alloc(u32 id)
 {
 	struct osc_quota_info *oqi;
 
@@ -71,7 +71,7 @@ int osc_quota_chkdq(struct client_obd *cli, const unsigned int qid[])
 						: OBD_FL_NO_GRPQUOTA)
 
 int osc_quota_setdq(struct client_obd *cli, const unsigned int qid[],
-		    obd_flag valid, obd_flag flags)
+		    u32 valid, u32 flags)
 {
 	int type;
 	int rc = 0;
@@ -145,10 +145,10 @@ static int
 oqi_keycmp(const void *key, struct hlist_node *hnode)
 {
 	struct osc_quota_info *oqi;
-	obd_uid uid;
+	u32 uid;
 
 	LASSERT(key != NULL);
-	uid = *((obd_uid*)key);
+	uid = *((u32 *)key);
 	oqi = hlist_entry(hnode, struct osc_quota_info, oqi_hash);
 
 	return uid == oqi->oqi_id;
diff --git a/drivers/staging/lustre/lustre/osc/osc_request.c b/drivers/staging/lustre/lustre/osc/osc_request.c
index fb0d9fb..c502f34 100644
--- a/drivers/staging/lustre/lustre/osc/osc_request.c
+++ b/drivers/staging/lustre/lustre/osc/osc_request.c
@@ -54,7 +54,7 @@
 #include "osc_internal.h"
 #include "osc_cl_internal.h"
 
-static void osc_release_ppga(struct brw_page **ppga, obd_count count);
+static void osc_release_ppga(struct brw_page **ppga, u32 count);
 static int brw_interpret(const struct lu_env *env,
 			 struct ptlrpc_request *req, void *data, int rc);
 int osc_cleanup(struct obd_device *obd);
@@ -615,7 +615,7 @@ int osc_sync_base(struct obd_export *exp, struct obd_info *oinfo,
 }
 
 static int osc_sync(const struct lu_env *env, struct obd_export *exp,
-		    struct obd_info *oinfo, obd_size start, obd_size end,
+		    struct obd_info *oinfo, u64 start, u64 end,
 		    struct ptlrpc_request_set *set)
 {
 	if (!oinfo->oi_oa) {
@@ -799,7 +799,7 @@ static int osc_destroy(const struct lu_env *env, struct obd_export *exp,
 static void osc_announce_cached(struct client_obd *cli, struct obdo *oa,
 				long writing_bytes)
 {
-	obd_flag bits = OBD_MD_FLBLOCKS|OBD_MD_FLGRANT;
+	u32 bits = OBD_MD_FLBLOCKS|OBD_MD_FLGRANT;
 
 	LASSERT(!(oa->o_valid & bits));
 
@@ -849,7 +849,7 @@ void osc_update_next_shrink(struct client_obd *cli)
 	       cli->cl_next_shrink_grant);
 }
 
-static void __osc_update_grant(struct client_obd *cli, obd_size grant)
+static void __osc_update_grant(struct client_obd *cli, u64 grant)
 {
 	client_obd_list_lock(&cli->cl_loi_list_lock);
 	cli->cl_avail_grant += grant;
@@ -865,7 +865,7 @@ static void osc_update_grant(struct client_obd *cli, struct ost_body *body)
 }
 
 static int osc_set_info_async(const struct lu_env *env, struct obd_export *exp,
-			      obd_count keylen, void *key, obd_count vallen,
+			      u32 keylen, void *key, u32 vallen,
 			      void *val, struct ptlrpc_request_set *set);
 
 static int osc_shrink_grant_interpret(const struct lu_env *env,
@@ -1067,7 +1067,7 @@ static void osc_init_grant(struct client_obd *cli, struct obd_connect_data *ocd)
  * beyond the end of a stripe file; i.e. lustre is reading a sparse file
  * via the LOV, and it _knows_ it's reading inside the file, it's just that
  * this stripe never got written at or beyond this stripe offset yet. */
-static void handle_short_read(int nob_read, obd_count page_count,
+static void handle_short_read(int nob_read, u32 page_count,
 			      struct brw_page **pga)
 {
 	char *ptr;
@@ -1104,7 +1104,7 @@ static void handle_short_read(int nob_read, obd_count page_count,
 
 static int check_write_rcs(struct ptlrpc_request *req,
 			   int requested_nob, int niocount,
-			   obd_count page_count, struct brw_page **pga)
+			   u32 page_count, struct brw_page **pga)
 {
 	int     i;
 	__u32   *remote_rcs;
@@ -1157,7 +1157,7 @@ static inline int can_merge_pages(struct brw_page *p1, struct brw_page *p2)
 	return (p1->off + p1->count == p2->off);
 }
 
-static obd_count osc_checksum_bulk(int nob, obd_count pg_count,
+static u32 osc_checksum_bulk(int nob, u32 pg_count,
 				   struct brw_page **pga, int opc,
 				   cksum_type_t cksum_type)
 {
@@ -1219,7 +1219,7 @@ static obd_count osc_checksum_bulk(int nob, obd_count pg_count,
 }
 
 static int osc_brw_prep_request(int cmd, struct client_obd *cli,struct obdo *oa,
-				struct lov_stripe_md *lsm, obd_count page_count,
+				struct lov_stripe_md *lsm, u32 page_count,
 				struct brw_page **pga,
 				struct ptlrpc_request **reqp,
 				struct obd_capa *ocapa, int reserve,
@@ -1422,7 +1422,7 @@ static int osc_brw_prep_request(int cmd, struct client_obd *cli,struct obdo *oa,
 
 static int check_write_checksum(struct obdo *oa, const lnet_process_id_t *peer,
 				__u32 client_cksum, __u32 server_cksum, int nob,
-				obd_count page_count, struct brw_page **pga,
+				u32 page_count, struct brw_page **pga,
 				cksum_type_t client_cksum_type)
 {
 	__u32 new_cksum;
@@ -1618,7 +1618,7 @@ out:
 
 static int osc_brw_internal(int cmd, struct obd_export *exp, struct obdo *oa,
 			    struct lov_stripe_md *lsm,
-			    obd_count page_count, struct brw_page **pga,
+			    u32 page_count, struct brw_page **pga,
 			    struct obd_capa *ocapa)
 {
 	struct ptlrpc_request *req;
@@ -1787,7 +1787,7 @@ static void sort_brw_pages(struct brw_page **array, int num)
 	} while (stride > 1);
 }
 
-static obd_count max_unfragmented_pages(struct brw_page **pg, obd_count pages)
+static u32 max_unfragmented_pages(struct brw_page **pg, u32 pages)
 {
 	int count = 1;
 	int offset;
@@ -1813,7 +1813,7 @@ static obd_count max_unfragmented_pages(struct brw_page **pg, obd_count pages)
 	}
 }
 
-static struct brw_page **osc_build_ppga(struct brw_page *pga, obd_count count)
+static struct brw_page **osc_build_ppga(struct brw_page *pga, u32 count)
 {
 	struct brw_page **ppga;
 	int i;
@@ -1827,14 +1827,14 @@ static struct brw_page **osc_build_ppga(struct brw_page *pga, obd_count count)
 	return ppga;
 }
 
-static void osc_release_ppga(struct brw_page **ppga, obd_count count)
+static void osc_release_ppga(struct brw_page **ppga, u32 count)
 {
 	LASSERT(ppga != NULL);
 	OBD_FREE(ppga, sizeof(*ppga) * count);
 }
 
 static int osc_brw(int cmd, struct obd_export *exp, struct obd_info *oinfo,
-		   obd_count page_count, struct brw_page *pga,
+		   u32 page_count, struct brw_page *pga,
 		   struct obd_trans_info *oti)
 {
 	struct obdo *saved_oa = NULL;
@@ -1867,7 +1867,7 @@ static int osc_brw(int cmd, struct obd_export *exp, struct obd_info *oinfo,
 
 	sort_brw_pages(ppga, page_count);
 	while (page_count) {
-		obd_count pages_per_brw;
+		u32 pages_per_brw;
 
 		if (page_count > cli->cl_max_pages_per_rpc)
 			pages_per_brw = cli->cl_max_pages_per_rpc;
@@ -2029,8 +2029,8 @@ int osc_build_rpc(const struct lu_env *env, struct client_obd *cli,
 								      CRT_READ;
 	struct ldlm_lock		*lock = NULL;
 	struct cl_req_attr		*crattr = NULL;
-	obd_off				starting_offset = OBD_OBJECT_EOF;
-	obd_off				ending_offset = 0;
+	u64				starting_offset = OBD_OBJECT_EOF;
+	u64				ending_offset = 0;
 	int				mpflag = 0;
 	int				mem_tight = 0;
 	int				page_count = 0;
@@ -2965,7 +2965,7 @@ out:
 }
 
 static int osc_get_info(const struct lu_env *env, struct obd_export *exp,
-			obd_count keylen, void *key, __u32 *vallen, void *val,
+			u32 keylen, void *key, __u32 *vallen, void *val,
 			struct lov_stripe_md *lsm)
 {
 	if (!vallen || !val)
@@ -2978,7 +2978,7 @@ static int osc_get_info(const struct lu_env *env, struct obd_export *exp,
 		return 0;
 	} else if (KEY_IS(KEY_LAST_ID)) {
 		struct ptlrpc_request *req;
-		obd_id		*reply;
+		u64		*reply;
 		char		  *tmp;
 		int		    rc;
 
@@ -3008,7 +3008,7 @@ static int osc_get_info(const struct lu_env *env, struct obd_export *exp,
 		if (reply == NULL)
 			GOTO(out, rc = -EPROTO);
 
-		*((obd_id *)val) = *reply;
+		*((u64 *)val) = *reply;
 	out:
 		ptlrpc_req_finished(req);
 		return rc;
@@ -3100,7 +3100,7 @@ drop_lock:
 }
 
 static int osc_set_info_async(const struct lu_env *env, struct obd_export *exp,
-			      obd_count keylen, void *key, obd_count vallen,
+			      u32 keylen, void *key, u32 vallen,
 			      void *val, struct ptlrpc_request_set *set)
 {
 	struct ptlrpc_request *req;
@@ -3562,7 +3562,7 @@ int osc_process_config_base(struct obd_device *obd, struct lustre_cfg *lcfg)
 	return(rc);
 }
 
-static int osc_process_config(struct obd_device *obd, obd_count len, void *buf)
+static int osc_process_config(struct obd_device *obd, u32 len, void *buf)
 {
 	return osc_process_config_base(obd, buf);
 }
diff --git a/drivers/staging/lustre/lustre/ptlrpc/layout.c b/drivers/staging/lustre/lustre/ptlrpc/layout.c
index 511cb9c..5b83371 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/layout.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/layout.c
@@ -1094,8 +1094,8 @@ struct req_msg_field RMF_EAVALS_LENS =
 EXPORT_SYMBOL(RMF_EAVALS_LENS);
 
 struct req_msg_field RMF_OBD_ID =
-	DEFINE_MSGF("obd_id", 0,
-		    sizeof(obd_id), lustre_swab_ost_last_id, NULL);
+	DEFINE_MSGF("u64", 0,
+		    sizeof(u64), lustre_swab_ost_last_id, NULL);
 EXPORT_SYMBOL(RMF_OBD_ID);
 
 struct req_msg_field RMF_FID =
diff --git a/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c b/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
index ac56293..50556db 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
@@ -1600,8 +1600,8 @@ EXPORT_SYMBOL(ptlrpc_req_set_repsize);
  */
 int do_set_info_async(struct obd_import *imp,
 		      int opcode, int version,
-		      obd_count keylen, void *key,
-		      obd_count vallen, void *val,
+		      u32 keylen, void *key,
+		      u32 vallen, void *val,
 		      struct ptlrpc_request_set *set)
 {
 	struct ptlrpc_request *req;
@@ -1797,7 +1797,7 @@ void lustre_swab_ost_body(struct ost_body *b)
 }
 EXPORT_SYMBOL(lustre_swab_ost_body);
 
-void lustre_swab_ost_last_id(obd_id *id)
+void lustre_swab_ost_last_id(u64 *id)
 {
 	__swab64s(id);
 }
-- 
1.9.3

