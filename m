Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbaFWODg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:03:36 -0400
Received: from smtprelay0037.hostedemail.com ([216.40.44.37]:33264 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753393AbaFWODd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:03:33 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2551:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:4250:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12050:12114:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: love24_1eb7fc15d0947
X-Filterd-Recvd-Size: 1313
Message-ID: <1403532208.18747.58.camel@joe-AO725>
Subject: Re: [PATCH 01/22] pci-dma-compat: Add pci_zalloc_consistent helper
From: Joe Perches <joe@perches.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Mon, 23 Jun 2014 07:03:28 -0700
In-Reply-To: <4279380.YmNJ3E7DEi@wuerfel>
References: <cover.1403530604.git.joe@perches.com>
	 <2248b3ffe86cd8995a809bf7e2871f38039979c1.1403530604.git.joe@perches.com>
	 <4279380.YmNJ3E7DEi@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 15:53 +0200, Arnd Bergmann wrote:
> On Monday 23 June 2014 06:41:29 Joe Perches wrote:
> > Add this helper for consistency with pci_zalloc_coherent
> > and the ability to remove unnecessary memset(,0,) uses.

> Shouldn't these drivers just use the normal dma-mapping API now?

Maybe.  I wouldn't mind.

They do seem to have a trivial bit of unnecessary overhead for 

hwdev == NULL ? NULL : &hwdev->dev


