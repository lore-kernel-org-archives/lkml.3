Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbaFRSut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 14:50:49 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:56061 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaFRSus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 14:50:48 -0400
From: Paul Moore <paul@paul-moore.com>
To: Gideon Israel Dsouza <gidisrael@gmail.com>
Cc: sds@tycho.nsa.gov, eparis@parisplace.org, akpm@linux-foundation.org,
        geert@linux-m68k.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] security: Used macros from compiler.h instead of __attribute__((...))
Date: Wed, 18 Jun 2014 14:50:44 -0400
Message-ID: <3604441.fZpjWNppGq@sifl>
User-Agent: KMail/4.13.2 (Linux/3.14.5-gentoo; KDE/4.13.2; x86_64; ; )
In-Reply-To: <1402502130-26400-2-git-send-email-gidisrael@gmail.com>
References: <1402502130-26400-1-git-send-email-gidisrael@gmail.com> <1402502130-26400-2-git-send-email-gidisrael@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 11, 2014 09:25:30 PM Gideon Israel Dsouza wrote:
> To increase compiler portability there is <linux/compiler.h> which
> provides convenience macros for various gcc constructs.  Eg: __packed
> for __attribute__((packed)).
> 
> This patch is part of a large task I've taken to clean the gcc
> specific attributes and use the the macros instead.
> 
> Signed-off-by: Gideon Israel Dsouza <gidisrael@gmail.com>
> ---
>  security/selinux/include/security.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

>From what I can tell this should still work with both the LLVM and Intel 
compilers, is that correct?

> diff --git a/security/selinux/include/security.h
> b/security/selinux/include/security.h index ce7852c..ff19bcc 100644
> --- a/security/selinux/include/security.h
> +++ b/security/selinux/include/security.h
> @@ -8,6 +8,7 @@
>  #ifndef _SELINUX_SECURITY_H_
>  #define _SELINUX_SECURITY_H_
> 
> +#include <linux/compiler.h>
>  #include <linux/dcache.h>
>  #include <linux/magic.h>
>  #include <linux/types.h>
> @@ -220,7 +221,7 @@ struct selinux_kernel_status {
>  	/*
>  	 * The version > 0 supports above members.
>  	 */
> -} __attribute__((packed));
> +} __packed;
> 
>  extern void selinux_status_update_setenforce(int enforcing);
>  extern void selinux_status_update_policyload(int seqno);

-- 
paul moore
www.paul-moore.com

