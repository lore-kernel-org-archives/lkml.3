Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab3LaUIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 15:08:20 -0500
Received: from smtprelay0100.hostedemail.com ([216.40.44.100]:33683 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756187Ab3LaUIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 15:08:18 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6117:7576:7652:7903:8599:8985:9025:10004:10400:10848:10967:11026:11232:11658:11854:11855:11914:12043:12517:12519:12555:12740:13019:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,
X-HE-Tag: actor87_48173f9c21327
X-Filterd-Recvd-Size: 2021
Message-ID: <1388520494.2259.27.camel@joe-AO722>
Subject: Re: [PATCH v4 0/2] sctp: Consolidate and ratelimit deprecation
 warnings
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, vyasevich@gmail.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 31 Dec 2013 12:08:14 -0800
In-Reply-To: <20131231.140000.463004971089550957.davem@davemloft.net>
References: <1387205049-22752-1-git-send-email-nhorman@tuxdriver.com>
	 <1387805383-21500-1-git-send-email-nhorman@tuxdriver.com>
	 <20131231.140000.463004971089550957.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-31 at 14:00 -0500, David Miller wrote:
> From: Neil Horman <nhorman@tuxdriver.com>
> Date: Mon, 23 Dec 2013 08:29:41 -0500
> 
> > The SCTP protocol has several deprecation warnings in its setsockopt path that
> > can be triggered by unprivlidged users.  Since these are not ratelimited, we can
> > spam the logs quite easily here.  Since these are all deprecation warnings, and
> > that type of warning isn't uncommon in the rest of the kernel, lets make a
> > common pr_warn_deprecated macro to produce somewhat generalized ratelimited
> > deprecation warnings easily
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> Series applied, thanks Neil.
> 
> Please consider Ben's suggestion to provide the offending command string
> in the log output.

If something like the printk extension described in this thread
http://thread.gmane.org/gmane.linux.kernel/1620126 is ever accepted,
then it should be pretty easy to add later.



