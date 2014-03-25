Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbaCYWVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 18:21:52 -0400
Received: from smtprelay0043.hostedemail.com ([216.40.44.43]:51648 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751433AbaCYWVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 18:21:51 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:968:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2689:2828:2895:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3873:4250:4321:4823:5007:7652:8603:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tree65_ff93f028f811
X-Filterd-Recvd-Size: 2136
Message-ID: <1395786108.3726.4.camel@joe-AO722>
Subject: Re: [PATCH 2/2] staging: binder: Code simplification
From: Joe Perches <joe@perches.com>
To: Mathieu Maret <mathieu.maret@gmail.com>
Cc: linux-kernel@vger.kernel.org, arve@android.com, gregkh@linuxfoundation.org
Date: Tue, 25 Mar 2014 15:21:48 -0700
In-Reply-To: <1395785001-4153-2-git-send-email-mathieu.maret@gmail.com>
References: <1395785001-4153-1-git-send-email-mathieu.maret@gmail.com>
	 <1395785001-4153-2-git-send-email-mathieu.maret@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-25 at 23:03 +0100, Mathieu Maret wrote:
> Remove duplicate code
[]
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
[]
> @@ -2685,11 +2685,9 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		break;
>  	case BINDER_VERSION: {
>  		struct binder_version __user *ver = ubuf;
> -		if (size != sizeof(struct binder_version)) {
> -			ret = -EINVAL;
> -			goto err;
> -		}
> -		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION,
> +
> +		if (size != sizeof(struct binder_version) ||
> +			put_user(BINDER_CURRENT_PROTOCOL_VERSION,
>  			&ver->protocol_version)) {

When you do this, please align continuations at the appropriate
open parenthesis using maximal initial tabs and minimal spaces
for alignment.

		if (size != sizeof(struct binder_version) ||
		    put_user(BINDER_CURRENT_PROTOCOL_VERSION,
			     &ver->protocol_version)) {

2 tabs then 4 spaces then "put_user"
3 tabs then 5 spaces then "&ver->"

using scripts/checkpatch.pl --strict should alert you to this.

And, either don't submit this until after 3.15-rc1 is out
and Greg KH starts taking patches again, or expect to be
very patient about getting any update on this.

