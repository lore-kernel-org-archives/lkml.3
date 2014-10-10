Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbaJJITh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 04:19:37 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:47704 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaJJITU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 04:19:20 -0400
MIME-Version: 1.0
In-Reply-To: <1412889395-19350-1-git-send-email-fabf@skynet.be>
References: <1412889395-19350-1-git-send-email-fabf@skynet.be>
Date: Fri, 10 Oct 2014 12:19:18 +0400
Message-ID: <CALFYKtABf_QuaqPrk5oJHRTfsXYMxX3nQP_kx9rauoYO0dTmdg@mail.gmail.com>
Subject: Re: [PATCH 1/1 linux-next] ceph: fix bool assignments
From: Ilya Dryomov <ilya.dryomov@inktank.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sage Weil <sage@inktank.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <zyan@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 1:16 AM, Fabian Frederick <fabf@skynet.be> wrote:
> Fix some coccinelle warnings:
> fs/ceph/caps.c:2400:6-10: WARNING: Assignment of bool to 0/1
> fs/ceph/caps.c:2401:6-15: WARNING: Assignment of bool to 0/1
> fs/ceph/caps.c:2402:6-17: WARNING: Assignment of bool to 0/1
> fs/ceph/caps.c:2403:6-22: WARNING: Assignment of bool to 0/1
> fs/ceph/caps.c:2404:6-22: WARNING: Assignment of bool to 0/1
> fs/ceph/caps.c:2405:6-19: WARNING: Assignment of bool to 0/1
> fs/ceph/caps.c:2440:4-20: WARNING: Assignment of bool to 0/1
> fs/ceph/caps.c:2469:3-16: WARNING: Assignment of bool to 0/1
> fs/ceph/caps.c:2490:2-18: WARNING: Assignment of bool to 0/1
> fs/ceph/caps.c:2519:3-7: WARNING: Assignment of bool to 0/1
> fs/ceph/caps.c:2549:3-12: WARNING: Assignment of bool to 0/1
> fs/ceph/caps.c:2575:2-6: WARNING: Assignment of bool to 0/1
> fs/ceph/caps.c:2589:3-7: WARNING: Assignment of bool to 0/1
>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/ceph/caps.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 6d1cd45..7131327 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2397,12 +2397,12 @@ static void handle_cap_grant(struct ceph_mds_client *mdsc,
>         u64 max_size = le64_to_cpu(grant->max_size);
>         struct timespec mtime, atime, ctime;
>         int check_caps = 0;
> -       bool wake = 0;
> -       bool writeback = 0;
> -       bool queue_trunc = 0;
> -       bool queue_invalidate = 0;
> -       bool queue_revalidate = 0;
> -       bool deleted_inode = 0;
> +       bool wake = false;
> +       bool writeback = false;
> +       bool queue_trunc = false;
> +       bool queue_invalidate = false;
> +       bool queue_revalidate = false;
> +       bool deleted_inode = false;
>
>         dout("handle_cap_grant inode %p cap %p mds%d seq %d %s\n",
>              inode, cap, mds, seq, ceph_cap_string(newcaps));
> @@ -2437,7 +2437,7 @@ static void handle_cap_grant(struct ceph_mds_client *mdsc,
>                         /* there were locked pages.. invalidate later
>                            in a separate thread. */
>                         if (ci->i_rdcache_revoking != ci->i_rdcache_gen) {
> -                               queue_invalidate = 1;
> +                               queue_invalidate = true;
>                                 ci->i_rdcache_revoking = ci->i_rdcache_gen;
>                         }
>                 }
> @@ -2466,7 +2466,7 @@ static void handle_cap_grant(struct ceph_mds_client *mdsc,
>                 set_nlink(inode, le32_to_cpu(grant->nlink));
>                 if (inode->i_nlink == 0 &&
>                     (newcaps & (CEPH_CAP_LINK_SHARED | CEPH_CAP_LINK_EXCL)))
> -                       deleted_inode = 1;
> +                       deleted_inode = true;
>         }
>
>         if ((issued & CEPH_CAP_XATTR_EXCL) == 0 && grant->xattr_len) {
> @@ -2487,7 +2487,7 @@ static void handle_cap_grant(struct ceph_mds_client *mdsc,
>         /* Do we need to revalidate our fscache cookie. Don't bother on the
>          * first cache cap as we already validate at cookie creation time. */
>         if ((issued & CEPH_CAP_FILE_CACHE) && ci->i_rdcache_gen > 1)
> -               queue_revalidate = 1;
> +               queue_revalidate = true;
>
>         if (newcaps & CEPH_CAP_ANY_RD) {
>                 /* ctime/mtime/atime? */
> @@ -2516,7 +2516,7 @@ static void handle_cap_grant(struct ceph_mds_client *mdsc,
>                                 ci->i_wanted_max_size = 0;  /* reset */
>                                 ci->i_requested_max_size = 0;
>                         }
> -                       wake = 1;
> +                       wake = true;
>                 }
>         }
>
> @@ -2546,7 +2546,7 @@ static void handle_cap_grant(struct ceph_mds_client *mdsc,
>                      ceph_cap_string(newcaps),
>                      ceph_cap_string(revoking));
>                 if (revoking & used & CEPH_CAP_FILE_BUFFER)
> -                       writeback = 1;  /* initiate writeback; will delay ack */
> +                       writeback = true;  /* initiate writeback; will delay ack */
>                 else if (revoking == CEPH_CAP_FILE_CACHE &&
>                          (newcaps & CEPH_CAP_FILE_LAZYIO) == 0 &&
>                          queue_invalidate)
> @@ -2572,7 +2572,7 @@ static void handle_cap_grant(struct ceph_mds_client *mdsc,
>                 cap->implemented |= newcaps; /* add bits only, to
>                                               * avoid stepping on a
>                                               * pending revocation */
> -               wake = 1;
> +               wake = true;
>         }
>         BUG_ON(cap->issued & ~cap->implemented);
>
> @@ -2586,7 +2586,7 @@ static void handle_cap_grant(struct ceph_mds_client *mdsc,
>                 kick_flushing_inode_caps(mdsc, session, inode);
>                 up_read(&mdsc->snap_rwsem);
>                 if (newcaps & ~issued)
> -                       wake = 1;
> +                       wake = true;
>         }
>
>         if (queue_trunc) {

(CC'ing Yan just in case)

Applied.

Thanks,

                Ilya
