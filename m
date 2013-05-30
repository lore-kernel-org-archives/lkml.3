Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968115Ab3E3KOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:14:54 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:46338 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967701Ab3E3KOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:14:47 -0400
Message-ID: <1369908882.17429.13.camel@host5.omatika.ru>
Subject: Re: [PATCH] rtc-ds1302: handle write protection
From: Sergey Yanovich <ynvich@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@misterjones.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>
Date: Thu, 30 May 2013 14:14:42 +0400
In-Reply-To: <20130529155311.9e35e847968f3923bc83f4cd@linux-foundation.org>
References: <1369092090-5384-1-git-send-email-ynvich@gmail.com>
	 <20130529155311.9e35e847968f3923bc83f4cd@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 15:53 -0700, Andrew Morton wrote:
> On Tue, 21 May 2013 03:21:30 +0400 Sergey Yanovich <ynvich@gmail.com> wrote:
> @@ -321,6 +326,7 @@ static int ds1302_rtc_remove(struct platform_device *pdev)
> >  {
> >  	struct rtc_device *rtc = platform_get_drvdata(pdev);
> >  
> > +	ds1302_writebyte(RTC_ADDR_CTRL, RTC_CMD_WRITE_DISABLE);
> >  	rtc_device_unregister(rtc);
> >  	platform_set_drvdata(pdev, NULL);
> 
> ds1302_rtc_remove() no longer exists in my tree - it got whittled away
> to nothing by
> http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-ds1302-remove-unnecessary-platform_set_drvdata.patch
> and
> http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-ds1302c-remove-empty-function.patch
> 
> Perhaps it should be re-added for this?

There are 2 options. I would be happy with either.

1. I've chosen 'probe/remove' to enable/disable write access.

2. Another option is to wrap enable/disable around
ds1302_rtc_set_time().

IIUC, the former saves a few bytes of memory. However, now, when
ds1302_rtc_remove() is gone, the latter looks better. So I could rewrite
the patch either way.

