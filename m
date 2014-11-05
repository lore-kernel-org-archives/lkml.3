Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaKEUnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:43:09 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:62929 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaKEUnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:43:04 -0500
Date: Wed, 05 Nov 2014 12:43:01 -0800 (PST)
X-Google-Original-Date: Wed, 05 Nov 2014 15:43 -0500
From: Paul Moore <paul@paul-moore.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, eparis@redhat.com,
        linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] include/linux/audit.h: Move dummy audit_file() from !AUDIT area to !AUDITSYSCALL area
Message-ID: <283051037.h5QtGpv3rn@sifl>
User-Agent: KMail/4.14.2 (Linux/3.16.7-gentoo; KDE/4.14.2; x86_64; ; )
In-Reply-To: <5458EC40.5020807@gmail.com>
References: <5458EC40.5020807@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 04, 2014 11:09:52 PM Chen Gang wrote:
> audit_file() is related with AUDITSYSCALL, not related with AUDIT, so
> need move dummy one from !AUDIT area to !AUDITSYSCALL area. Or it will
> cause issue if CONFIG_AUDIT with !CONFIG_AUDITSYSCALL.
> 
> The related error (with allmodconfig under tile):
> 
>     CC      fs/open.o
>   fs/open.c: In function 'SYSC_fchmod':
>   fs/open.c:530:3: error: implicit declaration of function 'audit_file'
> [-Werror=implicit-function-declaration] audit_file(f.file);
>      ^
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  include/linux/audit.h | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

What version of the kernel source are you looking at?  I don't see the 
audit_file() function anywhere ...

> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 295ae1c..7b1d0d1 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -363,6 +363,8 @@ static inline void audit_inode(struct filename *name,
>  				const struct dentry *dentry,
>  				unsigned int parent)
>  { }
> +static inline void audit_file(struct file *file)
> +{ }
>  static inline void audit_inode_parent_hidden(struct filename *name,
>  				const struct dentry *dentry)
>  { }
> @@ -538,9 +540,6 @@ static inline void audit_log_task_info(struct
> audit_buffer *ab, struct task_struct *tsk)
>  { }
>  #define audit_enabled 0
> -static inline void audit_file(struct file *file)
> -{
> -}
>  #endif /* CONFIG_AUDIT */
>  static inline void audit_log_string(struct audit_buffer *ab, const char
> *buf) {

-- 
paul moore
www.paul-moore.com

