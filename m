Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab3BVGz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 01:55:58 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:49947 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab3BVGzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 01:55:52 -0500
Message-ID: <51271673.9090003@linaro.org>
Date: Fri, 22 Feb 2013 12:25:47 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Kukjin Kim <kgene.kim@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: Origen board hang with functionfs
References: <51257FFF.3070109@linaro.org> <51266897.9070308@linaro.org>
In-Reply-To: <51266897.9070308@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 12:03 AM, John Stultz wrote:
> On 02/20/2013 06:01 PM, John Stultz wrote:
>> Hey Kukjin, Andrzej,
>>     I recently started playing around with functionfs, and have
>> noticed some strange behavior with my origen board.
>>
>> If I enable the FunctionFS gadget driver, I see the board hang at boot
>> here:
>>
>> [    2.360000] USB Mass Storage support registered.
>> [    2.365000] s3c-hsotg s3c-hsotg: regs f0040000, irq 103
>> [    2.375000] s3c-hsotg s3c-hsotg: EPs:15
>> [    2.380000] s3c-hsotg s3c-hsotg: dedicated fifos
>> [    2.385000] g_ffs: file system registered

I think the issue is because of the USB phy regulators. LDO3 and LDO8
power the phy regulators for OTG and HOST. These regulators are disabled
in OTG probe whereas they are not handled at all in HOST driver. Keeping
these LDOs always active should solve the problem for the time being.

I will follow-up with a patch shortly. But I am not sure if this patch
will be considered for mainline as board patches are not getting
accepted these days.

-- 
Tushar Behera
