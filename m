Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaHDNfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:35:46 -0400
Received: from smtprelay0250.hostedemail.com ([216.40.44.250]:45687 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751801AbaHDNfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:35:45 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1801:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4605:5007:7652:8985:9025:9121:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13161:13229:13255:13311:13357:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: plot54_3207926782608
X-Filterd-Recvd-Size: 1840
Message-ID: <1407159342.16152.63.camel@joe-AO725>
Subject: Re: checkpatch.pl report about "Missing blank line after
 declarations" in a structure definition
From: Joe Perches <joe@perches.com>
To: Dotan Barak <dotanb@mellanox.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 04 Aug 2014 06:35:42 -0700
In-Reply-To: <3219ba81002f41d99c8651755dc2a920@DB3PR05MB380.eurprd05.prod.outlook.com>
References: <3219ba81002f41d99c8651755dc2a920@DB3PR05MB380.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-04 at 11:20 +0000, Dotan Barak wrote:
> Hi Joe.
> 
> Thanks for fixing the issue that I reported about.
> 
> It seems that even after your fix, there is still a false warning of "Missing blank line after declarations".
> 
> I executed checkpatch.pl on a header file that exists in the Linux tree:
> # ./checkpatch.pl --file --no-tree ../include/linux/mlx5/cq.h
> 
> And got the following warning:
> 
> WARNING: Missing a blank line after declarations
> #49: FILE: ../include/linux/mlx5/cq.h:49:
> +       int                     irqn;
> +       void (*comp)            (struct mlx5_core_cq *);
[]
> As you can see, this is a structure definition and IMHO the warning above is false.

The version in Linus' tree has a defect where
this test doesn't recognize function pointer
declarations.

This is fixed in -next since June, but it takes
awhile to get into Linus' tree.

https://lkml.org/lkml/2014/6/6/426


