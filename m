Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3KVEHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 23:07:10 -0500
Received: from mail.active-venture.com ([67.228.131.205]:57684 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab3KVEHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 23:07:06 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <528ED4A6.5070807@roeck-us.net>
Date: Thu, 21 Nov 2013 19:51:02 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Bibek Basu <bbasu@nvidia.com>, wim@iguana.be,
        linux-watchdog@vger.kernel.org, lee.jones@linaro.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] watchdog: as3722_wdt: support for AMS AS3722
References: <1384986810-10952-1-git-send-email-bbasu@nvidia.com> <1384986810-10952-2-git-send-email-bbasu@nvidia.com>
In-Reply-To: <1384986810-10952-2-git-send-email-bbasu@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 02:33 PM, Bibek Basu wrote:
> Add watchdog timer driver for as3722 device.
> The timer can be start/stop and set timing through
> watchdog subsystem callbacks.
>
> Change-Id: I5e252fd762764afaa1598cd98fed91864dc23d8d
> Signed-off-by: Bibek Basu <bbasu@nvidia.com>

[ ... ]

> +	wdt_dev->info = &as3722_wdt_info;
> +	wdt_dev->ops = &as3722_wdt_ops;
> +	wdt_dev->timeout = 128;

One more comment:

Unless I am missing something, this won't work if timer_initial_period is set.

If the watchdog is opened without explicitly setting a timeout,
the chip timeout will still be set to the value of initial_timeout,
while the watchdog susbystem will believe it to be 128 seconds,
and report that value to userspace when asked.
If initial_timeout is low, say, less than 60 seconds, the watchdog
will not be updated in time by userspace, since userspace will believe
that the timeout is 128 seconds and likely only ping the watchdog
every 64 seconds or so.

Guenter

