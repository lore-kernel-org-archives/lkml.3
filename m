Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaIJKvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 06:51:16 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:62702 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaIJKvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 06:51:14 -0400
MIME-Version: 1.0
In-Reply-To: <541014C8.7050303@linaro.org>
References: <1408683219-7939-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1408683272-7984-1-git-send-email-srinivas.kandagatla@linaro.org>
	<CAPDyKFqJw0Dc8ac2i0tebJpuHVhUVd=YUnGHZDTHNd2AAJqOtg@mail.gmail.com>
	<541014C8.7050303@linaro.org>
Date: Wed, 10 Sep 2014 12:51:13 +0200
Message-ID: <CAPDyKFrObvDf6rCWrEt8S2OydLJx0iz9bT0O0-danUuLs-PQvQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mmc: mmci: Support any block sizes for ux500v2 and
 qcom variant
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Chris Ball <chris@printf.net>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 September 2014 11:07, Srinivas Kandagatla
<srinivas.kandagatla@linaro.org> wrote:
> Hi Ulf,
>
> On 10/09/14 08:58, Ulf Hansson wrote:
>>
>> On 22 August 2014 06:54, Srinivas Kandagatla
>> <srinivas.kandagatla@linaro.org> wrote:
>>>
>>> From: Ulf Hansson <ulf.hansson@linaro.org>
>>>
>>> For the ux500v2 variant of the PL18x block, any block sizes are
>>> supported. This will make it possible to decrease data overhead
>>> for SDIO transfers.
>>>
>>> This patch is based on Ulf Hansson patch
>>> http://www.spinics.net/lists/linux-mmc/msg12160.html
>>>
>>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>>>          enabled this support on qcom variant.
>>>
>>> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>>
>>
>> I am not sure how to handle this patch.
>>
>> It will as you say in the cover letter for this patchset, improve
>> situations for the ath6kl driver when it's issuing 12 bytes and 24
>> bytes reads and solve those issues.
>>
>> On the other hand, as stated earlier mmci_pio_write need to be fixed
>> to have full support for any block size. That applies to the qcom
>> variant as well.
>
> looking at current mmci_pio_write, I see it can support any block sizes as
> it is. Unless Am missing something obvious.
>
> block size aligned to 4 is taken care in the code and is straight forward.
> block sizes not aligned to 4 are also partly taken care in pio_write and
> partly by programming blksz in datactrl register. However Am not sure if it
> was safe to handle the buffer pointer out of its boundary.

There are some prerequisites of the data buffers to supports any block
size. Make sure you read up on this discussion to really understand the problem.

http://marc.info/?t=135005062400002&r=2&w=2

>>
>>
>> For ux500, I am sure this won't cause any regressions since the cw1200
>> isn't probed. Also, I am not sure the "any block size" support is even
>> enabled for that driver.
>>
>> How about, that we add a comment in the pio_write function describing
>> that we need to fix it for "SDIO any block size" support? And leave
>> that as a future improvement?
>
>
> Is below patch any good?
> With the below patch It should be possible to address the case where buffer
> passed the length is handled safely. If you ok with the approach I can send
> a patch as RFC.

Please go ahead an send a patch :-) This has been on my todo list
forever, I would happily like to remove it from there.

Kind regards
Uffe
