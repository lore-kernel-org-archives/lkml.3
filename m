Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaLOQjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:39:13 -0500
Received: from smtprelay0234.hostedemail.com ([216.40.44.234]:45168 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750865AbaLOQjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:39:10 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:2898:2915:3138:3139:3140:3141:3142:3352:3622:3865:3867:3871:3872:3873:3874:4321:5007:6261:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12555:12740:13069:13095:13161:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: glass77_4f53fbfe7cf09
X-Filterd-Recvd-Size: 2064
Message-ID: <1418661543.2674.17.camel@perches.com>
Subject: Re: [PATCH] Staging: rtl8712: removed an unnecessary else statement
From: Joe Perches <joe@perches.com>
To: Karthik Nayak <karthik.188@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Date: Mon, 15 Dec 2014 08:39:03 -0800
In-Reply-To: <1418657154-10481-1-git-send-email-karthik.188@gmail.com>
References: <1418657154-10481-1-git-send-email-karthik.188@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-15 at 20:55 +0530, Karthik Nayak wrote:
> As per checkpatch warning, removed an unnecessary else statement
> proceeding an if statement with a return.

This is not a correct change.
The checkpatch message said "generally".
You still have to verify the code.

> diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
> index cd8b444..800b2b3 100644
> --- a/drivers/staging/rtl8712/rtl8712_recv.c
> +++ b/drivers/staging/rtl8712/rtl8712_recv.c
> @@ -496,8 +496,7 @@ static int enqueue_reorder_recvframe(struct recv_reorder_ctrl *preorder_ctrl,
>  			plist = plist->next;
>  		else if (SN_EQUAL(pnextattrib->seq_num, pattrib->seq_num))
>  			return false;
> -		else
> -			break;
> +		break;


It's not the same logic.
It would be if the code was:

	while (end_of_queue_search(phead, plist) == false) {
		pnextrframe = LIST_CONTAINOR(plist, union recv_frame, u);
		pnextattrib = &pnextrframe->u.hdr.attrib;
		if (SN_LESS(pnextattrib->seq_num, pattrib->seq_num)) {
			plist = plist->next;
			continue;
		} else if (SN_EQUAL(pnextattrib->seq_num, pattrib->seq_num)) {
			return false;
		}
		break;
	}

But that's not necessary.

