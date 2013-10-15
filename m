Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab3JOHR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:17:26 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:39785 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3JOHRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:17:24 -0400
Date: Tue, 15 Oct 2013 09:17:18 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390: Remove unused variable in copy_from_realmem()
Message-ID: <20131015091718.003f3fb7@mschwide>
In-Reply-To: <1381819811-28811-1-git-send-email-geert@linux-m68k.org>
References: <1381819811-28811-1-git-send-email-geert@linux-m68k.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101507-0542-0000-0000-000006BF5F98
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013 08:50:11 +0200
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> arch/s390/kernel/crash_dump.c: In function 'copy_from_realmem':
> arch/s390/kernel/crash_dump.c:48:6: warning: unused variable 'rc' [-Wunused-variable]
> 
> Introduced by commit 4d3b0664a0d0c0dc7501cfbd067f74226aeca510 ("s390: Allow
> vmalloc target buffers for copy_from_oldmem()").
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  arch/s390/kernel/crash_dump.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
> index 7dd21720e5b0..3db6af0601a5 100644
> --- a/arch/s390/kernel/crash_dump.c
> +++ b/arch/s390/kernel/crash_dump.c
> @@ -45,7 +45,6 @@ static inline void *load_real_addr(void *addr)
>  static int copy_from_realmem(void *dest, void *src, size_t count)
>  {
>  	unsigned long size;
> -	int rc;
> 
>  	if (!count)
>  		return 0;

Thanks for the hint but there is already a equivalent patch from Heiko on the
features branch on git-s390. I plan to get it pulled in the merge window for
3.13 as I feel that the warning is not important enough to fix it now.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

