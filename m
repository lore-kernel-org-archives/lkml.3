Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab3KRWhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 17:37:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab3KRWhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 17:37:41 -0500
Date: Mon, 18 Nov 2013 14:37:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: <linus@narrativeteam.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtc: rtc-at91rm9200: Corrected alarm over day/month
 wrap:
Message-Id: <20131118143740.cdb5c0ee72b3d68e443afd66@linux-foundation.org>
In-Reply-To: <1384795254-11996-1-git-send-email-nicolas.ferre@atmel.com>
References: <1384795254-11996-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013 18:20:54 +0100 Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> From: Linus Pizunski <linus@narrativeteam.com>
> 
> Update month and day of month to the alarm month/day instead
> of current day/month when setting the RTC alarm mask.
> 
> Signed-off-by: Linus Pizunski <linus@narrativeteam.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

I changed this to signed-off-by, as you were on the patch delivery path.

> --- a/drivers/rtc/rtc-at91rm9200.c
> +++ b/drivers/rtc/rtc-at91rm9200.c
> @@ -220,6 +220,8 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
>  
>  	at91_alarm_year = tm.tm_year;
>  
> +	tm.tm_mon = alrm->time.tm_mon;
> +	tm.tm_mday = alrm->time.tm_mday;
>  	tm.tm_hour = alrm->time.tm_hour;
>  	tm.tm_min = alrm->time.tm_min;
>  	tm.tm_sec = alrm->time.tm_sec;

I queued this for 3.13.  Do we think it warrants a -stable backport?
