Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaEZRKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:10:35 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35425 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaEZRKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 13:10:33 -0400
Message-ID: <53837584.2010006@linaro.org>
Date: Mon, 26 May 2014 18:10:28 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 13/13] mmc: mmci: Add Qcom specific pio_read function.
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>	<1400849589-7626-1-git-send-email-srinivas.kandagatla@linaro.org> <CAPDyKFpGPBcg5zpLgrPbv86ekpVJrdOX-2LaZwoXQRAJwjc++w@mail.gmail.com>
In-Reply-To: <CAPDyKFpGPBcg5zpLgrPbv86ekpVJrdOX-2LaZwoXQRAJwjc++w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 26/05/14 15:34, Ulf Hansson wrote:
> This is hot path.
>
> As I suggested for the readl and writel wrapper functions, I think it
> would be better to use a function pointer in the struct mmci host,
> which you set up in the probe phase. That means the variant data don't
> need to be checked each an every time this function gets invoked.
>
>> >+
>> >                 if (status & MCI_TXACTIVE)
>> >                         len = mmci_pio_write(host, buffer, remain, status);
> So no changes needed for pio_write at this point? Or those will come later?
>

Yes, that sounds like more sensible approach to me. I will do this 
change in next version.

Thanks,
srini
>> >
>> >--
