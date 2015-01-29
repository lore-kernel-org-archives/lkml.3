Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815AbbA2B4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:56:30 -0500
Received: from smtprelay0162.hostedemail.com ([216.40.44.162]:60267 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759729AbbA2B4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:56:12 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 13,1.2,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3290:3352:3622:3865:3867:3868:3870:3871:3872:4321:4605:5007:6117:6119:6261:7903:10008:10400:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12740:13069:13161:13229:13311:13357:13868:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: toad05_52ec72d2b9d07
X-Filterd-Recvd-Size: 2761
Message-ID: <1422496567.13127.29.camel@perches.com>
Subject: Re: [PATCH] staging: lustre: lustre: osc: fix Prefer seq_puts to
 seq_printf
From: Joe Perches <joe@perches.com>
To: Heba Aamer <heba93aamer@gmail.com>
Cc: devel@driverdev.osuosl.org, oleg.drokin@intel.com,
        andreas.dilger@intel.com, gregkh@linuxfoundation.org,
        gdonald@gmail.com, dmitry.eremin@intel.com, brilliantov@inbox.ru,
        tristan@lelong.xyz, HPDD-discuss@ml01.01.org,
        linux-kernel@vger.kernel.org
Date: Wed, 28 Jan 2015 17:56:07 -0800
In-Reply-To: <20150128140533.GA14301@mohammed-Inspiron-3537>
References: <20150128140533.GA14301@mohammed-Inspiron-3537>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-28 at 16:05 +0200, Heba Aamer wrote:
> This patch fixes the following checkpatch.pl warning:
> Prefer seq_puts to seq_printf

checkpatch is pretty stupid.
Please don't just do what it says.

Look further and see what else can be improved.

> diff --git a/drivers/staging/lustre/lustre/osc/lproc_osc.c b/drivers/staging/lustre/lustre/osc/lproc_osc.c
[]
> @@ -364,7 +364,7 @@ static int osc_checksum_type_seq_show(struct seq_file *m, void *v)
>  		else
>  			seq_printf(m, "%s ", cksum_name[i]);
>  	}
> -	seq_printf(m, "\n");
> +	seq_puts(m, "\n");

This could be seq_putc

> @@ -601,7 +601,7 @@ static int osc_rpc_stats_seq_show(struct seq_file *seq, void *v)
>  	seq_printf(seq, "pending read pages:   %d\n",
>  		   atomic_read(&cli->cl_pending_r_pages));
>  
> -	seq_printf(seq, "\n\t\t\tread\t\t\twrite\n");
> +	seq_puts(seq, "\n\t\t\tread\t\t\twrite\n");
>  	seq_printf(seq, "pages per rpc	 rpcs   %% cum %% |");
>  	seq_printf(seq, "       rpcs   %% cum %%\n");

The seq_printf uses with %% could also be seq_puts

> @@ -624,7 +624,7 @@ static int osc_rpc_stats_seq_show(struct seq_file *seq, void *v)
>  			break;
>  	}
>  
> -	seq_printf(seq, "\n\t\t\tread\t\t\twrite\n");
> +	seq_puts(seq, "\n\t\t\tread\t\t\twrite\n");
>  	seq_printf(seq, "rpcs in flight	rpcs   %% cum %% |");
>  	seq_printf(seq, "       rpcs   %% cum %%\n");

seq_puts here too

> @@ -647,7 +647,7 @@ static int osc_rpc_stats_seq_show(struct seq_file *seq, void *v)
>  			break;
>  	}
>  
> -	seq_printf(seq, "\n\t\t\tread\t\t\twrite\n");
> +	seq_puts(seq, "\n\t\t\tread\t\t\twrite\n");
>  	seq_printf(seq, "offset		rpcs   %% cum %% |");
>  	seq_printf(seq, "       rpcs   %% cum %%\n");
>  

and here


