Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbaGIQ7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:59:43 -0400
Received: from smtprelay0139.hostedemail.com ([216.40.44.139]:36828 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751742AbaGIQ7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:59:41 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3868:3871:3872:3873:3874:4321:5007:7652:8957:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12740:13161:13229:14093:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: jewel54_1a2803a8c8036
X-Filterd-Recvd-Size: 2924
Message-ID: <1404925177.932.120.camel@joe-AO725>
Subject: Re: [PATCH] staging: bcm: add missing blank lines after declarations
From: Joe Perches <joe@perches.com>
To: Pawel Lebioda <pawel.lebioda89@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Wed, 09 Jul 2014 09:59:37 -0700
In-Reply-To: <1404921569-5081-1-git-send-email-pawel.lebioda89@gmail.com>
References: <20140704203024.GA11946@ThinkPad>
	 <1404921569-5081-1-git-send-email-pawel.lebioda89@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-09 at 17:59 +0200, Pawel Lebioda wrote:
> Fix "Missing blank line after declaration" warnings reported by
> checkpatch.pl.

trivial unrelated notes:

> diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
> index 3dbdf0e..adca0ce 100644
> --- a/drivers/staging/bcm/CmHost.c
> +++ b/drivers/staging/bcm/CmHost.c
> @@ -972,6 +972,7 @@ static VOID DumpCmControlPacket(PVOID pvBuffer)
>  		pstAddIndication->sfAuthorizedSet.bValid = 1;
>  	for (nIndex = 0; nIndex < nCurClassifierCnt; nIndex++) {
>  		struct bcm_convergence_types *psfCSType = NULL;
> +
>  		psfCSType =  &pstAddIndication->sfAuthorizedSet.cConvergenceSLTypes[nIndex];

You might consider removing the = NULL; on the declaration
as it's set on the next line.

> diff --git a/drivers/staging/bcm/IPv6Protocol.c b/drivers/staging/bcm/IPv6Protocol.c
> index cd16067..e013c5a 100644
> --- a/drivers/staging/bcm/IPv6Protocol.c
> +++ b/drivers/staging/bcm/IPv6Protocol.c
> @@ -45,6 +45,7 @@ static UCHAR *GetNextIPV6ChainedHeader(UCHAR **ppucPayload,
[]
>  			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
>  					DBG_LVL_ALL, "\nIPv6 Routing Header");

The leading "\n" is unnecessary and could be removed.

> @@ -66,6 +67,7 @@ static UCHAR *GetNextIPV6ChainedHeader(UCHAR **ppucPayload,
[]
>  			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
>  					DBG_LVL_ALL,
>  					"\nIPv6 DestOpts Header Header");

etc.

> @@ -407,6 +411,7 @@ VOID DumpIpv6Address(ULONG *puIpv6Address)
>  	UINT uiIpv6AddrNoLongWords = 4;
>  	UINT uiIpv6AddIndex = 0;
>  	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
> +
>  	for (uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
>  		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
>  				":%lx", puIpv6Address[uiIpv6AddIndex]);

All of these are effectively broken.

There's no BCM_DEBUG_PRINT that's like a pr_cont. 
All of these are emitted on separate lines.


