Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab3JBEG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 00:06:27 -0400
Received: from smtprelay0162.hostedemail.com ([216.40.44.162]:54450 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751766Ab3JBEG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 00:06:26 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:4321:5007:7652:7903:10004:10400:10848:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crib80_7210eb049d20c
X-Filterd-Recvd-Size: 2013
Message-ID: <1380686782.2081.28.camel@joe-AO722>
Subject: Re: [PATCH v2] Staging : android: binder.c: Prefer seq_puts to
 seq_printf
From: Joe Perches <joe@perches.com>
To: Mathieu =?ISO-8859-1?Q?Rh=E9aume?= <mathieu@codingrhemes.com>
Cc: gregkh@linuxfoundation.org, arve@android.com, dan.carpenter@oracle.com,
        mirsal@mirsal.fr, serban.constantinescu@arm.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 01 Oct 2013 21:06:22 -0700
In-Reply-To: <1380686239-15208-1-git-send-email-mathieu@codingrhemes.com>
References: <1380686239-15208-1-git-send-email-mathieu@codingrhemes.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-01 at 23:57 -0400, Mathieu Rhéaume wrote:
> Changes since v2:
>  * Fixed the indent problems (2 tab and 1 space) by Joe Perches.
>  * Found more calls to convert from seq_printf to seq_puts
[]
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
[]
> @@ -3272,33 +3272,33 @@ binder_defer_work(struct binder_proc *proc, enum binder_deferred_state defer)
>  static void print_binder_transaction(struct seq_file *m, const char *prefix,
>  				     struct binder_transaction *t)
>  {
> -	seq_printf(m,
> -		   "%s %d: %p from %d:%d to %d:%d code %x flags %x pri %ld r%d",
> -		   prefix, t->debug_id, t,
> -		   t->from ? t->from->proc->pid : 0,
> -		   t->from ? t->from->pid : 0,
> -		   t->to_proc ? t->to_proc->pid : 0,
> -		   t->to_thread ? t->to_thread->pid : 0,
> -		   t->code, t->flags, t->priority, t->need_reply);
> +		seq_puts(m, "%s %d: %p from %d:%d to %d:%d code %x flags %x pri %ld r%d",

Only indent the subsequent lines
not the initial seq_puts.


