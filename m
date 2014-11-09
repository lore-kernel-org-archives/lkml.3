Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaKIQLa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 11:11:30 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:62962 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaKIQL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 11:11:28 -0500
MIME-Version: 1.0
In-Reply-To: <8761epwgni.fsf@free.fr>
References: <1414941415-13146-1-git-send-email-robert.jarzmik@free.fr>
	<CALT56yOCBN1NAfNw=vThVZ_o=ONGOTvzKHBH5tCTQShJY0wkrQ@mail.gmail.com>
	<87lhnlwqm4.fsf@free.fr>
	<CALT56yNOXq-ssvsjafz=ae+uWv1GyscoQ3RQ_h--i740zm4trA@mail.gmail.com>
	<8761epwgni.fsf@free.fr>
Date: Sun, 9 Nov 2014 20:11:27 +0400
Message-ID: <CALT56yOU=cqczdEs=FOgoWUHev1A0gihEpV-XsD5_g_ECz6+Qg@mail.gmail.com>
Subject: Re: [PATCH v1 0/3] Transition pxa25x clock to common clocks
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Daniel Mack <zonque@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-09 0:01 GMT+03:00 Robert Jarzmik <robert.jarzmik@free.fr>:
> Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> writes:
>
>> 2014-11-08 20:26 GMT+03:00 Robert Jarzmik <robert.jarzmik@free.fr>:
>>> Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> writes:
>>>
>>>> Hello,
>>>> Tested in qemu (pxa25x target).
>>>>
>>>> 2) sa1100-rtc could not find a clock and thus failed to be probed.
>>>> 4) Got an issue with IrDA driver - it gets -ENODEV for UARTCLK clock
>>>
>>> Hi Dmitry,
>>>
>>> Would you mind retesting with the patch in [1] applied to see if points 2 and 4
>>> are fixed ? Alternatively you can refetch from the github tree, I included that
>>> incremental patch there too.
>>>
>>> If it works correctly for you, could I have your Tested-by ? If not, tell me and
>>> I'll try to figure out what's wrong.
>>
>> Tested in qemu, everything works fine. I will test on the real hardware
>> tomorow.
> Aha, the test.
> Would you at that time do a "cat /sys/kernel/debug/clk/clk_summary" and send it
> to me please ?

Tested-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

Captured on tosa (pxa255):

   clock                         enable_cnt  prepare_cnt        rate
accuracy   phase
----------------------------------------------------------------------------------------
 clk_dummy                                0            0           0
       0 0
 osc_32_768khz                            3            3    32768000
       0 0
    OSTIMER0                              1            1    32768000
       0 0
    sa1100-rtc                            1            1    32768000
       0 0
    GPIO12_CLK                            0            0    32768000
       0 0
    pxa26x-gpio                           0            0    32768000
       0 0
    pxa25x-gpio                           1            1    32768000
       0 0
 osc_3_6864mhz                            3            3     3686400
       0 0
    PWM1                                  0            0     3686400
       0 0
    PWM0                                  0            0     3686400
       0 0
    ASSP                                  0            0     3686400
       0 0
    NSSP                                  0            0     3686400
       0 0
    SSP                                   0            0     3686400
       0 0
    GPIO11_CLK                            1            1     3686400
       0 0
    cpll                                  0            0   398131200
       0 0
       core                               0            0   398131200
       0 0
       run                                0            0   199065600
       0 0
          MEMC                            0            0   199065600
       0 0
          LCD                             0            0   199065600
       0 0
          memory                          0            0    99532800
       0 0
    ppll_147_46mhz                        2            4   147456000
       0 0
       AC97                               1            1    12288000
       0 0
       I2S                                0            0   147456000
       0 0
       HWUART                             0            0    14745600
       0 0
       STUART                             0            1    14745600
       0 0
          pxa2xx-ir                       0            0    14745600
       0 0
       BTUART                             0            1    14745600
       0 0
       FFUART                             1            2    14745600
       0 0
    ppll_95_85mhz                         1            1    95846400
       0 0
       USB                                0            0    47923200
       0 0
       FICP                               0            0    47923200
       0 0
       I2C                                1            1    31948800
       0 0
       MMC                                0            0    19169280
       0 0


>> BTW: It looks like pxa27x also shows the same behaviour wrt. sa1100-rtc and
>> pxa2xx-ir (after reverting a revert).
> Ah yes, you're very right about that.
>
> Same as before, github updated and patch included in this mail.

Could you please also include a revert of
23c4a3a5212701ad34bd30591fa33d7bacef9c5f
into your branch? Otherwise pxa27x is broken in your tree.

>
> Cheers.
>
> --
> Robert
>



-- 
With best wishes
Dmitry
