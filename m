Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaHMFO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:14:56 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:46688 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaHMFOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:14:52 -0400
Message-ID: <53EAF444.8050507@linaro.org>
Date: Wed, 13 Aug 2014 06:14:44 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-mmc@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH RFC 3/5] mmc: mmci: relax blksz check for SDIO
References: <1407844950-8072-1-git-send-email-srinivas.kandadgatla@linaro.org> <1407845080-8353-1-git-send-email-srinivas.kandadgatla@linaro.org> <20140812141242.GI30401@n2100.arm.linux.org.uk>
In-Reply-To: <20140812141242.GI30401@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thankyou for the feedback.

On 12/08/14 15:12, Russell King - ARM Linux wrote:
> On Tue, Aug 12, 2014 at 01:04:40PM +0100, Srinivas Kandagatla wrote:
>> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>>
>> This patch adds condition in mmci_validate_data to skip checking
>> blocksize for SDIO card types. SDIO card type can issue blocksizes
>> which are not exactly power of 2 so this check always fails, resulting
>> in SDIO failures.
>
> Do you understand why this check is there?
>
> Do you realise that the standard MMCI from ARM Ltd can /only/ perform
> power-of-2 block transfers?

Yes, I noticed that in pl180 TRM. I agree this patch will break standard 
MMCI.

In the past Ulf Hansson and Stefan Nilsson have submitted a patch to fix 
this issue for ux500v2. This patch adds new flag non_power_of_2_blksize 
/ any_blksize to variant_data.

http://www.spinics.net/lists/linux-mmc/msg12160.html
http://marc.info/?l=linux-mmc&m=131710963908853&w=2

This patch will fix the issue for Qcom too. If you are Ok with adding 
new flag non_power_of_2_blksize/any_blksize in the variant_data, I can 
rebase and include Ulf's patch in next version.


thanks,
--srini

>
> Hence, NAK on this change as it stands.
>
