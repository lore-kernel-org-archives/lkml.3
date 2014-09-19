Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbaISOj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 10:39:29 -0400
Received: from smtprelay0235.hostedemail.com ([216.40.44.235]:51481 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753398AbaISOj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 10:39:27 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3873:3874:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12050:12296:12438:12517:12519:12555:12740:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: kite01_51f05e5c6a856
X-Filterd-Recvd-Size: 2225
Message-ID: <1411137561.24444.5.camel@joe-AO725>
Subject: Re: [PATCH v10 5/6] rtc: max77686: Use ffs() to calculate tm_wday
From: Joe Perches <joe@perches.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Doug Anderson <dianders@chromium.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        rtc-linux@googlegroups.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 19 Sep 2014 07:39:21 -0700
In-Reply-To: <1411122377-10426-6-git-send-email-javier.martinez@collabora.co.uk>
References: <1411122377-10426-1-git-send-email-javier.martinez@collabora.co.uk>
	 <1411122377-10426-6-git-send-email-javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-19 at 12:26 +0200, Javier Martinez Canillas wrote:
> The function max77686_rtc_calculate_wday() is used to
> calculate the day of the week to be filled in struct
> rtc_time but that function only calculates the number
> of bits shifted. So the ffs() function can be used to
> find the first bit set instead of a special function.

This isn't the same logic.  Perhaps you want fls.

> diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
[]
> -static inline int max77686_rtc_calculate_wday(u8 shifted)
> -{
> -	int counter = -1;
> -	while (shifted) {
> -		shifted >>= 1;
> -		counter++;
> -	}
> -	return counter;
> -}
> -
>  static void max77686_rtc_data_to_tm(u8 *data, struct rtc_time *tm,
>  				   int rtc_24hr_mode)
>  {
> @@ -93,7 +83,7 @@ static void max77686_rtc_data_to_tm(u8 *data, struct rtc_time *tm,
>  			tm->tm_hour += 12;
>  	}
>  
> -	tm->tm_wday = max77686_rtc_calculate_wday(data[RTC_WEEKDAY] & 0x7f);
> +	tm->tm_wday = ffs(data[RTC_WEEKDAY] & 0x7f) - 1;



