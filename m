Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbaEMUu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 16:50:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbaEMUuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 16:50:50 -0400
Date: Tue, 13 May 2014 13:50:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH 2/2] FS/CONFIGFS: Use pr_fmt
Message-Id: <20140513135049.2d160a63d662b3aab6ba3c03@linux-foundation.org>
In-Reply-To: <20140513202428.77c59d530a2c2154a9902cb3@skynet.be>
References: <20140513202428.77c59d530a2c2154a9902cb3@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014 20:24:28 +0200 Fabian Frederick <fabf@skynet.be> wrote:

> -Adding pr_fmt based on module name.
>
> ...
>
> --- a/fs/configfs/configfs_internal.h
> +++ b/fs/configfs/configfs_internal.h
> @@ -24,6 +24,12 @@
>   * configfs Copyright (C) 2005 Oracle.  All rights reserved.
>   */
>  
> +#ifdef pr_fmt
> +#undef pr_fmt
> +#endif

Why this?

> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/slab.h>
>  #include <linux/list.h>
>  #include <linux/spinlock.h>
>
> ...
>
