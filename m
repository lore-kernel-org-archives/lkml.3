Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbaISTwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 15:52:35 -0400
Received: from smtprelay0114.hostedemail.com ([216.40.44.114]:49553 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932108AbaISTwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 15:52:33 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:960:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:3873:3874:4321:5007:6119:7652:8828:10004:10400:10848:11026:11232:11658:11914:12050:12438:12517:12519:12555:12740:13069:13071:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ball32_33038e0f5cf1e
X-Filterd-Recvd-Size: 2188
Message-ID: <1411156347.24444.31.camel@joe-AO725>
Subject: Re: [PATCH v10 5/6] rtc: max77686: Use ffs() to calculate tm_wday
From: Joe Perches <joe@perches.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Doug Anderson <dianders@chromium.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        rtc-linux@googlegroups.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 19 Sep 2014 12:52:27 -0700
In-Reply-To: <541C838B.7070207@collabora.co.uk>
References: <1411122377-10426-1-git-send-email-javier.martinez@collabora.co.uk>
	 <1411122377-10426-6-git-send-email-javier.martinez@collabora.co.uk>
	 <1411137561.24444.5.camel@joe-AO725> <541C838B.7070207@collabora.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-19 at 21:27 +0200, Javier Martinez Canillas wrote:
> Hello Joe,

Hello Javier.

> On 09/19/2014 04:39 PM, Joe Perches wrote:
> > On Fri, 2014-09-19 at 12:26 +0200, Javier Martinez Canillas wrote:
> >> The function max77686_rtc_calculate_wday() is used to
> >> calculate the day of the week to be filled in struct
> >> rtc_time but that function only calculates the number
> >> of bits shifted. So the ffs() function can be used to
> >> find the first bit set instead of a special function.
> > 
> > This isn't the same logic.  Perhaps you want fls.
> >
> 
> Right, the removed function has the same logic than fls() - 1 but the value
> stored in data[RTC_WEEKDAY] is:
> 
> data[RTC_WEEKDAY] = 1 << tm->tm_wday;
> 
> so for this particular case, it doesn't matter since ffs() == fls() always.

I didn't look that far.

I just wanted to show that the logic wasn't the same.

Perhaps you can specify that ffs==fls in the changelog.


