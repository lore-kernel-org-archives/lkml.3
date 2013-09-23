Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3IWUoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:44:07 -0400
Received: from smtprelay0005.hostedemail.com ([216.40.44.5]:37103 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753062Ab3IWUoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:44:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3653:3865:3866:3868:3870:4321:4385:5007:6117:6119:6609:7652:7903:10004:10400:10848:11232:11657:11658:11914:12043:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cat75_664e488a8f2b
X-Filterd-Recvd-Size: 1953
Message-ID: <1379969042.3575.65.camel@joe-AO722>
Subject: Re: [PATCH 01/12] tcp.h: Remove extern from function prototypes
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 23 Sep 2013 13:44:02 -0700
In-Reply-To: <20130923.163010.976299939444640897.davem@davemloft.net>
References: <445209f8885ccd8234fa787c30d63e63fc7917d7.1379961014.git.joe@perches.com>
	 <20130923.163010.976299939444640897.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-23 at 16:30 -0400, David Miller wrote:
> Series applied,

How about the same changes for the .h files in drivers/net ?

(slowly of course, and by maintained subsystem)

$ git grep -E "^\s*\bextern(\s+\w+){1,4}\s*\(\s*[^\*]" drivers/net/ | wc -l
1445

Maybe something like groups of:
$ git grep -E --name-only "^\s*\bextern(\s+\w+){1,4}\s*\(\s*[^\*]" drivers/net/  | \
	cut -f3- -d"/" | cut -f1,2 -d"/" | uniq | \
	while read file ; do if [ -d drivers/net/$file ] ; then echo $file ; fi ; done
can/mscan
can/softing
ethernet/8390
ethernet/adi
ethernet/amd
ethernet/atheros
ethernet/broadcom
ethernet/brocade
ethernet/chelsio
ethernet/cirrus
ethernet/emulex
ethernet/freescale
ethernet/ibm
ethernet/intel
ethernet/mellanox
ethernet/natsemi
ethernet/octeon
ethernet/oki-semi
ethernet/qlogic
ethernet/sfc
ethernet/stmicro
ethernet/ti
ethernet/toshiba
fddi/skfp
wimax/i2400m
wireless/ath
wireless/brcm80211
wireless/ipw2x00
wireless/iwlegacy
wireless/iwlwifi
wireless/mwifiex
wireless/orinoco
wireless/rtlwifi


