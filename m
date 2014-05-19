Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734AbaESRfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:35:33 -0400
Received: from smtprelay0070.hostedemail.com ([216.40.44.70]:33319 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754863AbaESRfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:35:31 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3653:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6691:7652:7903:10004:10400:10848:11026:11232:11658:11914:12043:12049:12114:12438:12517:12519:12740:13069:13071:13149:13161:13229:13230:13311:13357:13894:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: toy09_8740f07380a02
X-Filterd-Recvd-Size: 2358
Message-ID: <1400520928.30820.23.camel@joe-AO725>
Subject: Re: [PATCH] net: vxge: Use time_is_before_jiffies() for time
 comparison
From: Joe Perches <joe@perches.com>
To: Manuel =?ISO-8859-1?Q?Sch=F6lling?= <manuel.schoelling@gmx.de>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Mon, 19 May 2014 10:35:28 -0700
In-Reply-To: <1400518318-12386-2-git-send-email-manuel.schoelling@gmx.de>
References: <1400518056-12089-1-git-send-email-manuel.schoelling@gmx.de>
	 <1400518318-12386-1-git-send-email-manuel.schoelling@gmx.de>
	 <1400518318-12386-2-git-send-email-manuel.schoelling@gmx.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-19 at 18:51 +0200, Manuel Schölling wrote:
> To be future-proof and for better readability the time comparisons are modified
> to use time_is_before_jiffies() instead of plain, error-prone math.

Hi again Manuel.

Just a couple of FYIs/nits:

The "net: " prefix in your patch subject is a little
misleading.  One reading might be that the patch is
to the net/ subsystem but it's for a driver.

It might be better as:

[PATCH] vxge: Use time_is_before_jiffies

Generally, just use the last directory name
for the subject prefix.

ie:  patching: foo/bar/baz/qux.c

subject prefix is generally:

[PATCH] baz: whatever changed...

and a single patch to a number of different files
in foo/bar/baz/*.[ch] is still

[PATCH] baz: etc...

Also, the time_is_(before|after)_jiffies variants
are not used particularly often in the kernel.

The form using of time_<foo>(jiffies, ...)
is used _far_ more often (and it saves a little
typing too).

time_before(<foo>, jiffies)
time_is_before_jiffies(<foo>)

$ git grep -E -w "time_is_(before|after|before_eq|after_eq)_jiffies" | wc -l
93
$ git grep -E "\btime_(before|after|before_eq|after_eq)+\s*\(.*jiffies" | wc -l
1695

<shrug>  Maybe there's some reading clarity using
the time_is_(before|after)_jiffies variants.


