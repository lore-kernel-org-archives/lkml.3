Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbaCZGUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 02:20:55 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:28447 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaCZGUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 02:20:53 -0400
Message-ID: <533271BA.5000007@atmel.com>
Date: Wed, 26 Mar 2014 14:20:42 +0800
From: Josh Wu <josh.wu@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: <g.liakhovetski@gmx.de>, <m.chehab@samsung.com>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [media] ov2640: add support for async device registration
References: <1394791952-12941-1-git-send-email-josh.wu@atmel.com> <532371F4.9050509@gmail.com> <53296094.3060209@atmel.com> <532AFED3.5030103@samsung.com>
In-Reply-To: <532AFED3.5030103@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Sylwester

On 3/20/2014 10:44 PM, Sylwester Nawrocki wrote:
> Hi Josh,
>
> On 19/03/14 10:17, Josh Wu wrote:
>> On 3/15/2014 5:17 AM, Sylwester Nawrocki wrote:
>>>> On 03/14/2014 11:12 AM, Josh Wu wrote:
>>>>>> +    clk = v4l2_clk_get(&client->dev, "mclk");
>>>>>> +    if (IS_ERR(clk))
>>>>>> +        return -EPROBE_DEFER;
>>>> You should instead make it:
>>>>
>>>>          return PTR_ERR(clk);
>>>>
>>>> But you will need this patch for that to work:
>>>> http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/drivers/clk/clk.c?id=a34cd4666f3da84228a82f70c94b8d9b692034ea
>>>>
>>>>
>>>> With this patch there is no need to overwrite any returned error
>>>> value with EPROBE_DEFER.
>> Thanks for the information. I will use this in v2 version.
> Oops, I missed somehow that it's v4l2_clk_get(), rather than
> clk_get(). So it seems it will not work when you return PTR_ERR(clk),
> since v4l2_clk_get() returns -ENODEV when clock is not found.

right, I missed that. So this version is still valid one. The v2 that I 
already sent should be dropped.

> I think we should modify v4l2_clk_get() so it returns EPROBE_DEFER
> rather than ENODEV on error. I anticipate v4l2_clk_get() might be
> using clk_get() internally in future, and the v4l2 clk look up
> will be used as a fallback only. So sensor drivers should just
> do something like:
>
>   clk = v4l2_clk_get(...);
>   if (IS_ERR(clk))
> 	return PTR_ERR(clk);

I noticed that there are some driver like ov772x, ov9640 and etc, are 
not supported the async probe yet.
If we return the EPROBE_DEFER for all v4l2_clk_get(), that will cause 
the no-async probe function work incorrectly.
So IMO we can do your above suggestion after all sensors support async 
probe.

Thanks.
>
> --
> Regards,
> Sylwester

Best Regards,
Josh Wu
