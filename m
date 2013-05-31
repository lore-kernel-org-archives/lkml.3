Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab3EaJMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 05:12:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56977 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab3EaJLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 05:11:55 -0400
Date: Fri, 31 May 2013 11:12:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: Re: [PATCH 06/16] perf, persistent: Return -EACCES if mapped buffers
 must be readonly
Message-ID: <20130531091206.GG14076@nazgul.tnic>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
 <1369990056-10310-7-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1369990056-10310-7-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 10:47:26AM +0200, Robert Richter wrote:
> From: Robert Richter <robert.richter@calxeda.com>
> 
> mmap should return EACCES error if fd can not be opened writable.
> This error code also helps userland to map buffers readonly on
> failure.
> 
> Signed-off-by: Robert Richter <robert.richter@calxeda.com>
> ---
>  kernel/events/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 0730f36..a9b6470 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3761,7 +3761,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
>  		return -EINVAL;
>  
>  	if (event->attr.persistent && (vma->vm_flags & VM_WRITE))
> -		return -EINVAL;
> +		return -EACCES;
>  
>  	vma_size = vma->vm_end - vma->vm_start;
>  	nr_pages = (vma_size / PAGE_SIZE) - 1;

Also merge.
