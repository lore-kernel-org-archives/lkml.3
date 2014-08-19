Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaHSMIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 08:08:35 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:55716 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbaHSMIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 08:08:34 -0400
Message-ID: <53F33E35.3000900@linaro.org>
Date: Tue, 19 Aug 2014 13:08:21 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: linux-mmc <linux-mmc@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Chris Ball <chris@printf.net>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] mmc: mmci: move block size validation under relevant
 code
References: <1408446785-1399-1-git-send-email-srinivas.kandagatla@linaro.org>	<1408446866-1649-1-git-send-email-srinivas.kandagatla@linaro.org> <CAPDyKFok=r__hx1RaXFgttCQkeocSADY59nSPTZ6DUXQdddBRg@mail.gmail.com>
In-Reply-To: <CAPDyKFok=r__hx1RaXFgttCQkeocSADY59nSPTZ6DUXQdddBRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 19/08/14 12:55, Ulf Hansson wrote:
>>          writel(host->size, base + MMCIDATALENGTH);
>> >
>> >-       blksz_bits = ffs(data->blksz) - 1;
>> >-       BUG_ON(1 << blksz_bits != data->blksz);
> I don't like this BUG_ON at all, I would prefer if we remove it. The
> original patch "mmc: mmci: Support any block sizes for ux500v2", did
> so as well.
>
Yes, you are right this is redundant check, mmci_validate_data in 
mmci_request should catch this error anyway. we can remove this check 
totally and use your original patch.


--srini
> Now, if we still think removing it is fragile, let additional tests in
> mmci_validate_data() and return and error code from there.
