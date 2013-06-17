Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab3FQQfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:35:24 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48770 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753018Ab3FQQfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:35:22 -0400
Message-ID: <1371486921.2213.1.camel@joe-AO722>
Subject: Re: [PATCH 4/4] solicom: checkpatch: added parenthesis to macros
From: Joe Perches <joe@perches.com>
To: Lorenz Haspel <lorenz@badgers.com>
Cc: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        michael.banken@mathe.stud.uni-erlangen.de, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de
Date: Mon, 17 Jun 2013 09:35:21 -0700
In-Reply-To: <1371486386-8043-4-git-send-email-lorenz@badgers.com>
References: <1371486386-8043-1-git-send-email-lorenz@badgers.com>
	 <1371486386-8043-4-git-send-email-lorenz@badgers.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-17 at 18:26 +0200, Lorenz Haspel wrote:
> fixed checkpatch error:
> added parenthesis around complex macros.
[]
> diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
[]
> @@ -44,9 +44,11 @@ MODULE_VERSION(BP_MOD_VER);
>  spinlock_t bpvm_lock;
>  
>  #define lock_bpctl()					\
> -if (down_interruptible(&bpctl_sema)) {			\
> -	return -ERESTARTSYS;				\
> -}							\
> +do {							\
> +	if (down_interruptible(&bpctl_sema)) {		\
> +		return -ERESTARTSYS;			\
> +	}						\
> +} while (0)

Macros with goto or return are also poor style.
Probably better to expand these in-place instead.

