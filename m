Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3JBBqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 21:46:51 -0400
Received: from smtprelay0226.hostedemail.com ([216.40.44.226]:36196 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751786Ab3JBBqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 21:46:48 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3350:3622:3865:3866:4321:5007:7652:8603:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13255:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: able68_3b0ec3761ea02
X-Filterd-Recvd-Size: 1873
Message-ID: <1380678404.2081.21.camel@joe-AO722>
Subject: Re: [PATCH] Staging: android: binder.c: Fixed 80 characters
 warnings from checkpatch.pl
From: Joe Perches <joe@perches.com>
To: Mathieu =?ISO-8859-1?Q?Rh=E9aume?= <mathieu@codingrhemes.com>
Cc: gregkh@linuxfoundation.org, arve@android.com, dan.carpenter@oracle.com,
        mirsal@mirsal.fr, serban.constantinescu@arm.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 01 Oct 2013 18:46:44 -0700
In-Reply-To: <1380677988-9329-1-git-send-email-mathieu@codingrhemes.com>
References: <1380677988-9329-1-git-send-email-mathieu@codingrhemes.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-01 at 21:39 -0400, Mathieu Rhéaume wrote:
> Fixed a lot of warnings from checkpatch.pl about the 80 characters per line limitation.

I'd prefer
	s/binder_user_error/binder_user_err/
or
	s/binder_user_error/binder_err/

without doing the strange wrapping

checkpatch will then exclude these long line formats from
line length checking.

> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
[]
> @@ -663,7 +663,8 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
>  		ALIGN(offsets_size, sizeof(void *));
>  
>  	if (size < data_size || size < offsets_size) {
> -		binder_user_error("%d: got transaction with invalid size %zd-%zd\n",
> +		binder_user_error(
> +		"%d: got transaction with invalid size %zd-%zd\n",
>  				proc->pid, data_size, offsets_size);

IMO - not an improvement


