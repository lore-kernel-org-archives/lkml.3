Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbbAFHFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 02:05:22 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:61301 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbbAFHFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 02:05:19 -0500
MIME-Version: 1.0
In-Reply-To: <1420328694-4609-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420328694-4609-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Tue, 6 Jan 2015 15:05:17 +0800
Message-ID: <CAAM7YAnVXtDoAQVnyRGNQPQ9okkmoDk3We3D9LvkuxBuwx_RDQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: acl: Remove unused function
From: "Yan, Zheng" <ukernel@gmail.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Sage Weil <sage@inktank.com>, ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2015 at 7:44 AM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Remove the function ceph_get_cached_acl() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  fs/ceph/acl.c |   14 --------------
>  1 file changed, 14 deletions(-)
>
> diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
> index 5bd853b..64fa248 100644
> --- a/fs/ceph/acl.c
> +++ b/fs/ceph/acl.c
> @@ -40,20 +40,6 @@ static inline void ceph_set_cached_acl(struct inode *inode,
>         spin_unlock(&ci->i_ceph_lock);
>  }
>
> -static inline struct posix_acl *ceph_get_cached_acl(struct inode *inode,
> -                                                       int type)
> -{
> -       struct ceph_inode_info *ci = ceph_inode(inode);
> -       struct posix_acl *acl = ACL_NOT_CACHED;
> -
> -       spin_lock(&ci->i_ceph_lock);
> -       if (__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0))
> -               acl = get_cached_acl(inode, type);
> -       spin_unlock(&ci->i_ceph_lock);
> -
> -       return acl;
> -}
> -
>  struct posix_acl *ceph_get_acl(struct inode *inode, int type)
>  {
>         int size;
> --
> 1.7.10.4
>

added to testing branch.

Thanks


> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
