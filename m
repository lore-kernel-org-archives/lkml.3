Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab3FQTmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 15:42:19 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33611 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751470Ab3FQTmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 15:42:18 -0400
Message-ID: <1371498132.2213.7.camel@joe-AO722>
Subject: Re: [PATCH 4/4 v2] silicom: checkpatch: errors caused by macros
From: Joe Perches <joe@perches.com>
To: Lorenz Haspel <lorenz@badgers.com>
Cc: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        michael.banken@mathe.stud.uni-erlangen.de, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de
Date: Mon, 17 Jun 2013 12:42:12 -0700
In-Reply-To: <1371496814-26104-1-git-send-email-lorenz@badgers.com>
References: <1371486386-8043-4-git-send-email-lorenz@badgers.com>
	 <1371496814-26104-1-git-send-email-lorenz@badgers.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-17 at 21:20 +0200, Lorenz Haspel wrote:
> fixed checkpatch error:
> added parenthesis around complex macro.
> 
> Macro with return was only used once in the code,
> so I expandet it in-place.
[]
> diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
[]
> -#define lock_bpctl()					\
> -if (down_interruptible(&bpctl_sema)) {			\
> -	return -ERESTARTSYS;				\
> -}							\
> -
>  #define unlock_bpctl()					\
>  	up(&bpctl_sema);

Symmetry please.

Most likely, this unlock_bpctl macro is only used once too.
I suggest removing it as well.


