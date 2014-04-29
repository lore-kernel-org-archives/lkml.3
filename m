Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbaD2LM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:12:56 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:33759 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbaD2LMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:12:52 -0400
MIME-Version: 1.0
In-Reply-To: <1398618431-29757-42-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
	<1398618431-29757-42-git-send-email-green@linuxhacker.ru>
Date: Tue, 29 Apr 2014 13:12:51 +0200
Message-ID: <CAFLxGvwtt1smUuDB-HQxBJnqhvw6rMvdeqYaSpwepVcxHTBCUg@mail.gmail.com>
Subject: Re: [PATCH 41/47] staging/lustre/llite: remove dead code
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        "John L. Hammond" <john.hammond@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 7:07 PM, Oleg Drokin <green@linuxhacker.ru> wrote:
> From: "John L. Hammond" <john.hammond@intel.com>
>
> In llite remove unused declarations, parameters, types, and unused,
> get-only, or set-only structure members. Add static and const
> qualifiers to declarations where possible.

While we are here, does lustre really need all these exports?

rw@sandpuppy:~/linux (master $)> git grep EXPORT_SYMBOL
drivers/staging/lustre | wc -l
1499

Some exports also have very generic names like the class_* stuff or
at_max, at_min...

> Signed-off-by: John L. Hammond <john.hammond@intel.com>
> Reviewed-on: http://review.whamcloud.com/9767
> Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2675
> Reviewed-by: Lai Siyao <lai.siyao@intel.com>
> Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
> Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
> ---
>  drivers/staging/lustre/lustre/lclient/lcommon_cl.c |   4 +-
>  drivers/staging/lustre/lustre/llite/dcache.c       |  26 ++--
>  drivers/staging/lustre/lustre/llite/dir.c          |   8 +-
>  drivers/staging/lustre/lustre/llite/file.c         |  89 ++++++-------
>  drivers/staging/lustre/lustre/llite/llite_capa.c   |   4 +-
>  .../staging/lustre/lustre/llite/llite_internal.h   | 138 ++++-----------------
>  drivers/staging/lustre/lustre/llite/llite_lib.c    |  64 +---------
>  drivers/staging/lustre/lustre/llite/llite_mmap.c   |  23 +---
>  drivers/staging/lustre/lustre/llite/lloop.c        |   5 -
>  drivers/staging/lustre/lustre/llite/lproc_llite.c  |   4 +-
>  drivers/staging/lustre/lustre/llite/namei.c        |  40 ++----
>  drivers/staging/lustre/lustre/llite/remote_perm.c  |   2 +-
>  drivers/staging/lustre/lustre/llite/rw.c           |   7 --
>  drivers/staging/lustre/lustre/llite/rw26.c         |  15 +--
>  drivers/staging/lustre/lustre/llite/statahead.c    |   8 --
>  drivers/staging/lustre/lustre/llite/super25.c      |   7 +-
>  drivers/staging/lustre/lustre/llite/vvp_dev.c      |   6 +-
>  drivers/staging/lustre/lustre/llite/vvp_internal.h |   2 +-
>  drivers/staging/lustre/lustre/llite/vvp_io.c       |   2 +-
>  drivers/staging/lustre/lustre/llite/vvp_object.c   |   4 +-
>  drivers/staging/lustre/lustre/llite/xattr_cache.c  |   2 +-
>  21 files changed, 125 insertions(+), 335 deletions(-)
>
> diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
> index 12812fc..dc24cfa 100644
> --- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
> +++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
> @@ -63,7 +63,7 @@
>
>  #include "../llite/llite_internal.h"
>
> -const struct cl_req_operations ccc_req_ops;
> +static const struct cl_req_operations ccc_req_ops;
>
>  /*
>   * ccc_ prefix stands for "Common Client Code".
> @@ -962,7 +962,7 @@ void ccc_req_attr_set(const struct lu_env *env,
>                JOBSTATS_JOBID_SIZE);
>  }
>
> -const struct cl_req_operations ccc_req_ops = {
> +static const struct cl_req_operations ccc_req_ops = {
>         .cro_attr_set   = ccc_req_attr_set,
>         .cro_completion = ccc_req_completion
>  };
> diff --git a/drivers/staging/lustre/lustre/llite/dcache.c b/drivers/staging/lustre/lustre/llite/dcache.c
> index 8b55080..7d520d8 100644
> --- a/drivers/staging/lustre/lustre/llite/dcache.c
> +++ b/drivers/staging/lustre/lustre/llite/dcache.c
> @@ -69,8 +69,7 @@ static void ll_release(struct dentry *de)
>                 ll_intent_release(lld->lld_it);
>                 OBD_FREE(lld->lld_it, sizeof(*lld->lld_it));
>         }
> -       LASSERT(lld->lld_cwd_count == 0);
> -       LASSERT(lld->lld_mnt_count == 0);
> +
>         de->d_fsdata = NULL;
>         call_rcu(&lld->lld_rcu_head, free_dentry_data);
>  }
> @@ -82,8 +81,9 @@ static void ll_release(struct dentry *de)
>   * an AST before calling d_revalidate_it().  The dentry still exists (marked
>   * INVALID) so d_lookup() matches it, but we have no lock on it (so
>   * lock_match() fails) and we spin around real_lookup(). */
> -int ll_dcompare(const struct dentry *parent, const struct dentry *dentry,
> -               unsigned int len, const char *str, const struct qstr *name)
> +static int ll_dcompare(const struct dentry *parent, const struct dentry *dentry,
> +                      unsigned int len, const char *str,
> +                      const struct qstr *name)
>  {
>         if (len != name->len)
>                 return 1;
> @@ -238,7 +238,8 @@ void ll_intent_release(struct lookup_intent *it)
>         ll_intent_drop_lock(it);
>         /* We are still holding extra reference on a request, need to free it */
>         if (it_disposition(it, DISP_ENQ_OPEN_REF))
> -                ptlrpc_req_finished(it->d.lustre.it_data); /* ll_file_open */
> +               ptlrpc_req_finished(it->d.lustre.it_data); /* ll_file_open */
> +
>         if (it_disposition(it, DISP_ENQ_CREATE_REF)) /* create rec */
>                 ptlrpc_req_finished(it->d.lustre.it_data);
>
> @@ -316,15 +317,6 @@ void ll_lookup_finish_locks(struct lookup_intent *it, struct dentry *dentry)
>         }
>  }
>
> -void ll_frob_intent(struct lookup_intent **itp, struct lookup_intent *deft)
> -{
> -       struct lookup_intent *it = *itp;
> -
> -       if (!it || it->it_op == IT_GETXATTR)
> -               it = *itp = deft;
> -
> -}
> -
>  static int ll_revalidate_dentry(struct dentry *dentry,
>                                 unsigned int lookup_flags)
>  {
> @@ -356,7 +348,7 @@ static int ll_revalidate_dentry(struct dentry *dentry,
>  /*
>   * Always trust cached dentries. Update statahead window if necessary.
>   */
> -int ll_revalidate_nd(struct dentry *dentry, unsigned int flags)
> +static int ll_revalidate_nd(struct dentry *dentry, unsigned int flags)
>  {
>         int rc;
>
> @@ -368,7 +360,7 @@ int ll_revalidate_nd(struct dentry *dentry, unsigned int flags)
>  }
>
>
> -void ll_d_iput(struct dentry *de, struct inode *inode)
> +static void ll_d_iput(struct dentry *de, struct inode *inode)
>  {
>         LASSERT(inode);
>         if (!find_cbdata(inode))
> @@ -376,7 +368,7 @@ void ll_d_iput(struct dentry *de, struct inode *inode)
>         iput(inode);
>  }
>
> -struct dentry_operations ll_d_ops = {
> +const struct dentry_operations ll_d_ops = {
>         .d_revalidate = ll_revalidate_nd,
>         .d_release = ll_release,
>         .d_delete  = ll_ddelete,
> diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
> index f7d3065..ae6f61a 100644
> --- a/drivers/staging/lustre/lustre/llite/dir.c
> +++ b/drivers/staging/lustre/lustre/llite/dir.c
> @@ -632,7 +632,7 @@ out:
>         return rc;
>  }
>
> -int ll_send_mgc_param(struct obd_export *mgc, char *string)
> +static int ll_send_mgc_param(struct obd_export *mgc, char *string)
>  {
>         struct mgs_send_param *msp;
>         int rc = 0;
> @@ -1964,17 +1964,17 @@ out:
>         return ret;
>  }
>
> -int ll_dir_open(struct inode *inode, struct file *file)
> +static int ll_dir_open(struct inode *inode, struct file *file)
>  {
>         return ll_file_open(inode, file);
>  }
>
> -int ll_dir_release(struct inode *inode, struct file *file)
> +static int ll_dir_release(struct inode *inode, struct file *file)
>  {
>         return ll_file_release(inode, file);
>  }
>
> -struct file_operations ll_dir_operations = {
> +const struct file_operations ll_dir_operations = {
>         .llseek   = ll_dir_seek,
>         .open     = ll_dir_open,
>         .release  = ll_dir_release,
> diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
> index e3bc2b0..4d8f6a0 100644
> --- a/drivers/staging/lustre/lustre/llite/file.c
> +++ b/drivers/staging/lustre/lustre/llite/file.c
> @@ -50,7 +50,17 @@
>
>  #include "cl_object.h"
>
> -struct ll_file_data *ll_file_data_get(void)
> +static int
> +ll_put_grouplock(struct inode *inode, struct file *file, unsigned long arg);
> +
> +static int ll_lease_close(struct obd_client_handle *och, struct inode *inode,
> +                         bool *lease_broken);
> +
> +static enum llioc_iter
> +ll_iocontrol_call(struct inode *inode, struct file *file,
> +                 unsigned int cmd, unsigned long arg, int *rcp);
> +
> +static struct ll_file_data *ll_file_data_get(void)
>  {
>         struct ll_file_data *fd;
>
> @@ -247,8 +257,8 @@ int ll_md_real_close(struct inode *inode, fmode_t fmode)
>         return rc;
>  }
>
> -int ll_md_close(struct obd_export *md_exp, struct inode *inode,
> -               struct file *file)
> +static int ll_md_close(struct obd_export *md_exp, struct inode *inode,
> +                      struct file *file)
>  {
>         struct ll_file_data *fd = LUSTRE_FPRIVATE(file);
>         struct ll_inode_info *lli = ll_i2info(inode);
> @@ -482,8 +492,8 @@ static int ll_och_fill(struct obd_export *md_exp, struct lookup_intent *it,
>         return md_set_open_replay_data(md_exp, och, it);
>  }
>
> -int ll_local_open(struct file *file, struct lookup_intent *it,
> -                 struct ll_file_data *fd, struct obd_client_handle *och)
> +static int ll_local_open(struct file *file, struct lookup_intent *it,
> +                        struct ll_file_data *fd, struct obd_client_handle *och)
>  {
>         struct inode *inode = file->f_dentry->d_inode;
>         struct ll_inode_info *lli = ll_i2info(inode);
> @@ -733,8 +743,9 @@ static int ll_md_blocking_lease_ast(struct ldlm_lock *lock,
>  /**
>   * Acquire a lease and open the file.
>   */
> -struct obd_client_handle *ll_lease_open(struct inode *inode, struct file *file,
> -                                       fmode_t fmode, __u64 open_flags)
> +static struct obd_client_handle *
> +ll_lease_open(struct inode *inode, struct file *file, fmode_t fmode,
> +             __u64 open_flags)
>  {
>         struct lookup_intent it = { .it_op = IT_OPEN };
>         struct ll_sb_info *sbi = ll_i2sbi(inode);
> @@ -862,14 +873,13 @@ out:
>         OBD_FREE_PTR(och);
>         return ERR_PTR(rc);
>  }
> -EXPORT_SYMBOL(ll_lease_open);
>
>  /**
>   * Release lease and close the file.
>   * It will check if the lease has ever broken.
>   */
> -int ll_lease_close(struct obd_client_handle *och, struct inode *inode,
> -                       bool *lease_broken)
> +static int ll_lease_close(struct obd_client_handle *och, struct inode *inode,
> +                         bool *lease_broken)
>  {
>         struct ldlm_lock *lock;
>         bool cancelled = true;
> @@ -895,7 +905,6 @@ int ll_lease_close(struct obd_client_handle *och, struct inode *inode,
>                                        NULL);
>         return rc;
>  }
> -EXPORT_SYMBOL(ll_lease_close);
>
>  /* Fills the obdo with the attributes for the lsm */
>  static int ll_lsm_getattr(struct lov_stripe_md *lsm, struct obd_export *exp,
> @@ -1590,7 +1599,8 @@ static int ll_lov_getstripe(struct inode *inode, unsigned long arg)
>         return rc;
>  }
>
> -int ll_get_grouplock(struct inode *inode, struct file *file, unsigned long arg)
> +static int
> +ll_get_grouplock(struct inode *inode, struct file *file, unsigned long arg)
>  {
>         struct ll_inode_info   *lli = ll_i2info(inode);
>         struct ll_file_data    *fd = LUSTRE_FPRIVATE(file);
> @@ -1710,8 +1720,8 @@ out:
>   * Get size for inode for which FIEMAP mapping is requested.
>   * Make the FIEMAP get_info call and returns the result.
>   */
> -int ll_do_fiemap(struct inode *inode, struct ll_user_fiemap *fiemap,
> -             int num_bytes)
> +static int ll_do_fiemap(struct inode *inode, struct ll_user_fiemap *fiemap,
> +                       int num_bytes)
>  {
>         struct obd_export *exp = ll_i2dtexp(inode);
>         struct lov_stripe_md *lsm = NULL;
> @@ -2190,7 +2200,8 @@ out:
>         return rc;
>  }
>
> -long ll_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +static long
> +ll_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
>         struct inode            *inode = file->f_dentry->d_inode;
>         struct ll_file_data     *fd = LUSTRE_FPRIVATE(file);
> @@ -2509,7 +2520,7 @@ long ll_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  }
>
>
> -loff_t ll_file_seek(struct file *file, loff_t offset, int origin)
> +static loff_t ll_file_seek(struct file *file, loff_t offset, int origin)
>  {
>         struct inode *inode = file->f_dentry->d_inode;
>         loff_t retval, eof = 0;
> @@ -2533,7 +2544,7 @@ loff_t ll_file_seek(struct file *file, loff_t offset, int origin)
>         return retval;
>  }
>
> -int ll_flush(struct file *file, fl_owner_t id)
> +static int ll_flush(struct file *file, fl_owner_t id)
>  {
>         struct inode *inode = file->f_dentry->d_inode;
>         struct ll_inode_info *lli = ll_i2info(inode);
> @@ -2670,7 +2681,8 @@ int ll_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>         return rc;
>  }
>
> -int ll_file_flock(struct file *file, int cmd, struct file_lock *file_lock)
> +static int
> +ll_file_flock(struct file *file, int cmd, struct file_lock *file_lock)
>  {
>         struct inode *inode = file->f_dentry->d_inode;
>         struct ll_sb_info *sbi = ll_i2sbi(inode);
> @@ -2799,7 +2811,8 @@ int ll_file_flock(struct file *file, int cmd, struct file_lock *file_lock)
>         return rc;
>  }
>
> -int ll_file_noflock(struct file *file, int cmd, struct file_lock *file_lock)
> +static int
> +ll_file_noflock(struct file *file, int cmd, struct file_lock *file_lock)
>  {
>         return -ENOSYS;
>  }
> @@ -2891,8 +2904,7 @@ static int ll_inode_revalidate_fini(struct inode *inode, int rc)
>         return rc;
>  }
>
> -int __ll_inode_revalidate_it(struct dentry *dentry, struct lookup_intent *it,
> -                            __u64 ibits)
> +static int __ll_inode_revalidate(struct dentry *dentry, __u64 ibits)
>  {
>         struct inode *inode = dentry->d_inode;
>         struct ptlrpc_request *req = NULL;
> @@ -2987,13 +2999,12 @@ out:
>         return rc;
>  }
>
> -int ll_inode_revalidate_it(struct dentry *dentry, struct lookup_intent *it,
> -                          __u64 ibits)
> +static int ll_inode_revalidate(struct dentry *dentry, __u64 ibits)
>  {
>         struct inode *inode = dentry->d_inode;
>         int rc;
>
> -       rc = __ll_inode_revalidate_it(dentry, it, ibits);
> +       rc = __ll_inode_revalidate(dentry, ibits);
>         if (rc != 0)
>                 return rc;
>
> @@ -3016,16 +3027,15 @@ int ll_inode_revalidate_it(struct dentry *dentry, struct lookup_intent *it,
>         return rc;
>  }
>
> -int ll_getattr_it(struct vfsmount *mnt, struct dentry *de,
> -                 struct lookup_intent *it, struct kstat *stat)
> +int ll_getattr(struct vfsmount *mnt, struct dentry *de, struct kstat *stat)
>  {
>         struct inode *inode = de->d_inode;
>         struct ll_sb_info *sbi = ll_i2sbi(inode);
>         struct ll_inode_info *lli = ll_i2info(inode);
>         int res = 0;
>
> -       res = ll_inode_revalidate_it(de, it, MDS_INODELOCK_UPDATE |
> -                                            MDS_INODELOCK_LOOKUP);
> +       res = ll_inode_revalidate(de, MDS_INODELOCK_UPDATE |
> +                                     MDS_INODELOCK_LOOKUP);
>         ll_stats_ops_tally(sbi, LPROC_LL_GETATTR, 1);
>
>         if (res)
> @@ -3051,15 +3061,9 @@ int ll_getattr_it(struct vfsmount *mnt, struct dentry *de,
>
>         return 0;
>  }
> -int ll_getattr(struct vfsmount *mnt, struct dentry *de, struct kstat *stat)
> -{
> -       struct lookup_intent it = { .it_op = IT_GETATTR };
> -
> -       return ll_getattr_it(mnt, de, &it, stat);
> -}
>
> -int ll_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> -               __u64 start, __u64 len)
> +static int ll_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> +                    __u64 start, __u64 len)
>  {
>         int rc;
>         size_t num_bytes;
> @@ -3091,7 +3095,7 @@ int ll_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>         return rc;
>  }
>
> -struct posix_acl * ll_get_acl(struct inode *inode, int type)
> +struct posix_acl *ll_get_acl(struct inode *inode, int type)
>  {
>         struct ll_inode_info *lli = ll_i2info(inode);
>         struct posix_acl *acl = NULL;
> @@ -3118,10 +3122,8 @@ int ll_inode_permission(struct inode *inode, int mask)
>         * need to do it before permission check. */
>
>         if (inode == inode->i_sb->s_root->d_inode) {
> -               struct lookup_intent it = { .it_op = IT_LOOKUP };
> -
> -               rc = __ll_inode_revalidate_it(inode->i_sb->s_root, &it,
> -                                             MDS_INODELOCK_LOOKUP);
> +               rc = __ll_inode_revalidate(inode->i_sb->s_root,
> +                                          MDS_INODELOCK_LOOKUP);
>                 if (rc)
>                         return rc;
>         }
> @@ -3273,8 +3275,9 @@ void ll_iocontrol_unregister(void *magic)
>  EXPORT_SYMBOL(ll_iocontrol_register);
>  EXPORT_SYMBOL(ll_iocontrol_unregister);
>
> -enum llioc_iter ll_iocontrol_call(struct inode *inode, struct file *file,
> -                       unsigned int cmd, unsigned long arg, int *rcp)
> +static enum llioc_iter
> +ll_iocontrol_call(struct inode *inode, struct file *file,
> +                 unsigned int cmd, unsigned long arg, int *rcp)
>  {
>         enum llioc_iter ret = LLIOC_CONT;
>         struct llioc_data *data;
> diff --git a/drivers/staging/lustre/lustre/llite/llite_capa.c b/drivers/staging/lustre/lustre/llite/llite_capa.c
> index edd512b2..d06d0b1 100644
> --- a/drivers/staging/lustre/lustre/llite/llite_capa.c
> +++ b/drivers/staging/lustre/lustre/llite/llite_capa.c
> @@ -68,6 +68,8 @@ static unsigned long long ll_capa_renewal_noent = 0;
>  static unsigned long long ll_capa_renewal_failed = 0;
>  static unsigned long long ll_capa_renewal_retries = 0;
>
> +static int ll_update_capa(struct obd_capa *ocapa, struct lustre_capa *capa);
> +
>  static inline void update_capa_timer(struct obd_capa *ocapa, cfs_time_t expiry)
>  {
>         if (cfs_time_before(expiry, ll_capa_timer.expires) ||
> @@ -515,7 +517,7 @@ static inline void delay_capa_renew(struct obd_capa *oc, cfs_time_t delay)
>         oc->c_expiry = cfs_time_add(oc->c_expiry, cfs_time_seconds(delay));
>  }
>
> -int ll_update_capa(struct obd_capa *ocapa, struct lustre_capa *capa)
> +static int ll_update_capa(struct obd_capa *ocapa, struct lustre_capa *capa)
>  {
>         struct inode *inode = ocapa->u.cli.inode;
>         int rc = 0;
> diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
> index f4b15bf..dde7632 100644
> --- a/drivers/staging/lustre/lustre/llite/llite_internal.h
> +++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
> @@ -71,10 +71,6 @@
>  #define LUSTRE_FPRIVATE(file) ((file)->private_data)
>
>  struct ll_dentry_data {
> -       int                             lld_cwd_count;
> -       int                             lld_mnt_count;
> -       struct obd_client_handle        lld_cwd_och;
> -       struct obd_client_handle        lld_mnt_och;
>         struct lookup_intent            *lld_it;
>         unsigned int                    lld_sa_generation;
>         unsigned int                    lld_invalid:1;
> @@ -83,8 +79,6 @@ struct ll_dentry_data {
>
>  #define ll_d2d(de) ((struct ll_dentry_data*)((de)->d_fsdata))
>
> -extern struct file_operations ll_pgcache_seq_fops;
> -
>  #define LLI_INODE_MAGIC                 0x111d0de5
>  #define LLI_INODE_DEAD           0xdeadd00d
>
> @@ -120,16 +114,12 @@ enum lli_flags {
>         /* Sizeon-on-MDS attributes are changed. An attribute update needs to
>          * be sent to MDS. */
>         LLIF_SOM_DIRTY    = (1 << 3),
> -       /* File is contented */
> -       LLIF_CONTENDED    = (1 << 4),
> -       /* Truncate uses server lock for this file */
> -       LLIF_SRVLOCK        = (1 << 5),
>         /* File data is modified. */
> -       LLIF_DATA_MODIFIED      = (1 << 6),
> +       LLIF_DATA_MODIFIED      = (1 << 4),
>         /* File is being restored */
> -       LLIF_FILE_RESTORING     = (1 << 7),
> +       LLIF_FILE_RESTORING     = (1 << 5),
>         /* Xattr cache is attached to the file */
> -       LLIF_XATTR_CACHE        = (1 << 8),
> +       LLIF_XATTR_CACHE        = (1 << 6),
>  };
>
>  struct ll_inode_info {
> @@ -194,7 +184,6 @@ struct ll_inode_info {
>                          * cleanup the dir readahead. */
>                         void                       *d_opendir_key;
>                         struct ll_statahead_info       *d_sai;
> -                       struct posix_acl               *d_def_acl;
>                         /* protect statahead stuff. */
>                         spinlock_t                      d_sa_lock;
>                         /* "opendir_pid" is the token when lookup/revalid
> @@ -205,7 +194,6 @@ struct ll_inode_info {
>  #define lli_readdir_mutex       u.d.d_readdir_mutex
>  #define lli_opendir_key         u.d.d_opendir_key
>  #define lli_sai                 u.d.d_sai
> -#define lli_def_acl         u.d.d_def_acl
>  #define lli_sa_lock         u.d.d_sa_lock
>  #define lli_opendir_pid         u.d.d_opendir_pid
>
> @@ -232,11 +220,6 @@ struct ll_inode_info {
>                         /* for writepage() only to communicate to fsync */
>                         int                             f_async_rc;
>
> -                       /* volatile file criteria is based on file name, this
> -                        * flag is used to keep the test result, so the strcmp
> -                        * is done only once
> -                        */
> -                       bool                            f_volatile;
>                         /*
>                          * whenever a process try to read/write the file, the
>                          * jobid of the process will be saved here, and it'll
> @@ -259,7 +242,6 @@ struct ll_inode_info {
>  #define lli_agl_index          u.f.f_agl_index
>  #define lli_async_rc           u.f.f_async_rc
>  #define lli_jobid              u.f.f_jobid
> -#define lli_volatile           u.f.f_volatile
>
>         } u;
>
> @@ -459,10 +441,6 @@ enum stats_track_type {
>         "xattr",        \
>  }
>
> -/* default value for ll_sb_info->contention_time */
> -#define SBI_DEFAULT_CONTENTION_SECONDS     60
> -/* default value for lockless_truncate_enable */
> -#define SBI_DEFAULT_LOCKLESS_TRUNCATE_ENABLE 1
>  #define RCE_HASHES      32
>
>  struct rmtacl_ctl_entry {
> @@ -673,12 +651,6 @@ static inline struct inode *ll_info2i(struct ll_inode_info *lli)
>         return &lli->lli_vfs_inode;
>  }
>
> -struct it_cb_data {
> -       struct inode  *icbd_parent;
> -       struct dentry **icbd_childp;
> -       obd_id  hash;
> -};
> -
>  __u32 ll_i2suppgid(struct inode *i);
>  void ll_i2gids(__u32 *suppgids, struct inode *i1,struct inode *i2);
>
> @@ -686,21 +658,13 @@ static inline int ll_need_32bit_api(struct ll_sb_info *sbi)
>  {
>  #if BITS_PER_LONG == 32
>         return 1;
> +#elif defined(CONFIG_COMPAT)
> +       return unlikely(is_compat_task() || (sbi->ll_flags & LL_SBI_32BIT_API));
>  #else
> -       return unlikely(
> -#ifdef CONFIG_COMPAT
> -               is_compat_task() ||
> -#endif
> -               (sbi->ll_flags & LL_SBI_32BIT_API)
> -       );
> +       return unlikely(sbi->ll_flags & LL_SBI_32BIT_API);
>  #endif
>  }
>
> -#define LLAP_MAGIC 98764321
> -
> -extern struct kmem_cache *ll_async_page_slab;
> -extern size_t ll_async_page_slab_size;
> -
>  void ll_ra_read_in(struct file *f, struct ll_ra_read *rar);
>  void ll_ra_read_ex(struct file *f, struct ll_ra_read *rar);
>  struct ll_ra_read *ll_ra_read_get(struct file *f);
> @@ -733,14 +697,16 @@ static inline void ll_rw_stats_tally(struct ll_sb_info *sbi, pid_t pid,
>
>  /* llite/dir.c */
>  void ll_release_page(struct page *page, int remove);
> -extern struct file_operations ll_dir_operations;
> -extern struct inode_operations ll_dir_inode_operations;
> +extern const struct file_operations ll_dir_operations;
> +extern const struct inode_operations ll_dir_inode_operations;
>  struct page *ll_get_dir_page(struct inode *dir, __u64 hash,
>                              struct ll_dir_chain *chain);
>  int ll_dir_read(struct inode *inode, struct dir_context *ctx);
>
>  int ll_get_mdt_idx(struct inode *inode);
>  /* llite/namei.c */
> +extern const struct inode_operations ll_special_inode_operations;
> +
>  int ll_objects_destroy(struct ptlrpc_request *request,
>                        struct inode *dir);
>  struct inode *ll_iget(struct super_block *sb, ino_t hash,
> @@ -755,43 +721,34 @@ int ll_prepare_write(struct file *, struct page *, unsigned from, unsigned to);
>  int ll_commit_write(struct file *, struct page *, unsigned from, unsigned to);
>  int ll_writepage(struct page *page, struct writeback_control *wbc);
>  int ll_writepages(struct address_space *, struct writeback_control *wbc);
> -void ll_removepage(struct page *page);
>  int ll_readpage(struct file *file, struct page *page);
>  void ll_readahead_init(struct inode *inode, struct ll_readahead_state *ras);
> -int ll_file_punch(struct inode *, loff_t, int);
> -ssize_t ll_file_lockless_io(struct file *, char *, size_t, loff_t *, int);
> -void ll_clear_file_contended(struct inode*);
> -int ll_sync_page_range(struct inode *, struct address_space *, loff_t, size_t);
>  int ll_readahead(const struct lu_env *env, struct cl_io *io,
>                  struct ll_readahead_state *ras, struct address_space *mapping,
>                  struct cl_page_list *queue, int flags);
>
> +#ifndef MS_HAS_NEW_AOPS
> +extern const struct address_space_operations ll_aops;
> +#else
> +extern const struct address_space_operations_ext ll_aops;
> +#endif
> +
>  /* llite/file.c */
>  extern struct file_operations ll_file_operations;
>  extern struct file_operations ll_file_operations_flock;
>  extern struct file_operations ll_file_operations_noflock;
>  extern struct inode_operations ll_file_inode_operations;
> -extern int ll_inode_revalidate_it(struct dentry *, struct lookup_intent *,
> -                                 __u64);
>  extern int ll_have_md_lock(struct inode *inode, __u64 *bits,
>                            ldlm_mode_t l_req_mode);
>  extern ldlm_mode_t ll_take_md_lock(struct inode *inode, __u64 bits,
>                                    struct lustre_handle *lockh, __u64 flags,
>                                    ldlm_mode_t mode);
> -int __ll_inode_revalidate_it(struct dentry *, struct lookup_intent *,
> -                            __u64 bits);
> -int ll_revalidate_nd(struct dentry *dentry, unsigned int flags);
>  int ll_file_open(struct inode *inode, struct file *file);
>  int ll_file_release(struct inode *inode, struct file *file);
>  int ll_glimpse_ioctl(struct ll_sb_info *sbi,
>                      struct lov_stripe_md *lsm, lstat_t *st);
>  void ll_ioepoch_open(struct ll_inode_info *lli, __u64 ioepoch);
> -int ll_local_open(struct file *file,
> -                 struct lookup_intent *it, struct ll_file_data *fd,
> -                 struct obd_client_handle *och);
>  int ll_release_openhandle(struct dentry *, struct lookup_intent *);
> -int ll_md_close(struct obd_export *md_exp, struct inode *inode,
> -               struct file *file);
>  int ll_md_real_close(struct inode *inode, fmode_t fmode);
>  void ll_ioepoch_close(struct inode *inode, struct md_op_data *op_data,
>                       struct obd_client_handle **och, unsigned long flags);
> @@ -799,15 +756,10 @@ void ll_done_writing_attr(struct inode *inode, struct md_op_data *op_data);
>  int ll_som_update(struct inode *inode, struct md_op_data *op_data);
>  int ll_inode_getattr(struct inode *inode, struct obdo *obdo,
>                      __u64 ioepoch, int sync);
> -int ll_md_setattr(struct dentry *dentry, struct md_op_data *op_data,
> -                 struct md_open_data **mod);
>  void ll_pack_inode2opdata(struct inode *inode, struct md_op_data *op_data,
>                           struct lustre_handle *fh);
> -int ll_getattr_it(struct vfsmount *mnt, struct dentry *de,
> -              struct lookup_intent *it, struct kstat *stat);
>  int ll_getattr(struct vfsmount *mnt, struct dentry *de, struct kstat *stat);
> -struct ll_file_data *ll_file_data_get(void);
> -struct posix_acl * ll_get_acl(struct inode *inode, int type);
> +struct posix_acl *ll_get_acl(struct inode *inode, int type);
>
>  int ll_inode_permission(struct inode *inode, int mask);
>
> @@ -822,44 +774,30 @@ int ll_dir_setstripe(struct inode *inode, struct lov_user_md *lump,
>  int ll_dir_getstripe(struct inode *inode, struct lov_mds_md **lmmp,
>                      int *lmm_size, struct ptlrpc_request **request);
>  int ll_fsync(struct file *file, loff_t start, loff_t end, int data);
> -int ll_do_fiemap(struct inode *inode, struct ll_user_fiemap *fiemap,
> -             int num_bytes);
>  int ll_merge_lvb(const struct lu_env *env, struct inode *inode);
> -int ll_get_grouplock(struct inode *inode, struct file *file, unsigned long arg);
> -int ll_put_grouplock(struct inode *inode, struct file *file, unsigned long arg);
>  int ll_fid2path(struct inode *inode, void *arg);
>  int ll_data_version(struct inode *inode, __u64 *data_version, int extent_lock);
>  int ll_hsm_release(struct inode *inode);
>
> -struct obd_client_handle *ll_lease_open(struct inode *inode, struct file *file,
> -                                       fmode_t mode, __u64 flags);
> -int ll_lease_close(struct obd_client_handle *och, struct inode *inode,
> -                  bool *lease_broken);
> -
>  /* llite/dcache.c */
>
>  int ll_d_init(struct dentry *de);
> -extern struct dentry_operations ll_d_ops;
> +extern const struct dentry_operations ll_d_ops;
>  void ll_intent_drop_lock(struct lookup_intent *);
>  void ll_intent_release(struct lookup_intent *);
>  void ll_invalidate_aliases(struct inode *);
> -void ll_frob_intent(struct lookup_intent **itp, struct lookup_intent *deft);
>  void ll_lookup_finish_locks(struct lookup_intent *it, struct dentry *dentry);
> -int ll_dcompare(const struct dentry *parent, const struct dentry *dentry,
> -               unsigned int len, const char *str, const struct qstr *d_name);
>  int ll_revalidate_it_finish(struct ptlrpc_request *request,
>                             struct lookup_intent *it, struct dentry *de);
>
>  /* llite/llite_lib.c */
>  extern struct super_operations lustre_super_operations;
>
> -char *ll_read_opt(const char *opt, char *data);
>  void ll_lli_init(struct ll_inode_info *lli);
>  int ll_fill_super(struct super_block *sb, struct vfsmount *mnt);
>  void ll_put_super(struct super_block *sb);
>  void ll_kill_super(struct super_block *sb);
>  struct inode *ll_inode_from_resource_lock(struct ldlm_lock *lock);
> -struct inode *ll_inode_from_lock(struct ldlm_lock *lock);
>  void ll_clear_inode(struct inode *inode);
>  int ll_setattr_raw(struct dentry *dentry, struct iattr *attr, bool hsm_import);
>  int ll_setattr(struct dentry *de, struct iattr *attr);
> @@ -879,7 +817,6 @@ void ll_dirty_page_discard_warn(struct page *page, int ioret);
>  int ll_prep_inode(struct inode **inode, struct ptlrpc_request *req,
>                   struct super_block *, struct lookup_intent *);
>  void lustre_dump_dentry(struct dentry *, int recur);
> -void lustre_dump_inode(struct inode *);
>  int ll_obd_statfs(struct inode *inode, void *arg);
>  int ll_get_max_mdsize(struct ll_sb_info *sbi, int *max_mdsize);
>  int ll_get_default_mdsize(struct ll_sb_info *sbi, int *default_mdsize);
> @@ -901,15 +838,6 @@ void get_uuid2fsid(const char *name, int len, __kernel_fsid_t *fsid);
>  struct inode *search_inode_for_lustre(struct super_block *sb,
>                                       const struct lu_fid *fid);
>
> -/* llite/special.c */
> -extern struct inode_operations ll_special_inode_operations;
> -extern struct file_operations ll_special_chr_inode_fops;
> -extern struct file_operations ll_special_chr_file_fops;
> -extern struct file_operations ll_special_blk_inode_fops;
> -extern struct file_operations ll_special_fifo_inode_fops;
> -extern struct file_operations ll_special_fifo_file_fops;
> -extern struct file_operations ll_special_sock_inode_fops;
> -
>  /* llite/symlink.c */
>  extern struct inode_operations ll_fast_symlink_inode_operations;
>
> @@ -977,11 +905,6 @@ struct vvp_io {
>          * Set when cui_bead has been initialized.
>          */
>         int               cui_ra_window_set;
> -       /**
> -        * Partially truncated page, that vvp_io_trunc_start() keeps locked
> -        * across truncate.
> -        */
> -       struct cl_page      *cui_partpage;
>  };
>
>  /**
> @@ -1010,12 +933,9 @@ struct ll_cl_context {
>         struct cl_page *lcc_page;
>         struct lu_env  *lcc_env;
>         int          lcc_refcheck;
> -       int          lcc_created;
>  };
>
>  struct vvp_thread_info {
> -       struct ost_lvb       vti_lvb;
> -       struct cl_2queue     vti_queue;
>         struct iovec     vti_local_iov;
>         struct vvp_io_args   vti_args;
>         struct ra_io_arg     vti_ria;
> @@ -1062,25 +982,17 @@ static inline struct vvp_io *vvp_env_io(const struct lu_env *env)
>         return &vvp_env_session(env)->vs_ios;
>  }
>
> +int vvp_global_init(void);
> +void vvp_global_fini(void);
> +
>  void ll_queue_done_writing(struct inode *inode, unsigned long flags);
>  void ll_close_thread_shutdown(struct ll_close_queue *lcq);
>  int ll_close_thread_start(struct ll_close_queue **lcq_ret);
>
>  /* llite/llite_mmap.c */
> -typedef struct rb_root  rb_root_t;
> -typedef struct rb_node  rb_node_t;
> -
> -struct ll_lock_tree_node;
> -struct ll_lock_tree {
> -       rb_root_t                      lt_root;
> -       struct list_head                      lt_locked_list;
> -       struct ll_file_data         *lt_fd;
> -};
>
>  int ll_teardown_mmaps(struct address_space *mapping, __u64 first, __u64 last);
>  int ll_file_mmap(struct file * file, struct vm_area_struct * vma);
> -struct ll_lock_tree_node * ll_node_from_inode(struct inode *inode, __u64 start,
> -                                             __u64 end, ldlm_mode_t mode);
>  void policy_from_vma(ldlm_policy_data_t *policy,
>                 struct vm_area_struct *vma, unsigned long addr, size_t count);
>  struct vm_area_struct *our_vma(struct mm_struct *mm, unsigned long addr,
> @@ -1164,7 +1076,6 @@ int ll_removexattr(struct dentry *dentry, const char *name);
>  extern struct kmem_cache *ll_remote_perm_cachep;
>  extern struct kmem_cache *ll_rmtperm_hash_cachep;
>
> -struct hlist_head *alloc_rmtperm_hash(void);
>  void free_rmtperm_hash(struct hlist_head *hash);
>  int ll_update_remote_perm(struct inode *inode, struct mdt_remote_perm *perm);
>  int lustre_check_remote_perm(struct inode *inode, int mask);
> @@ -1177,7 +1088,6 @@ void ll_capa_thread_stop(void);
>  void ll_capa_timer_callback(unsigned long unused);
>
>  struct obd_capa *ll_add_capa(struct inode *inode, struct obd_capa *ocapa);
> -int ll_update_capa(struct obd_capa *ocapa, struct lustre_capa *capa);
>
>  void ll_capa_open(struct inode *inode);
>  void ll_capa_close(struct inode *inode);
> @@ -1197,14 +1107,12 @@ extern struct lu_device_type vvp_device_type;
>   */
>  int cl_sb_init(struct super_block *sb);
>  int cl_sb_fini(struct super_block *sb);
> -enum cl_lock_mode  vvp_mode_from_vma(struct vm_area_struct *vma);
>  void ll_io_init(struct cl_io *io, const struct file *file, int write);
>
>  void ras_update(struct ll_sb_info *sbi, struct inode *inode,
>                 struct ll_readahead_state *ras, unsigned long index,
>                 unsigned hit);
>  void ll_ra_count_put(struct ll_sb_info *sbi, unsigned long len);
> -int ll_is_file_contended(struct file *file);
>  void ll_ra_stats_inc(struct address_space *mapping, enum ra_stat which);
>
>  /* llite/llite_rmtacl.c */
> @@ -1277,7 +1185,6 @@ struct ll_statahead_info {
>         unsigned int        sai_skip_hidden;/* skipped hidden dentry count */
>         unsigned int        sai_ls_all:1,   /* "ls -al", do stat-ahead for
>                                                  * hidden entries */
> -                               sai_in_readpage:1,/* statahead is in readdir()*/
>                                 sai_agl_valid:1;/* AGL is valid for the dir */
>         wait_queue_head_t            sai_waitq;      /* stat-ahead wait queue */
>         struct ptlrpc_thread    sai_thread;     /* stat-ahead thread */
> @@ -1402,9 +1309,6 @@ typedef enum llioc_iter (*llioc_callback_t)(struct inode *inode,
>                 struct file *file, unsigned int cmd, unsigned long arg,
>                 void *magic, int *rcp);
>
> -enum llioc_iter ll_iocontrol_call(struct inode *inode, struct file *file,
> -               unsigned int cmd, unsigned long arg, int *rcp);
> -
>  /* export functions */
>  /* Register ioctl block dynamatically for a regular file.
>   *
> diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
> index dbb1413..7372986 100644
> --- a/drivers/staging/lustre/lustre/llite/llite_lib.c
> +++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
> @@ -58,14 +58,8 @@
>  struct kmem_cache *ll_file_data_slab;
>  struct proc_dir_entry *proc_lustre_fs_root;
>
> -LIST_HEAD(ll_super_blocks);
> -DEFINE_SPINLOCK(ll_sb_lock);
> -
> -#ifndef MS_HAS_NEW_AOPS
> -extern struct address_space_operations ll_aops;
> -#else
> -extern struct address_space_operations_ext ll_aops;
> -#endif
> +static LIST_HEAD(ll_super_blocks);
> +static DEFINE_SPINLOCK(ll_sb_lock);
>
>  #ifndef log2
>  #define log2(n) ffz(~(n))
> @@ -143,7 +137,7 @@ static struct ll_sb_info *ll_init_sbi(void)
>         return sbi;
>  }
>
> -void ll_free_sbi(struct super_block *sb)
> +static void ll_free_sbi(struct super_block *sb)
>  {
>         struct ll_sb_info *sbi = ll_s2sbi(sb);
>
> @@ -673,7 +667,7 @@ int ll_get_default_cookiesize(struct ll_sb_info *sbi, int *lmmsize)
>         return rc;
>  }
>
> -void ll_dump_inode(struct inode *inode)
> +static void ll_dump_inode(struct inode *inode)
>  {
>         struct ll_d_hlist_node *tmp;
>         int dentry_count = 0;
> @@ -716,7 +710,7 @@ void lustre_dump_dentry(struct dentry *dentry, int recur)
>         }
>  }
>
> -void client_common_put_super(struct super_block *sb)
> +static void client_common_put_super(struct super_block *sb)
>  {
>         struct ll_sb_info *sbi = ll_s2sbi(sb);
>
> @@ -765,30 +759,6 @@ void ll_kill_super(struct super_block *sb)
>         }
>  }
>
> -char *ll_read_opt(const char *opt, char *data)
> -{
> -       char *value;
> -       char *retval;
> -
> -       CDEBUG(D_SUPER, "option: %s, data %s\n", opt, data);
> -       if (strncmp(opt, data, strlen(opt)))
> -               return NULL;
> -       value = strchr(data, '=');
> -       if (value == NULL)
> -               return NULL;
> -
> -       value++;
> -       OBD_ALLOC(retval, strlen(value) + 1);
> -       if (!retval) {
> -               CERROR("out of memory!\n");
> -               return NULL;
> -       }
> -
> -       memcpy(retval, value, strlen(value)+1);
> -       CDEBUG(D_SUPER, "Assigned option: %s, value %s\n", opt, retval);
> -       return retval;
> -}
> -
>  static inline int ll_set_opt(const char *opt, char *data, int fl)
>  {
>         if (strncmp(opt, data, strlen(opt)) != 0)
> @@ -978,7 +948,6 @@ void ll_lli_init(struct ll_inode_info *lli)
>                 mutex_init(&lli->lli_readdir_mutex);
>                 lli->lli_opendir_key = NULL;
>                 lli->lli_sai = NULL;
> -               lli->lli_def_acl = NULL;
>                 spin_lock_init(&lli->lli_sa_lock);
>                 lli->lli_opendir_pid = 0;
>         } else {
> @@ -991,7 +960,6 @@ void ll_lli_init(struct ll_inode_info *lli)
>                 INIT_LIST_HEAD(&lli->lli_agl_list);
>                 lli->lli_agl_index = 0;
>                 lli->lli_async_rc = 0;
> -               lli->lli_volatile = false;
>         }
>         mutex_init(&lli->lli_layout_mutex);
>  }
> @@ -1190,28 +1158,6 @@ struct inode *ll_inode_from_resource_lock(struct ldlm_lock *lock)
>         return inode;
>  }
>
> -struct inode *ll_inode_from_lock(struct ldlm_lock *lock)
> -{
> -       struct inode *inode = NULL;
> -       /* NOTE: we depend on atomic igrab() -bzzz */
> -       lock_res_and_lock(lock);
> -       if (lock->l_ast_data) {
> -               struct ll_inode_info *lli = ll_i2info(lock->l_ast_data);
> -               if (lli->lli_inode_magic == LLI_INODE_MAGIC) {
> -                       inode = igrab(lock->l_ast_data);
> -               } else {
> -                       inode = lock->l_ast_data;
> -                       LDLM_DEBUG_LIMIT(inode->i_state & I_FREEING ?  D_INFO :
> -                                        D_WARNING, lock, "l_ast_data %p is "
> -                                        "bogus: magic %08x", lock->l_ast_data,
> -                                        lli->lli_inode_magic);
> -                       inode = NULL;
> -               }
> -       }
> -       unlock_res_and_lock(lock);
> -       return inode;
> -}
> -
>  void ll_clear_inode(struct inode *inode)
>  {
>         struct ll_inode_info *lli = ll_i2info(inode);
> diff --git a/drivers/staging/lustre/lustre/llite/llite_mmap.c b/drivers/staging/lustre/lustre/llite/llite_mmap.c
> index 90b2c0d..426c739 100644
> --- a/drivers/staging/lustre/lustre/llite/llite_mmap.c
> +++ b/drivers/staging/lustre/lustre/llite/llite_mmap.c
> @@ -51,10 +51,7 @@
>  #include "llite_internal.h"
>  #include <linux/lustre_compat25.h>
>
> -struct page *ll_nopage(struct vm_area_struct *vma, unsigned long address,
> -                      int *type);
> -
> -static struct vm_operations_struct ll_file_vm_ops;
> +static const struct vm_operations_struct ll_file_vm_ops;
>
>  void policy_from_vma(ldlm_policy_data_t *policy,
>                             struct vm_area_struct *vma, unsigned long addr,
> @@ -97,10 +94,10 @@ struct vm_area_struct *our_vma(struct mm_struct *mm, unsigned long addr,
>   * \retval EINVAL if env can't allocated
>   * \return other error codes from cl_io_init.
>   */
> -struct cl_io *ll_fault_io_init(struct vm_area_struct *vma,
> -                              struct lu_env **env_ret,
> -                              struct cl_env_nest *nest,
> -                              pgoff_t index, unsigned long *ra_flags)
> +static struct cl_io *
> +ll_fault_io_init(struct vm_area_struct *vma, struct lu_env **env_ret,
> +                struct cl_env_nest *nest, pgoff_t index,
> +                unsigned long *ra_flags)
>  {
>         struct file            *file = vma->vm_file;
>         struct inode           *inode = file->f_dentry->d_inode;
> @@ -446,14 +443,6 @@ static void ll_vm_close(struct vm_area_struct *vma)
>         LASSERT(atomic_read(&vob->cob_mmap_cnt) >= 0);
>  }
>
> -
> -/* return the user space pointer that maps to a file offset via a vma */
> -static inline unsigned long file_to_user(struct vm_area_struct *vma, __u64 byte)
> -{
> -       return vma->vm_start + (byte - ((__u64)vma->vm_pgoff << PAGE_CACHE_SHIFT));
> -
> -}
> -
>  /* XXX put nice comment here.  talk about __free_pte -> dirty pages and
>   * nopage's reference passing to the pte */
>  int ll_teardown_mmaps(struct address_space *mapping, __u64 first, __u64 last)
> @@ -470,7 +459,7 @@ int ll_teardown_mmaps(struct address_space *mapping, __u64 first, __u64 last)
>         return rc;
>  }
>
> -static struct vm_operations_struct ll_file_vm_ops = {
> +static const struct vm_operations_struct ll_file_vm_ops = {
>         .fault                  = ll_fault,
>         .page_mkwrite           = ll_page_mkwrite,
>         .open                   = ll_vm_open,
> diff --git a/drivers/staging/lustre/lustre/llite/lloop.c b/drivers/staging/lustre/lustre/llite/lloop.c
> index 437adaf..b9694b8 100644
> --- a/drivers/staging/lustre/lustre/llite/lloop.c
> +++ b/drivers/staging/lustre/lustre/llite/lloop.c
> @@ -122,9 +122,6 @@ struct lloop_device {
>         loff_t         lo_offset;
>         loff_t         lo_sizelimit;
>         int               lo_flags;
> -       int             (*ioctl)(struct lloop_device *, int cmd,
> -                                   unsigned long arg);
> -
>         struct file      *lo_backing_file;
>         struct block_device *lo_device;
>         unsigned             lo_blocksize;
> @@ -509,7 +506,6 @@ static int loop_set_fd(struct lloop_device *lo, struct file *unused,
>         lo->lo_device = bdev;
>         lo->lo_flags = lo_flags;
>         lo->lo_backing_file = file;
> -       lo->ioctl = NULL;
>         lo->lo_sizelimit = 0;
>         lo->old_gfp_mask = mapping_gfp_mask(mapping);
>         mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
> @@ -568,7 +564,6 @@ static int loop_clr_fd(struct lloop_device *lo, struct block_device *bdev,
>
>         down(&lo->lo_sem);
>         lo->lo_backing_file = NULL;
> -       lo->ioctl = NULL;
>         lo->lo_device = NULL;
>         lo->lo_offset = 0;
>         lo->lo_sizelimit = 0;
> diff --git a/drivers/staging/lustre/lustre/llite/lproc_llite.c b/drivers/staging/lustre/lustre/llite/lproc_llite.c
> index f291254..6d70c65 100644
> --- a/drivers/staging/lustre/lustre/llite/lproc_llite.c
> +++ b/drivers/staging/lustre/lustre/llite/lproc_llite.c
> @@ -41,9 +41,9 @@
>  #include <obd_support.h>
>
>  #include "llite_internal.h"
> +#include "vvp_internal.h"
>
>  /* /proc/lustre/llite mount point registration */
> -extern struct file_operations vvp_dump_pgcache_file_ops;
>  static struct file_operations ll_rw_extents_stats_fops;
>  static struct file_operations ll_rw_extents_stats_pp_fops;
>  static struct file_operations ll_rw_offset_stats_fops;
> @@ -837,7 +837,7 @@ static struct lprocfs_vars lprocfs_llite_obd_vars[] = {
>
>  #define MAX_STRING_SIZE 128
>
> -struct llite_file_opcode {
> +static const struct llite_file_opcode {
>         __u32       opcode;
>         __u32       type;
>         const char *opname;
> diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
> index 25a6ea58..dfa1e745 100644
> --- a/drivers/staging/lustre/lustre/llite/namei.c
> +++ b/drivers/staging/lustre/lustre/llite/namei.c
> @@ -75,14 +75,6 @@ static int ll_d_mountpoint(struct dentry *dparent, struct dentry *dchild,
>         return mounted;
>  }
>
> -int ll_unlock(__u32 mode, struct lustre_handle *lockh)
> -{
> -       ldlm_lock_decref(lockh, mode);
> -
> -       return 0;
> -}
> -
> -
>  /* called from iget5_locked->find_inode() under inode_hash_lock spinlock */
>  static int ll_test_inode(struct inode *inode, void *opaque)
>  {
> @@ -433,12 +425,10 @@ struct dentry *ll_splice_alias(struct inode *inode, struct dentry *de)
>         return de;
>  }
>
> -int ll_lookup_it_finish(struct ptlrpc_request *request,
> -                       struct lookup_intent *it, void *data)
> +static int ll_lookup_it_finish(struct ptlrpc_request *request,
> +                              struct lookup_intent *it,
> +                              struct inode *parent, struct dentry **de)
>  {
> -       struct it_cb_data *icbd = data;
> -       struct dentry **de = icbd->icbd_childp;
> -       struct inode *parent = icbd->icbd_parent;
>         struct inode *inode = NULL;
>         __u64 bits = 0;
>         int rc;
> @@ -513,7 +503,6 @@ static struct dentry *ll_lookup_it(struct inode *parent, struct dentry *dentry,
>         struct dentry *save = dentry, *retval;
>         struct ptlrpc_request *req = NULL;
>         struct md_op_data *op_data;
> -       struct it_cb_data icbd;
>         __u32 opc;
>         int rc;
>
> @@ -527,7 +516,8 @@ static struct dentry *ll_lookup_it(struct inode *parent, struct dentry *dentry,
>         if (d_mountpoint(dentry))
>                 CERROR("Tell Peter, lookup on mtpt, it %s\n", LL_IT2STR(it));
>
> -       ll_frob_intent(&it, &lookup_it);
> +       if (it == NULL || it->it_op == IT_GETXATTR)
> +               it = &lookup_it;
>
>         if (it->it_op == IT_GETATTR) {
>                 rc = ll_statahead_enter(parent, &dentry, 0);
> @@ -538,9 +528,6 @@ static struct dentry *ll_lookup_it(struct inode *parent, struct dentry *dentry,
>                 }
>         }
>
> -       icbd.icbd_childp = &dentry;
> -       icbd.icbd_parent = parent;
> -
>         if (it->it_op & IT_CREAT)
>                 opc = LUSTRE_OPC_CREATE;
>         else
> @@ -562,7 +549,7 @@ static struct dentry *ll_lookup_it(struct inode *parent, struct dentry *dentry,
>         if (rc < 0)
>                 GOTO(out, retval = ERR_PTR(rc));
>
> -       rc = ll_lookup_it_finish(req, it, &icbd);
> +       rc = ll_lookup_it_finish(req, it, parent, &dentry);
>         if (rc != 0) {
>                 ll_intent_release(it);
>                 GOTO(out, retval = ERR_PTR(rc));
> @@ -697,10 +684,7 @@ out_release:
>
>
>  /* We depend on "mode" being set with the proper file type/umask by now */
> -static struct inode *ll_create_node(struct inode *dir, const char *name,
> -                                   int namelen, const void *data, int datalen,
> -                                   int mode, __u64 extra,
> -                                   struct lookup_intent *it)
> +static struct inode *ll_create_node(struct inode *dir, struct lookup_intent *it)
>  {
>         struct inode *inode = NULL;
>         struct ptlrpc_request *request = NULL;
> @@ -757,14 +741,10 @@ static int ll_create_it(struct inode *dir, struct dentry *dentry, int mode,
>         if (rc)
>                 return rc;
>
> -       inode = ll_create_node(dir, dentry->d_name.name, dentry->d_name.len,
> -                              NULL, 0, mode, 0, it);
> +       inode = ll_create_node(dir, it);
>         if (IS_ERR(inode))
>                 return PTR_ERR(inode);
>
> -       if (filename_is_volatile(dentry->d_name.name, dentry->d_name.len, NULL))
> -               ll_i2info(inode)->lli_volatile = true;
> -
>         d_instantiate(dentry, inode);
>         return 0;
>  }
> @@ -1238,7 +1218,7 @@ static int ll_rename(struct inode *old_dir, struct dentry *old_dentry,
>         return err;
>  }
>
> -struct inode_operations ll_dir_inode_operations = {
> +const struct inode_operations ll_dir_inode_operations = {
>         .mknod        = ll_mknod,
>         .atomic_open        = ll_atomic_open,
>         .lookup      = ll_lookup_nd,
> @@ -1260,7 +1240,7 @@ struct inode_operations ll_dir_inode_operations = {
>         .get_acl            = ll_get_acl,
>  };
>
> -struct inode_operations ll_special_inode_operations = {
> +const struct inode_operations ll_special_inode_operations = {
>         .setattr        = ll_setattr,
>         .getattr        = ll_getattr,
>         .permission     = ll_inode_permission,
> diff --git a/drivers/staging/lustre/lustre/llite/remote_perm.c b/drivers/staging/lustre/lustre/llite/remote_perm.c
> index dedd56a..a8b1117 100644
> --- a/drivers/staging/lustre/lustre/llite/remote_perm.c
> +++ b/drivers/staging/lustre/lustre/llite/remote_perm.c
> @@ -77,7 +77,7 @@ static inline void free_ll_remote_perm(struct ll_remote_perm *lrp)
>         OBD_SLAB_FREE(lrp, ll_remote_perm_cachep, sizeof(*lrp));
>  }
>
> -struct hlist_head *alloc_rmtperm_hash(void)
> +static struct hlist_head *alloc_rmtperm_hash(void)
>  {
>         struct hlist_head *hash;
>         int i;
> diff --git a/drivers/staging/lustre/lustre/llite/rw.c b/drivers/staging/lustre/lustre/llite/rw.c
> index 416f7a0..f0122c5 100644
> --- a/drivers/staging/lustre/lustre/llite/rw.c
> +++ b/drivers/staging/lustre/lustre/llite/rw.c
> @@ -77,12 +77,6 @@ static void ll_cl_fini(struct ll_cl_context *lcc)
>                 cl_page_put(env, page);
>         }
>
> -       if (io && lcc->lcc_created) {
> -               cl_io_end(env, io);
> -               cl_io_unlock(env, io);
> -               cl_io_iter_fini(env, io);
> -               cl_io_fini(env, io);
> -       }
>         cl_env_put(env, &lcc->lcc_refcheck);
>  }
>
> @@ -167,7 +161,6 @@ static struct ll_cl_context *ll_cl_init(struct file *file,
>                         }
>                 } else
>                         result = io->ci_result;
> -               lcc->lcc_created = 1;
>         }
>
>         lcc->lcc_io = io;
> diff --git a/drivers/staging/lustre/lustre/llite/rw26.c b/drivers/staging/lustre/lustre/llite/rw26.c
> index 7e3e096..b401d36 100644
> --- a/drivers/staging/lustre/lustre/llite/rw26.c
> +++ b/drivers/staging/lustre/lustre/llite/rw26.c
> @@ -529,9 +529,9 @@ static int ll_write_end(struct file *file, struct address_space *mapping,
>  }
>
>  #ifdef CONFIG_MIGRATION
> -int ll_migratepage(struct address_space *mapping,
> -               struct page *newpage, struct page *page
> -               , enum migrate_mode mode
> +static int ll_migratepage(struct address_space *mapping,
> +                        struct page *newpage, struct page *page,
> +                        enum migrate_mode mode
>                 )
>  {
>         /* Always fail page migration until we have a proper implementation */
> @@ -540,9 +540,8 @@ int ll_migratepage(struct address_space *mapping,
>  #endif
>
>  #ifndef MS_HAS_NEW_AOPS
> -struct address_space_operations ll_aops = {
> -       .readpage       = ll_readpage,
> -//     .readpages      = ll_readpages,
> +const struct address_space_operations ll_aops = {
> +       .readpage       = ll_readpage,
>         .direct_IO      = ll_direct_IO_26,
>         .writepage      = ll_writepage,
>         .writepages     = ll_writepages,
> @@ -554,10 +553,9 @@ struct address_space_operations ll_aops = {
>  #ifdef CONFIG_MIGRATION
>         .migratepage    = ll_migratepage,
>  #endif
> -       .bmap      = NULL
>  };
>  #else
> -struct address_space_operations_ext ll_aops = {
> +const struct address_space_operations_ext ll_aops = {
>         .orig_aops.readpage       = ll_readpage,
>  //     .orig_aops.readpages      = ll_readpages,
>         .orig_aops.direct_IO      = ll_direct_IO_26,
> @@ -571,7 +569,6 @@ struct address_space_operations_ext ll_aops = {
>  #ifdef CONFIG_MIGRATION
>         .orig_aops.migratepage    = ll_migratepage,
>  #endif
> -       .orig_aops.bmap    = NULL,
>         .write_begin    = ll_write_begin,
>         .write_end      = ll_write_end
>  };
> diff --git a/drivers/staging/lustre/lustre/llite/statahead.c b/drivers/staging/lustre/lustre/llite/statahead.c
> index 51c5327..1b47774 100644
> --- a/drivers/staging/lustre/lustre/llite/statahead.c
> +++ b/drivers/staging/lustre/lustre/llite/statahead.c
> @@ -1230,9 +1230,7 @@ do_it:
>                          */
>                         ll_release_page(page, le32_to_cpu(dp->ldp_flags) &
>                                               LDF_COLLIDE);
> -                       sai->sai_in_readpage = 1;
>                         page = ll_get_dir_page(dir, pos, &chain);
> -                       sai->sai_in_readpage = 0;
>                 } else {
>                         LASSERT(le32_to_cpu(dp->ldp_flags) & LDF_COLLIDE);
>                         ll_release_page(page, 1);
> @@ -1563,12 +1561,6 @@ int do_statahead_enter(struct inode *dir, struct dentry **dentryp,
>                         return entry ? 1 : -EAGAIN;
>                 }
>
> -               /* if statahead is busy in readdir, help it do post-work */
> -               while (!ll_sa_entry_stated(entry) &&
> -                      sai->sai_in_readpage &&
> -                      !sa_received_empty(sai))
> -                       ll_post_statahead(sai);
> -
>                 if (!ll_sa_entry_stated(entry)) {
>                         sai->sai_index_wait = entry->se_index;
>                         lwi = LWI_TIMEOUT_INTR(cfs_time_seconds(30), NULL,
> diff --git a/drivers/staging/lustre/lustre/llite/super25.c b/drivers/staging/lustre/lustre/llite/super25.c
> index 58bb8f2..951fdb1 100644
> --- a/drivers/staging/lustre/lustre/llite/super25.c
> +++ b/drivers/staging/lustre/lustre/llite/super25.c
> @@ -72,7 +72,7 @@ static void ll_destroy_inode(struct inode *inode)
>         call_rcu(&inode->i_rcu, ll_inode_destroy_callback);
>  }
>
> -int ll_init_inodecache(void)
> +static int ll_init_inodecache(void)
>  {
>         ll_inode_cachep = kmem_cache_create("lustre_inode_cache",
>                                                sizeof(struct ll_inode_info),
> @@ -82,7 +82,7 @@ int ll_init_inodecache(void)
>         return 0;
>  }
>
> -void ll_destroy_inodecache(void)
> +static void ll_destroy_inodecache(void)
>  {
>         kmem_cache_destroy(ll_inode_cachep);
>  }
> @@ -103,9 +103,6 @@ MODULE_ALIAS_FS("lustre");
>
>  void lustre_register_client_process_config(int (*cpc)(struct lustre_cfg *lcfg));
>
> -int vvp_global_init(void);
> -void vvp_global_fini(void);
> -
>  static int __init init_lustre_lite(void)
>  {
>         int i, rc, seed[2];
> diff --git a/drivers/staging/lustre/lustre/llite/vvp_dev.c b/drivers/staging/lustre/lustre/llite/vvp_dev.c
> index a9778b8..0f68c16 100644
> --- a/drivers/staging/lustre/lustre/llite/vvp_dev.c
> +++ b/drivers/staging/lustre/lustre/llite/vvp_dev.c
> @@ -43,7 +43,7 @@
>
>  #include <obd.h>
>  #include <lustre_lite.h>
> -
> +#include "llite_internal.h"
>  #include "vvp_internal.h"
>
>  /*****************************************************************************
> @@ -57,7 +57,7 @@
>   * "llite_" (var. "ll_") prefix.
>   */
>
> -struct kmem_cache *vvp_thread_kmem;
> +static struct kmem_cache *vvp_thread_kmem;
>  static struct kmem_cache *vvp_session_kmem;
>  static struct lu_kmem_descr vvp_caches[] = {
>         {
> @@ -536,7 +536,7 @@ static int vvp_dump_pgcache_seq_open(struct inode *inode, struct file *filp)
>         return result;
>  }
>
> -struct file_operations vvp_dump_pgcache_file_ops = {
> +const struct file_operations vvp_dump_pgcache_file_ops = {
>         .owner   = THIS_MODULE,
>         .open    = vvp_dump_pgcache_seq_open,
>         .read    = seq_read,
> diff --git a/drivers/staging/lustre/lustre/llite/vvp_internal.h b/drivers/staging/lustre/lustre/llite/vvp_internal.h
> index c82bf17..3c9a03d 100644
> --- a/drivers/staging/lustre/lustre/llite/vvp_internal.h
> +++ b/drivers/staging/lustre/lustre/llite/vvp_internal.h
> @@ -57,6 +57,6 @@ struct lu_object *vvp_object_alloc(const struct lu_env *env,
>
>  struct ccc_object *cl_inode2ccc(struct inode *inode);
>
> -extern struct kmem_cache *vvp_thread_kmem;
> +extern const struct file_operations vvp_dump_pgcache_file_ops;
>
>  #endif /* VVP_INTERNAL_H */
> diff --git a/drivers/staging/lustre/lustre/llite/vvp_io.c b/drivers/staging/lustre/lustre/llite/vvp_io.c
> index 5156ab8..7dd2b47 100644
> --- a/drivers/staging/lustre/lustre/llite/vvp_io.c
> +++ b/drivers/staging/lustre/lustre/llite/vvp_io.c
> @@ -190,7 +190,7 @@ static void vvp_io_fault_fini(const struct lu_env *env,
>         vvp_io_fini(env, ios);
>  }
>
> -enum cl_lock_mode vvp_mode_from_vma(struct vm_area_struct *vma)
> +static enum cl_lock_mode vvp_mode_from_vma(struct vm_area_struct *vma)
>  {
>         /*
>          * we only want to hold PW locks if the mmap() can generate
> diff --git a/drivers/staging/lustre/lustre/llite/vvp_object.c b/drivers/staging/lustre/lustre/llite/vvp_object.c
> index 554a5dd..65b6db1 100644
> --- a/drivers/staging/lustre/lustre/llite/vvp_object.c
> +++ b/drivers/staging/lustre/lustre/llite/vvp_object.c
> @@ -120,8 +120,8 @@ static int vvp_attr_set(const struct lu_env *env, struct cl_object *obj,
>         return 0;
>  }
>
> -int vvp_conf_set(const struct lu_env *env, struct cl_object *obj,
> -               const struct cl_object_conf *conf)
> +static int vvp_conf_set(const struct lu_env *env, struct cl_object *obj,
> +                       const struct cl_object_conf *conf)
>  {
>         struct ll_inode_info *lli = ll_i2info(conf->coc_inode);
>
> diff --git a/drivers/staging/lustre/lustre/llite/xattr_cache.c b/drivers/staging/lustre/lustre/llite/xattr_cache.c
> index dfd19f8..4dd83fc 100644
> --- a/drivers/staging/lustre/lustre/llite/xattr_cache.c
> +++ b/drivers/staging/lustre/lustre/llite/xattr_cache.c
> @@ -232,7 +232,7 @@ static int ll_xattr_cache_list(struct list_head *cache,
>   * \retval 0 @cache is not initialized
>   * \retval 1 @cache is initialized
>   */
> -int ll_xattr_cache_valid(struct ll_inode_info *lli)
> +static int ll_xattr_cache_valid(struct ll_inode_info *lli)
>  {
>         return !!(lli->lli_flags & LLIF_XATTR_CACHE);
>  }
> --
> 1.8.5.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
