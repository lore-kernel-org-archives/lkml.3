Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbaCRDsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 23:48:22 -0400
Received: from smtprelay0062.hostedemail.com ([216.40.44.62]:58451 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751180AbaCRDsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 23:48:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1801:2393:2559:2562:2693:2828:2909:3138:3139:3140:3141:3142:3352:3622:3865:3867:3870:3872:3873:4321:4384:4605:5007:7652:7903:10004:10400:10450:10455:10848:11026:11232:11658:11914:12043:12295:12438:12517:12519:12740:13069:13311:13357:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custo
X-HE-Tag: mine14_48b1d81f2bd30
X-Filterd-Recvd-Size: 2074
Message-ID: <1395114498.20860.4.camel@joe-AO722>
Subject: Re: [PATCH] staging: slicoss: Fix prefer ether_addr_copy over memcpy
From: Joe Perches <joe@perches.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Joel Pelaez Jorge'" <joelpelaez@gmail.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Rashika Kheria'" <rashika.kheria@gmail.com>,
        "'Peter P Waskiewicz Jr'" <peter.p.waskiewicz.jr@intel.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        "'Dan Carpenter'" <dan.carpenter@oracle.com>
Date: Mon, 17 Mar 2014 20:48:18 -0700
In-Reply-To: <002401cf425b$7d1db5f0$775921d0$%han@samsung.com>
References: <5327BACF.5020102@gmail.com>
	 <002401cf425b$7d1db5f0$775921d0$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-18 at 12:38 +0900, Jingoo Han wrote:
> In addition to this, there are the same cases like this,
> in this file as below. Please search other same cases.
> For instance, 'grep' will be a good way to find it.
[]
> static void slic_adapter_set_hwaddr(struct adapter *adapter)
> {
>         struct sliccard *card = adapter->card;
[]
>                 if (is_zero_ether_addr(adapter->currmacaddr))
>                         memcpy(adapter->currmacaddr, adapter->macaddr,
>                                ETH_ALEN);
>                 if (adapter->netdev)
>                         memcpy(adapter->netdev->dev_addr, adapter->currmacaddr,
>                                ETH_ALEN);
>         }
> }
> 
> Joe Perches,
> These are not spotted by checkpatch.pl.
> However, after modifying it as below, checkpatch warnings are
> printed. Would you confirm it?

If it's not on a single line, checkpatch won't find it.


