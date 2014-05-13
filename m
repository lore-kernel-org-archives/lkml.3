Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281AbaEMKV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:21:57 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54469 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760152AbaEMKVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:21:52 -0400
Message-ID: <5371F23B.1070800@linaro.org>
Date: Tue, 13 May 2014 11:21:47 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        agross@quicinc.com, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v1 00/11] Add Qualcomm SD Card Controller support.
References: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org>	<1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org> <CAPDyKFodzdETbz3cj3mMT7a-ZJ9=Ants3WBstdEFLYiTOa-TnQ@mail.gmail.com>
In-Reply-To: <CAPDyKFodzdETbz3cj3mMT7a-ZJ9=Ants3WBstdEFLYiTOa-TnQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 13/05/14 11:04, Ulf Hansson wrote:
> On 29 April 2014 10:18,  <srinivas.kandagatla@linaro.org> wrote:
>> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>>
>> Hi Russell,
>>
>> This patch series adds Qualcomm SD Card Controller support in pl180 mmci
>> driver. QCom SDCC is basically a pl180, but bit more customized, some of the
>> register layouts and offsets are different to the ones mentioned in pl180
>> datasheet. The plan is to totally remove the standalone SDCC driver
>> drivers/mmc/host/msm_sdcc.* and start using generic mmci driver for all
>> Qualcomm parts, as we get chance to test on other Qcom boards.
>>
>> To start using the existing mmci driver, a fake amba id for Qualcomm is added
>> in patches:
>>   ARM: amba: Add Qualcomm vendor ID.
>>   mmc: mmci: Add Qualcomm Id to amba id table.
>>
>> Second change is, adding a 3 clock cycle delay for register writes on QCOM
>> SDCC
>> registers, which is done in patches:
>>    mmc: mmci: Add register read/write wrappers.
>>    mmc: mmci: Qcomm: Add 3 clock cycle delay after each register write
>>
>> Third change was to accommodate DATCTRL and MMCICLK register layout changes in
>> Qcom SDCC. Which is done in patches:
>>    mmc: mmci: Add Qcom datactrl register variant
>>    mmc: mmci: Add Qcom variations to MCICommand register.
>>    mmc: mmci: Qcom fix MCICLK register settings.
>>    mmc: mmci: Add clock support for Qualcomm.
>>
>> Fourth major change was to add qcom specfic pio read function, the need for
>> this is because the way MCIFIFOCNT register behaved in QCOM SDCC is very
>>   different to the one in pl180. This change is done in patch:
>>    mmc: mmci: Add Qcom specific pio_read function.
>>
>> Last some Qcom unrelated changes to support Qcom are done in patches:
>>    mmc: mmci: use NSEC_PER_SEC macro
>>    mmc: mmci: move ST specific register extensions access under condition.
>>
>> This patches are tested  v3.15-rc3 in PIO mode on IFC6410 board with both eMMC
>> and external SD card. I would appreciate any feedback on the patches.
>> I would like to get this for v3.16.
>>
>> Thanks,
>> srini
>>
>
> Hi Srinivas,
>
Hi Ulf,
> Thanks for working on this patchset, much appreciated! I intend to
> review them as soon as I can.

Thats Great.
>
> For your information, currently there are one patch queued via Chris'
> mmc tree for mmci and recently I have added my quite extensive
> patchset, via mine mmc tree, all to be tested in Linux next.
>
> I suppose the best approach to not hit conflicts would be if you base
> your patches upon my tree. Potentially we could merge them this way,
> unless of course Russell have other opinions.
>
> git://git.linaro.org/people/ulf.hansson/mmc.git next
>
Makes sense, I will rebase my next version of patches on top of your mmc 
git tree, if Russell has no issues with this approach.

Thanks,
srini
> Kind regards
> Ulf Hansson
>
