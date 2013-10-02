Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab3JBCTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 22:19:43 -0400
Received: from smtprelay0185.hostedemail.com ([216.40.44.185]:49834 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751572Ab3JBCTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 22:19:41 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3870:3872:4321:4823:5007:7652:7903:8603:10004:10400:10848:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pets97_3718a6a24af0a
X-Filterd-Recvd-Size: 2255
Message-ID: <1380680377.2081.27.camel@joe-AO722>
Subject: Re: [PATCH] Staging : android: binder.c: Prefer seq_puts to
 seq_printf
From: Joe Perches <joe@perches.com>
To: Mathieu =?ISO-8859-1?Q?Rh=E9aume?= <mathieu@codingrhemes.com>
Cc: gregkh@linuxfoundation.org, arve@android.com, dan.carpenter@oracle.com,
        mirsal@mirsal.fr, serban.constantinescu@arm.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 01 Oct 2013 19:19:37 -0700
In-Reply-To: <1380679056-10175-1-git-send-email-mathieu@codingrhemes.com>
References: <1380679056-10175-1-git-send-email-mathieu@codingrhemes.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-01 at 21:57 -0400, Mathieu Rhéaume wrote:
> This patch changes seq_printf for seq_puts in binder.c.
> It fixes the warnings emitted by checkpatch.pl.

Please realign function argument to the open parenthesis.

> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
[]
> @@ -3272,7 +3272,7 @@ binder_defer_work(struct binder_proc *proc, enum binder_deferred_state defer)
>  static void print_binder_transaction(struct seq_file *m, const char *prefix,
>  				     struct binder_transaction *t)
>  {
> -	seq_printf(m,
> +	seq_puts(m,
>  		   "%s %d: %p from %d:%d to %d:%d code %x flags %x pri %ld r%d",
>  		   prefix, t->debug_id, t,
>  		   t->from ? t->from->proc->pid : 0,

This should be
	seq_puts(m, "%s..."
		 prefix, etc...

using two tabs then 1 space to align to open parenthesis

> @@ -3287,7 +3287,7 @@ static void print_binder_transaction(struct seq_file *m, const char *prefix,
>  	if (t->buffer->target_node)
>  		seq_printf(m, " node %d",
>  			   t->buffer->target_node->debug_id);
> -	seq_printf(m, " size %zd:%zd data %p\n",
> +	seq_puts(m, " size %zd:%zd data %p\n",
>  		   t->buffer->data_size, t->buffer->offsets_size,

	seq_puts(m, " size...",
		 t->buffer->etc...

etc...


