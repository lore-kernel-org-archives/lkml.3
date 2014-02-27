Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaB0Xxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 18:53:55 -0500
Received: from smtprelay0232.hostedemail.com ([216.40.44.232]:46738 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751232AbaB0Xxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 18:53:53 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 20,1.5,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:152:334:355:368:369:379:440:441:472:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2693:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3868:3870:3871:3872:4321:4605:5007:6119:7652:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12517:12519:12740:13069:13311:13357:13894:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: soda16_219c4b38ede16
X-Filterd-Recvd-Size: 2018
Message-ID: <1393545229.24588.147.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: fix spurious vendor compatible warnings
From: Joe Perches <joe@perches.com>
To: florian.vaussard@epfl.ch
Cc: Andy Whitcroft <apw@canonical.com>, Rob Herring <robh@kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 27 Feb 2014 15:53:49 -0800
In-Reply-To: <530F9F03.40803@epfl.ch>
References: <1393531019-25134-1-git-send-email-florian.vaussard@epfl.ch>
	 <1393531808.24588.119.camel@joe-AO722> <530F9F03.40803@epfl.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-27 at 21:24 +0100, Florian Vaussard wrote:
> On 02/27/2014 09:10 PM, Joe Perches wrote:
> > On Thu, 2014-02-27 at 20:56 +0100, Florian Vaussard wrote:
> >> With a compatible string like
> >> compatible = "foo";
> >> checkpatch will currently try to find "foo" in  vendor-prefixes.txt,
> >> which is wrong since the vendor prefix is empty in this specific case.
[]
> > Some vendor names have dashes.
> > I don't know if underscores are allowed.
> > 
> > $ grep -rP --include=*.[ch] -oh "compatible\s*=\s*\"[^,]+,\w" * | \
> >   sed -r -e 's/\s//g' -e 's/,.$//' | sort | uniq -c | grep "[_-]"
> >       1 compatible="active-semi
> >       8 compatible="asahi-kasei
[]
> In ePAPR v1.1, I could not find any strict requirement. It
> is just saying:
> 
> The recommended format is “manufacturer,model”, where manufacturer is a
> string describing the name of the manufacturer (such as a stock ticker
> symbol), and model specifies the model number.

Should there also be a check in .c and .h files for
	.compatible = "somestring"
and
	OF_DEV_AUXDATA("somestring",,,,)

?

