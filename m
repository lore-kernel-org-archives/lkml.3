Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbbANOwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:52:25 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:59733 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbbANOwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:52:24 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1501132138440.5526@nanos>
References: <1421163897-8020-1-git-send-email-xlpang@126.com>
	<1421163897-8020-3-git-send-email-xlpang@126.com>
	<alpine.DEB.2.11.1501132138440.5526@nanos>
Date: Wed, 14 Jan 2015 22:52:23 +0800
Message-ID: <CADcy93WJKD76kEtmWYT1bz_JOEAOF9gL96dBC0iY4p5r4eqefQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/9] time: Provide y2106 safe get_seconds() replacement
From: Xunlei Pang <pang.xunlei@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Xunlei Pang <xlpang@126.com>, lkml <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 January 2015 at 04:42, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 13 Jan 2015, Xunlei Pang wrote:
>
>> From: Xunlei Pang <pang.xunlei@linaro.org>
>>
>> As part of addressing "y2038 problem" for in-kernel uses, this
>> patch adds safe get_seconds64() using time64_t.
>>
>> After this patch, get_seconds() is deprecated and all its call sites
>> will be fixed using get_seconds64(), after that it can be removed.
>
> Why another interface?
>
> We already have ktime_get_real_seconds(). That handles 32bit
> correctly, while your new function does not.
>
> You cannot return a 64bit value unprotected against updates on 32bit,
> unless you want to implement a RNG.

Yes, ktime_get_real_seconds() should be used instead.

Thanks,
Xunlei
