Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbaDHPGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:06:42 -0400
Received: from smtprelay0192.hostedemail.com ([216.40.44.192]:36866 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752644AbaDHPGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:06:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:3872:3873:3874:4321:4384:5007:7576:7652:9010:10004:10400:10848:11232:11658:11914:12517:12519:12740:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: brush86_57079b6cbf017
X-Filterd-Recvd-Size: 1661
Message-ID: <1396969596.2812.9.camel@joe-AO722>
Subject: Re: [PATCH 2/2] checkpatch: skip directories in file checking mode
From: Joe Perches <joe@perches.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 08 Apr 2014 08:06:36 -0700
In-Reply-To: <1396963505-11119-2-git-send-email-robherring2@gmail.com>
References: <1396963505-11119-1-git-send-email-robherring2@gmail.com>
	 <1396963505-11119-2-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-08 at 08:25 -0500, Rob Herring wrote:
> From: Rob Herring <robh@kernel.org>
> 
> Running checkpatch.pl on a list of files using a wildcard will exit if
> a directory is encountered. For example:
> 
> $ scripts/checkpatch.pl -f arch/*
> diff: arch/alpha/null: No such file or directory
> 
> The correct operation is arch/Kconfig should be checked. Fix this by
> skipping files which are not regular files.

<shrug>

You could make the same argument that it should
skip .o files if you fed it to checkpatch on the
command line.

I think the correct thing is to feed only files
you want scanned to checkpatch.

git ls-files arch/ | xargs ./scripts/checkpatch.pl -f



