Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaFWTPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 15:15:55 -0400
Received: from smtprelay0201.hostedemail.com ([216.40.44.201]:44551 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756012AbaFWTPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 15:15:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3873:3874:4321:5007:6119:7652:8603:10004:10400:10848:11026:11232:11657:11658:11914:12043:12114:12296:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pin26_8a913d1f1145e
X-Filterd-Recvd-Size: 1783
Message-ID: <1403550950.15811.15.camel@joe-AO725>
Subject: Re: [PATCH 08/22] amd: Use pci_zalloc_consistent
From: Joe Perches <joe@perches.com>
To: Don Fry <pcnet32@frontier.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Mon, 23 Jun 2014 12:15:50 -0700
In-Reply-To: <1403546524.12008.2.camel@Lunix2.home>
References: <cover.1403530604.git.joe@perches.com>
	 <c7cdaa8e080157cdabb92278a4c3beba89b49070.1403530604.git.joe@perches.com>
	 <1403546524.12008.2.camel@Lunix2.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 11:02 -0700, Don Fry wrote:
> On Mon, 2014-06-23 at 06:41 -0700, Joe Perches wrote:
> > Remove the now unnecessary memset too.
[]
> > diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
[]
> > @@ -484,15 +484,13 @@ static void pcnet32_realloc_tx_ring(struct net_device *dev,
> >  
> >  	pcnet32_purge_tx_ring(dev);
> >  
> > -	new_tx_ring = pci_alloc_consistent(lp->pci_dev,
> > -					   sizeof(struct pcnet32_tx_head) *
> > -					   (1 << size),
> > -					   &new_ring_dma_addr);
> > +	new_tx_ring = pci_zalloc_consistent(lp->pci_dev,
> > +					    sizeof(struct pcnet32_tx_head) * (1 << size),
> 
> This causes the line length to be greater than 80 characters causing
> checkpatch to complain.

Which doesn't bother me a whit.
I prefer the multiply on the same line.

If you prefer 80 columns that strongly though,
let me know.

