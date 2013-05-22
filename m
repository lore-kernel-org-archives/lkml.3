Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab3EVXbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 19:31:03 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:39718 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab3EVXbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 19:31:01 -0400
Message-ID: <519D552E.7060701@gmail.com>
Date: Thu, 23 May 2013 03:30:54 +0400
From: Dmitry Osipenko <digetx@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: a.zummo@towertech.it, akpm@linuxfoundation.org, ldewangan@nvidia.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: tps6586x: device wakeup flags correction
References: <1368368706-21261-1-git-send-email-digetx@gmail.com> <20130522152204.d46057964fa06cc0d56f8e6b@linux-foundation.org>
In-Reply-To: <20130522152204.d46057964fa06cc0d56f8e6b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

23.05.2013 02:22, Andrew Morton пишет:
> On Sun, 12 May 2013 18:25:06 +0400 Dmitry Osipenko <digetx@gmail.com> wrote:
> 
>> Use device_init_wakeup() instead of device_set_wakeup_capable() and move it
>> before rtc dev registering. This fixes issue with alarmtimer that checks wakeup
>> capability with device_may_wakeup() on device add.
> 
> Well OK, but what is this "issue"?
> 
> (form letter: When writing a changelog, please describe the
> end-user-visible effects of the bug, so that others can more easily
> decide which kernel version(s) should be fixed, and so that downstream
> kernel maintainers can more easily work out whether this patch will fix
> a problem which they or their customers are observing.)
> 

Hi, Andrew. Thanks for comment. "Issue" is that alarmtimer won't be registered
if tps6586x is the only wakeup compatible rtc in the system.

from kernel/time/alarmtimer.c:

static int alarmtimer_rtc_add_device(struct device *dev,
				struct class_interface *class_intf)
{
...
	if (!device_may_wakeup(rtc->dev.parent)) // dev.parent = tps6586x rtc
		return -1;

I've sent V2 with changed description.
