Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632AbaEMJeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:34:16 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:35136 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759828AbaEMJeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:34:09 -0400
Message-ID: <5371E703.9050705@linaro.org>
Date: Tue, 13 May 2014 10:33:55 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        agross@quicinc.com,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v1 07/11] mmc: mmci: move ST specific register extensions
 access under condition.
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>	<1398759627-13256-1-git-send-email-srinivas.kandagatla@linaro.org> <CACRpkdbgScfdLUc64a0r4Jxq9UHCbmMiAwD_G1-LZq8B58sX7g@mail.gmail.com>
In-Reply-To: <CACRpkdbgScfdLUc64a0r4Jxq9UHCbmMiAwD_G1-LZq8B58sX7g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 13/05/14 09:08, Linus Walleij wrote:
>> >         /* Keep ST Micro busy mode if enabled */
>> >-       datactrl |= host->datactrl_reg & MCI_ST_DPSM_BUSYMODE;
>> >+       if (host->hw_designer == AMBA_VENDOR_ST)
>> >+               datactrl |= host->datactrl_reg & MCI_ST_DPSM_BUSYMODE;
> Do not hard-check the hw_designer everywhere, follow the pattern
> if storing special stuff in the variant data.
>
Got it, I will fix this across other patches too.

> struct variant_data {
>          u32 datactrl_mask_busymode;
> (...)
>
> static struct variant_data variant_u300 = {
>          .datactrl_mask_busymode = MCI_ST_DPSM_BUSYMODE,
> (...)
> static struct variant_data variant_nomadik = {
