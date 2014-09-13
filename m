Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaIMTLT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 15:11:19 -0400
Received: from smtprelay0108.hostedemail.com ([216.40.44.108]:51307 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752059AbaIMTLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 15:11:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:4321:5007:7652:7903:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12438:12517:12519:12740:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: seat15_44db8c2180b0e
X-Filterd-Recvd-Size: 2177
Message-ID: <1410635472.917.1.camel@joe-AO725>
Subject: Re: [PATCH] netdev: octeon_mgmt: ISO C90 forbids mixed declarations
 and code
From: Joe Perches <joe@perches.com>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: David Daney <david.daney@cavium.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luka Perkov <luka@openwrt.org>, Willem de Bruijn <willemb@google.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 13 Sep 2014 12:11:12 -0700
In-Reply-To: <1410635108-3589-1-git-send-email-xypron.glpk@gmx.de>
References: <1410635108-3589-1-git-send-email-xypron.glpk@gmx.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-09-13 at 21:05 +0200, Heinrich Schuchardt wrote:
> Compiling with OCTEON_MGMT_ETHERNET gives a warning
> drivers/net/ethernet/octeon/octeon_mgmt.c:295:4:
> warning: ISO C90 forbids mixed declarations and code
> [-Wdeclaration-after-statement]

Maybe better to move the memset after the declaration.

> diff --git a/drivers/net/ethernet/octeon/octeon_mgmt.c b/drivers/net/ethernet/octeon/octeon_mgmt.c
[]
> @@ -254,6 +254,7 @@ static void octeon_mgmt_clean_tx_buffers(struct octeon_mgmt *p)
>  	struct sk_buff *skb;
>  	int cleaned = 0;
>  	unsigned long flags;
> +	u64 ns;
>  
>  	mix_orcnt.u64 = cvmx_read_csr(p->mix + MIX_ORCNT);
>  	while (mix_orcnt.s.orcnt) {
> @@ -292,7 +293,7 @@ static void octeon_mgmt_clean_tx_buffers(struct octeon_mgmt *p)
>  			struct skb_shared_hwtstamps ts;
>  			memset(&ts, 0, sizeof(ts));
>  			/* Read the timestamp */
> -			u64 ns = cvmx_read_csr(CVMX_MIXX_TSTAMP(p->port));
> +			ns = cvmx_read_csr(CVMX_MIXX_TSTAMP(p->port));
>  			/* Remove the timestamp from the FIFO */
>  			cvmx_write_csr(CVMX_MIXX_TSCTL(p->port), 0);
>  			/* Tell the kernel about the timestamp */



