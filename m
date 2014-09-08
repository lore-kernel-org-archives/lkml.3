Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbaIHN6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:58:10 -0400
Received: from smtprelay0076.hostedemail.com ([216.40.44.76]:47545 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754258AbaIHN6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:58:08 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3872:4321:4605:4823:5007:6119:7652:7875:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13069:13141:13230:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: thumb38_63c2e47795a00
X-Filterd-Recvd-Size: 2467
Message-ID: <1410184684.12560.11.camel@joe-AO725>
Subject: Re: [PATCH] staging: binder: fix coding style issues
From: Joe Perches <joe@perches.com>
To: Dmitry Voytik <voytikd@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Brian Swetland <swetland@google.com>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 08 Sep 2014 06:58:04 -0700
In-Reply-To: <1410183467-13504-1-git-send-email-voytikd@gmail.com>
References: <1410183467-13504-1-git-send-email-voytikd@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-08 at 17:37 +0400, Dmitry Voytik wrote:
> Fix coding style issues:
> * put braces in all if-else branches;
> * limit the length of changed lines to 80 columns.
> checkpatch.pl warning count reduces by 3.
[]
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
[]
> @@ -2198,12 +2198,16 @@ retry:
>  		struct binder_work *w;
>  		struct binder_transaction *t = NULL;
>  
> -		if (!list_empty(&thread->todo))
> -			w = list_first_entry(&thread->todo, struct binder_work, entry);
> -		else if (!list_empty(&proc->todo) && wait_for_proc_work)
> -			w = list_first_entry(&proc->todo, struct binder_work, entry);
> -		else {
> -			if (ptr - buffer == 4 && !(thread->looper & BINDER_LOOPER_STATE_NEED_RETURN)) /* no data added */
> +		if (!list_empty(&thread->todo)) {
> +			w = list_first_entry(&thread->todo, struct binder_work,
> +						entry);
> +		} else if (!list_empty(&proc->todo) && wait_for_proc_work) {
> +			w = list_first_entry(&proc->todo, struct binder_work,
> +						entry);

Please indent multi line statements to the
appropriate open parenthesis using maximal
initial tabs and few spaces as required.

Here it would use 5 tabs, then 6 spaces.

			w =  list_first_entry(&proc->todo, struct binder_work,
					      entry);
> +		} else {
> +			/* no data added */
> +			if (ptr - buffer == 4 && !(thread->looper &
> +					BINDER_LOOPER_STATE_NEED_RETURN))

better as
			if (ptr - buffer == 4 &&
			    !(thread->looper & BINDER_LOOPER_STATE_NEED_RETURN))


