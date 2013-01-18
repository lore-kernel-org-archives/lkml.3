Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab3ARNWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 08:22:05 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:65439 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab3ARNWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 08:22:04 -0500
MIME-Version: 1.0
In-Reply-To: <CA+Z25wWsv6z+GEQzvUhPL1NXnE-ha+pkobD7X-eUnds3jp2a8g@mail.gmail.com>
References: <1357733199-17206-1-git-send-email-a.kesavan@samsung.com>
	<1357733199-17206-4-git-send-email-a.kesavan@samsung.com>
	<CA+Z25wWsv6z+GEQzvUhPL1NXnE-ha+pkobD7X-eUnds3jp2a8g@mail.gmail.com>
Date: Fri, 18 Jan 2013 18:52:02 +0530
Message-ID: <CAM4voa=_43XqvOBzYYzO7H3DQ6Avw=rQgZLZ6FQSvp1v9rPEGA@mail.gmail.com>
Subject: Re: [PATCH 4/4] PM/Devfreq: Add Exynos5-bus devfreq driver for Exynos5250
From: Abhilash Kesavan <kesavan.abhilash@gmail.com>
To: Rajagopal Venkat <rajagopal.venkat@linaro.org>
Cc: myungjoo.ham@samsung.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, kgene.kim@samsung.com,
        kyungmin.park@samsung.com, rjw@sisk.pl, jhbird.choi@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rajagopal,

Thanks for the review. Sorry for the late response, have been a little
busy with other things,

[...]
>> +#include "../governor.h"
>
> This header file is meant for governors use. What's the need of it here?
I was using a custom monitor function and needed update_devfreq for
it. Will change this in the next version.
[...]
>> +       stat->current_frequency = data->curr_freq;
>> +       stat->busy_time = data->busy;
>> +       stat->total_time = 100;
>
> How is busy_time is relative to total_time here? busy_time <=
> total_time is guaranteed?
Will modify the get_dev_status function to do PPMU reads and populate
the device status structure.
>
[...]
> Again, update_devfreq() is meant for devfreq governors use. Why is the devfreq
> driver is doing devfreq governor job? any specific reason? The devfreq device
> load monitoring is done by governors.
>
Same as above.
[...]
>> +       .polling_ms             = 0,
>
> why is polling_ms is set to zero? It defeats the purpose of devfreq driver.
I bypassed the devfreq_monitor with the new custom function created. Am fixing
this.

I have now done this on the lines of the exynos4 driver. Will re-post in a bit.

Regards,
Abhilash
