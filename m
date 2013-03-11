Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab3CKUZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:25:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54044 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752835Ab3CKUZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:25:30 -0400
Message-ID: <1363033528.2056.48.camel@joe-AO722>
Subject: Re: [PATCH 3/4] drivers: android: binder: Remove excessive
 indentation
From: Joe Perches <joe@perches.com>
To: Mirsal Ennaime <mirsal@mirsal.fr>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Brian Swetland <swetland@google.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 11 Mar 2013 13:25:28 -0700
In-Reply-To: <1363030315-10229-4-git-send-email-mirsal@mirsal.fr>
References: <1363030315-10229-1-git-send-email-mirsal@mirsal.fr>
	 <1363030315-10229-4-git-send-email-mirsal@mirsal.fr>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 20:31 +0100, Mirsal Ennaime wrote:
> Remove one level of indentation from the binder proc page release code
> by using slightly different control semantics.
[]
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
[]
> @@ -3002,18 +3002,20 @@ static void binder_deferred_release(struct binder_proc *proc)
>  	if (proc->pages) {
>  		int i;
>  		for (i = 0; i < proc->buffer_size / PAGE_SIZE; i++) {
> -			if (proc->pages[i]) {
> -				void *page_addr = proc->buffer + i * PAGE_SIZE;
> -				binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
> -					"binder_release: %d: page %d at %p not freed\n",
> -					proc->pid, i,
> -					page_addr);
> -				unmap_kernel_range((unsigned long)page_addr,
> -					PAGE_SIZE);
> -				__free_page(proc->pages[i]);
> -				page_count++;
> -			}
> +			if (!proc->pages[i])
> +				continue;
> +
> +			void *page_addr = proc->buffer + i * PAGE_SIZE;

Please declare variables immediately after an open brace.

		for (i = 0; i < proc->buffer_size / PAGE_SIZE; i++) {
			void *page_addr;

			if (!proc->pages[i])
				continue;

			page_addr = proc->buffer + i * PAGE_SIZE;

			etc...



