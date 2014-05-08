Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbaEHRzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:55:55 -0400
Received: from smtprelay0072.hostedemail.com ([216.40.44.72]:50610 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752329AbaEHRzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:55:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3871:4321:5007:7652:7904:9010:10004:10400:10848:11026:11658:11914:12043:12438:12517:12519:12740:13069:13071:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lift87_6d70244fc1e2c
X-Filterd-Recvd-Size: 1833
Message-ID: <1399571750.8479.2.camel@joe-AO725>
Subject: Re: [PATCH V2] kernel/kprobes.c: code clean-up
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        akpm <akpm@linux-foundation.org>
Date: Thu, 08 May 2014 10:55:50 -0700
In-Reply-To: <20140508194500.87f823c9463a59238878ccd4@skynet.be>
References: <20140508194500.87f823c9463a59238878ccd4@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-08 at 19:45 +0200, Fabian Frederick wrote:
> -Simplify __get_valid_kprobe (by Joe Perches)

Hello Fabian.

This bit should probably be a separate patch.

> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
[]
> @@ -1382,15 +1384,16 @@ static struct kprobe * __kprobes __get_valid_kprobe(struct kprobe *p)
>  	if (unlikely(!ap))
>  		return NULL;
>  
> -	if (p != ap) {
> -		list_for_each_entry_rcu(list_p, &ap->list, list)
> -			if (list_p == p)
> -			/* kprobe p is a valid probe */
> -				goto valid;
> -		return NULL;
> +	if (p == ap)
> +		return ap;
> +
> +	/* Make sure p is a valid probe*/
> +	list_for_each_entry_rcu(list_p, &ap->list, list){

Missing space between "){"

> +		if (list_p == p)
> +			return ap;
>  	}
> -valid:
> -	return ap;
> +
> +	return NULL;
>  }
>  
>  /* Return error if the kprobe is being re-registered */

Please remember to use scripts/checkpatch.pl on your patches
before sending them.


