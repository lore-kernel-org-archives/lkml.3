Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549AbaCTTUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:20:04 -0400
Received: from smtprelay0171.hostedemail.com ([216.40.44.171]:39634 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754030AbaCTTUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:20:01 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3834:3865:3866:3867:3870:3871:3872:3873:4321:4560:5007:6119:6120:7652:7901:7903:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: knife66_1cc8faa059021
X-Filterd-Recvd-Size: 1345
Message-ID: <1395343195.7776.37.camel@joe-AO722>
Subject: Re: [PATCH] rtc: add support for maxim dallas rtc ds1347
From: Joe Perches <joe@perches.com>
To: RAGHAVENDRA GANIGA <ravi23ganiga@gmail.com>
Cc: a.zummo@towertech.it, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Date: Thu, 20 Mar 2014 12:19:55 -0700
In-Reply-To: <532B3AB9.5050809@gmail.com>
References: <532B3AB9.5050809@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-21 at 00:30 +0530, RAGHAVENDRA GANIGA wrote:
> This is a patch to add support for
> maxim dallas rtc ds1347
[]
> diff --git a/drivers/rtc/rtc-ds1347.c b/drivers/rtc/rtc-ds1347.c
[]
> +static int ds1347_read_time(struct device *dev, struct rtc_time *dt)
> +{
[]
> +	/* year in linux is from 1900 i.e in range of 100
> +	in rtc it is from 00 to 99 so subtract
> +	the linux year by 100 */

> +	if (dt->tm_year >= 100)
> +		dt->tm_year -= 100;

This depends on how long you want to live, but it could be

	while (dt->tm_year >= 100)


