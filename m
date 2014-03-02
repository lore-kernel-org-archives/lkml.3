Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaCBPO6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 10:14:58 -0500
Received: from smtprelay0237.hostedemail.com ([216.40.44.237]:54749 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751284AbaCBPO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 10:14:57 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1567:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2525:2560:2563:2682:2685:2731:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3866:3867:3870:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:7652:9025:10004:10400:10471:10848:11026:11232:11473:11658:11914:12043:12517:12519:12740:13069:13095:13181:13229:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: can17_2aff86ec2844b
X-Filterd-Recvd-Size: 1852
Message-ID: <1393773294.13719.25.camel@joe-AO722>
Subject: Re: [PATCH 1/1] scripts/checkpatch.pl: to give more detailed
 warning message in case printk is used in any patch
From: Joe Perches <joe@perches.com>
To: Yogesh Chaudhari <mr.yogesh@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, apw@canonical.com
Date: Sun, 02 Mar 2014 07:14:54 -0800
In-Reply-To: <CAAOfnZp-KAFo8Q4bBW7oxe8BgUn+bSDAWuHbK6E+SF0X0Ex=Wg@mail.gmail.com>
References: <CAAOfnZp-KAFo8Q4bBW7oxe8BgUn+bSDAWuHbK6E+SF0X0Ex=Wg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-02 at 20:31 +0530, Yogesh Chaudhari wrote:
> Based on the discussion here:
> https://lkml.org/lkml/2014/3/2/17
> 
> I would like to propose this patch to improve the warning message in
> checkpatch.pl.  Comments/Suggestions on possible improvements are
> welcome.

Messages are all single line.

This breaks --terse.

> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
>              WARN("PREFER_PR_LEVEL",
> -                 "Prefer netdev_$level2(netdev, ... then
> dev_$level2(dev, ... then pr_$level(...  to printk(KERN_$orig ...\n" .
> $herecurr);
> +                 "Order of preference for printing debug messages:
> +                 1. [subsystem]_$level2([subsystem]dev, ... eg
> netdev_$level2(netdev, ... for netdevice object
> +                 2. dev_$level2(dev, ... for drivers with struct device
> +                 3. pr_$level(...  to printk(KERN_$orig ...\n" . $herecurr);
>          }


