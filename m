Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaJ0SWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:22:16 -0400
Received: from smtprelay0002.hostedemail.com ([216.40.44.2]:35885 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751026AbaJ0SWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:22:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3867:4321:5007:6261:6642:7901:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: door78_135289f908e14
X-Filterd-Recvd-Size: 1544
Message-ID: <1414434131.18896.4.camel@perches.com>
Subject: Re: [PATCH 1/1 net-next] ipx: replace long unsigned int by unsigned
 long
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date: Mon, 27 Oct 2014 11:22:11 -0700
In-Reply-To: <1414433133-29161-1-git-send-email-fabf@skynet.be>
References: <1414433133-29161-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 19:05 +0100, Fabian Frederick wrote:
> Use standard unsigned long.
[]
> diff --git a/net/ipx/ipx_proc.c b/net/ipx/ipx_proc.c
[]
> @@ -90,7 +90,7 @@ static int ipx_seq_route_show(struct seq_file *seq, void *v)
>  	seq_printf(seq, "%08lX   ", (unsigned long int)ntohl(rt->ir_net));
>  	if (rt->ir_routed)
>  		seq_printf(seq, "%08lX     %02X%02X%02X%02X%02X%02X\n",
> -			   (long unsigned int)ntohl(rt->ir_intrfc->if_netnum),
> +			   (unsigned long)ntohl(rt->ir_intrfc->if_netnum),

Maybe better to use no cast at all

		seq_printf(seq, "%08X     %02X%02X%02X%02X%02X%02X\n",
			   ntohl(etc...),


