Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaJBVJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 17:09:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaJBVJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 17:09:46 -0400
Date: Thu, 2 Oct 2014 14:09:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] acct: fix build warning when ACCT_VERSION != 3
Message-Id: <20141002140945.6f8ea8fcad9649819cb457e5@linux-foundation.org>
In-Reply-To: <20141001230653.GA25541@hercules>
References: <20141001230653.GA25541@hercules>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2014 00:06:53 +0100 Luis Henriques <luis.henriques@canonical.com> wrote:

> struct pid_namespace *ns is used only when ACCT_VERSION is 3.
> 
> kernel/acct.c:475:24: warning: unused variable 'ns' [-Wunused-variable]
> 
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> ---
>  kernel/acct.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/acct.c b/kernel/acct.c
> index b4c667d22e79..5f277f5c5e29 100644
> --- a/kernel/acct.c
> +++ b/kernel/acct.c
> @@ -472,7 +472,9 @@ static void do_acct_process(struct bsd_acct_struct *acct)
>  	acct_t ac;
>  	unsigned long flim;
>  	const struct cred *orig_cred;
> +#if ACCT_VERSION == 3
>  	struct pid_namespace *ns = acct->ns;
> +#endif
>  	struct file *file = acct->file;
>  
>  	/*

It's always a good idea to check linux-next.  This has been addressed by
http://ozlabs.org/~akpm/mmots/broken-out/acct-eliminate-compile-warning.patch
http://ozlabs.org/~akpm/mmots/broken-out/acct-eliminate-compile-warning-fix.patch


