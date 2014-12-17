Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbaLQSWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:22:36 -0500
Received: from smtprelay0038.hostedemail.com ([216.40.44.38]:43558 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751225AbaLQSWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 13:22:34 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3290:3352:3622:3866:3868:4321:4605:5007:6117:6119:6261:7903:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12740:13069:13161:13229:13255:13311:13357:13868:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pigs54_5061b3aa59542
X-Filterd-Recvd-Size: 1969
Message-ID: <1418840550.14140.27.camel@perches.com>
Subject: Re: [PATCH 2/2] Staging: lustre: lproc_osc.c: used seq_puts()
 instead of seq_printf()
From: Joe Perches <joe@perches.com>
To: Hariharan Rangasamy <hariharanrangasamy@gmail.com>
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Wed, 17 Dec 2014 10:22:30 -0800
In-Reply-To: <1418839168-7921-2-git-send-email-hariharanrangasamy@gmail.com>
References: <1418839168-7921-1-git-send-email-hariharanrangasamy@gmail.com>
	 <1418839168-7921-2-git-send-email-hariharanrangasamy@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-17 at 23:29 +0530, Hariharan Rangasamy wrote:
> Replaced seq_printf() with seq_puts()
[]
> diff --git a/drivers/staging/lustre/lustre/osc/lproc_osc.c b/drivers/staging/lustre/lustre/osc/lproc_osc.c
[]
> @@ -358,7 +358,7 @@ static int osc_checksum_type_seq_show(struct seq_file *m, void *v)
>  		else
>  			seq_printf(m, "%s ", cksum_name[i]);
>  	}
> -	seq_printf(m, "\n");
> +	seq_puts(m, "\n");

This could be seq_putc

>  	return 0;
>  }
>  
> @@ -590,7 +590,7 @@ static int osc_rpc_stats_seq_show(struct seq_file *seq, void *v)
>  	seq_printf(seq, "pending read pages:   %d\n",
>  		   atomic_read(&cli->cl_pending_r_pages));
>  
> -	seq_printf(seq, "\n\t\t\tread\t\t\twrite\n");
> +	seq_puts(seq, "\n\t\t\tread\t\t\twrite\n");
>  	seq_printf(seq, "pages per rpc	 rpcs   %% cum %% |");
>  	seq_printf(seq, "       rpcs   %% cum %%\n");

These and others could be seq_puts too, just use % instead of %%


