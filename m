Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbaE3K3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 06:29:49 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54931 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaE3K3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 06:29:48 -0400
Message-ID: <53885D98.8030207@linaro.org>
Date: Fri, 30 May 2014 11:29:44 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v4 11/13] mmc: mmci: add f_max to variant structure
References: <1401284608-16428-1-git-send-email-srinivas.kandagatla@linaro.org>	<1401284862-16894-1-git-send-email-srinivas.kandagatla@linaro.org> <CAPDyKFoURODuKS6NB4hN=iW=22S0x+ZiJWYz_UXW0Rc+0pW2Nw@mail.gmail.com>
In-Reply-To: <CAPDyKFoURODuKS6NB4hN=iW=22S0x+ZiJWYz_UXW0Rc+0pW2Nw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Ulf,

On 30/05/14 11:28, Ulf Hansson wrote:
>>           */
>> >-       if (host->mclk > 100000000) {
>> >-               ret = clk_set_rate(host->clk, 100000000);
>> >+       if (host->mclk > host->variant->f_max) {
> You can use the local variant pointer directly, instead of host->variant.
>
yes, Will do that in next version.

Thanks,
srini
>> >+               ret = clk_set_rate(host->clk, host->variant->f_max);
>> >                 if (ret < 0)
>> >                         goto clk_disable;
>> >                 host->mclk = clk_get_rate(host->clk);
>> >--
