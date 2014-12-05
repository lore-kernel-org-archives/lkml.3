Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaLEICi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:02:38 -0500
Received: from smtprelay0122.hostedemail.com ([216.40.44.122]:55138 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750891AbaLEICg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:02:36 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3872:3874:4321:4605:5007:6117:6261:7903:10004:10400:10481:10848:11026:11232:11473:11658:11914:12517:12519:12740:13069:13311:13357:19900:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pot20_509debd934827
X-Filterd-Recvd-Size: 1509
Message-ID: <1417766552.2721.45.camel@perches.com>
Subject: Re: [RESEND PATCH] net: introduce helper macra CMSG_FOREACH_HDR
From: Joe Perches <joe@perches.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 05 Dec 2014 00:02:32 -0800
In-Reply-To: <54815B40.1050909@cn.fujitsu.com>
References: <54815B40.1050909@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-05 at 15:14 +0800, Gu Zheng wrote:
> Introduce helper macra

macro

> CMSG_FOREACH_HDR as a wrapper of the enumerating
> cmsghdr from msghdr, just cleanup. 

maybe better to use lower case "for_each_cmsg_hdr"
or some such.

checkpatch would recognize that too as long as it
uses "for_each".

> diff --git a/include/linux/socket.h b/include/linux/socket.h
[]
> @@ -94,6 +94,10 @@ struct cmsghdr {
>  			     (cmsg)->cmsg_len <= (unsigned long) \
>  			     ((mhdr)->msg_controllen - \
>  			      ((char *)(cmsg) - (char *)(mhdr)->msg_control)))
> +#define CMSG_FOREACH_HDR(cmsg, msg)  \
> +	for (cmsg = CMSG_FIRSTHDR(msg); \
> +	     cmsg; \
> +	     cmsg = CMSG_NXTHDR(msg, cmsg))


