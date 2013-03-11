Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab3CKBeP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 21:34:15 -0400
Received: from mail1.windriver.com ([147.11.146.13]:45003 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab3CKBeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 21:34:13 -0400
Message-ID: <513D346E.20009@windriver.com>
Date: Mon, 11 Mar 2013 09:33:34 +0800
From: "tiejun.chen" <tiejun.chen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Alex Grad <alex.grad@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jason Wessel <jason.wessel@windriver.com>
CC: <penberg@kernel.org>, <paulus@samba.org>, <mikey@neuling.org>,
        <jason.wessel@windriver.com>, <sfr@canb.auug.org.au>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <daniel.baluta@gmail.com>
Subject: Re: [PATCH]->[PATCH v2] kgdb: Removed kmalloc returned value cast
References: <1362955188-3023-1-git-send-email-alex.grad@gmail.com>
In-Reply-To: <1362955188-3023-1-git-send-email-alex.grad@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [147.11.178.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 06:39 AM, Alex Grad wrote:
> While at it, check kmalloc return value.
>
> Signed-off-by: Alex Grad <alex.grad@gmail.com>
> ---
>   arch/powerpc/kernel/kgdb.c |    5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
> index 5ca82cd..9e81dd8 100644
> --- a/arch/powerpc/kernel/kgdb.c
> +++ b/arch/powerpc/kernel/kgdb.c
> @@ -159,7 +159,10 @@ static int kgdb_singlestep(struct pt_regs *regs)
>   	if (user_mode(regs))
>   		return 0;
>
> -	backup_current_thread_info = (struct thread_info *)kmalloc(sizeof(struct thread_info), GFP_KERNEL);
> +	backup_current_thread_info = kmalloc(sizeof(struct thread_info), GFP_KERNEL);
> +	if (!backup_current_thread_info)
> +		return -ENOMEM;

I already send a kgdb patchset in "[v3][PATCH 6/6] powerpc/kgdb: remove copying 
the thread_info" to remove these stuff since its unnecessary to copy current 
thread_info now.

Tiejun
