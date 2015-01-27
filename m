Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbbA0RGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:06:03 -0500
Received: from smtprelay0215.hostedemail.com ([216.40.44.215]:54896 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753188AbbA0RGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:06:01 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::,RULES_HIT:41:355:379:541:599:800:960:968:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:3138:3139:3140:3141:3142:3167:3352:3622:3865:3867:3870:3871:3872:3873:3874:4321:4605:5007:6261:7576:7809:7875:9149:10004:10400:10848:10967:11026:11232:11658:11914:12043:12295:12296:12438:12517:12519:12555:12683:12740:13069:13311:13357:14110:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sun14_3452ec37ced4d
X-Filterd-Recvd-Size: 2465
Date: Tue, 27 Jan 2015 12:05:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: Remove newline from trace_printk warning
 banner
Message-ID: <20150127120558.0b428aac@gandalf.local.home>
In-Reply-To: <1422375440-31970-1-git-send-email-bp@alien8.de>
References: <1422375440-31970-1-git-send-email-bp@alien8.de>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015 17:17:20 +0100
Borislav Petkov <bp@alien8.de> wrote:

> From: Borislav Petkov <bp@suse.de>
> 
> Remove the output-confusing newline below:
> 
> [    0.191328]
> **********************************************************
> [    0.191493] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
> [    0.191586] **                                                      **
> ...
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  kernel/trace/trace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 4a9079b9f082..7a04946ffb06 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2036,7 +2036,7 @@ void trace_printk_init_buffers(void)
>  
>  	/* trace_printk() is for debug use only. Don't use it in production. */
>  
> -	pr_warning("\n**********************************************************\n");
> +	pr_warning("**********************************************************\n");

Actually, could you just move the \n to another pr_warning. Because
this can print on console text that makes it look weird too:

login: [    0.191328] **********************************************************
[    0.191493] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.191586] **                                                      **

-- Steve

>  	pr_warning("**   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **\n");
>  	pr_warning("**                                                      **\n");
>  	pr_warning("** trace_printk() being used. Allocating extra memory.  **\n");

