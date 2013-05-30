Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968165Ab3E3KUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:20:45 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:45697 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968106Ab3E3KUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:20:38 -0400
To: Sergey Yanovich <ynvich@gmail.com>
Subject: Re: [PATCH] rtc-ds1302: handle write protection
X-PHP-Originating-Script: 0:func.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 30 May 2013 12:20:33 +0200
From: Marc Zyngier <maz@misterjones.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, <rtc-linux@googlegroups.com>,
        <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>
Organization: Metropolis
In-Reply-To: <1369908882.17429.13.camel@host5.omatika.ru>
References: <1369092090-5384-1-git-send-email-ynvich@gmail.com> <20130529155311.9e35e847968f3923bc83f4cd@linux-foundation.org> <1369908882.17429.13.camel@host5.omatika.ru>
Message-ID: <53f44a9ec4c8391288d6c132fd5689da@localhost>
User-Agent: RoundCube Webmail/0.3.1
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: ynvich@gmail.com, akpm@linux-foundation.org, rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org, a.zummo@towertech.it, sachin.kamat@linaro.org, jg1.han@samsung.com
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013 14:14:42 +0400, Sergey Yanovich <ynvich@gmail.com>
wrote:
> On Wed, 2013-05-29 at 15:53 -0700, Andrew Morton wrote:
>> On Tue, 21 May 2013 03:21:30 +0400 Sergey Yanovich <ynvich@gmail.com>
>> wrote:
>> @@ -321,6 +326,7 @@ static int ds1302_rtc_remove(struct platform_device
>> *pdev)
>> >  {
>> >  	struct rtc_device *rtc = platform_get_drvdata(pdev);
>> >  
>> > +	ds1302_writebyte(RTC_ADDR_CTRL, RTC_CMD_WRITE_DISABLE);
>> >  	rtc_device_unregister(rtc);
>> >  	platform_set_drvdata(pdev, NULL);
>> 
>> ds1302_rtc_remove() no longer exists in my tree - it got whittled away
>> to nothing by
>>
http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-ds1302-remove-unnecessary-platform_set_drvdata.patch
>> and
>>
http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-ds1302c-remove-empty-function.patch
>> 
>> Perhaps it should be re-added for this?
> 
> There are 2 options. I would be happy with either.
> 
> 1. I've chosen 'probe/remove' to enable/disable write access.
> 
> 2. Another option is to wrap enable/disable around
> ds1302_rtc_set_time().
> 
> IIUC, the former saves a few bytes of memory. However, now, when
> ds1302_rtc_remove() is gone, the latter looks better. So I could rewrite
> the patch either way.

Option two looks actually safer to me, as it ensures that an unexpected
reboot outside of the set_time section doesn't leave write access enabled.
You never know what firmware could do while you're not looking...

         M.
-- 
Who you jivin' with that Cosmik Debris?
