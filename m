Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaIXSVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:21:32 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35811 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbaIXSVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:21:19 -0400
Message-ID: <54230B9C.9090703@converseincode.com>
Date: Wed, 24 Sep 2014 11:21:16 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: bcm@fixthebug.org, chris@printf.net, gnurou@gmail.com,
        linus.walleij@linaro.org, mporter@linaro.org, ulf.hansson@linaro.org,
        bcm-kernel-feedback-list@broadcom.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        rjui@broadcom.com, linus.walleij@linaro.org
Subject: Re: [PATCH v2 2/2] mmc, sdhci, bcm-kona, LLVMLinux: Remove use of
 __initconst
References: <20140923212922.GG12270@beef> <1411512908-19237-1-git-send-email-behanw@converseincode.com> <1411512908-19237-2-git-send-email-behanw@converseincode.com> <5774775.2EcFmuR4sV@wuerfel>
In-Reply-To: <5774775.2EcFmuR4sV@wuerfel>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/14 02:22, Arnd Bergmann wrote:
> On Tuesday 23 September 2014 15:55:08 behanw@converseincode.com wrote:
>> --- a/drivers/mmc/host/sdhci-bcm-kona.c
>> +++ b/drivers/mmc/host/sdhci-bcm-kona.c
>> @@ -225,7 +225,7 @@ static struct sdhci_pltfm_data sdhci_pltfm_data_kona = {
>>                  SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
>>   };
>>   
>> -static struct __initconst of_device_id sdhci_bcm_kona_of_match[] = {
>> +static struct of_device_id const sdhci_bcm_kona_of_match[] = {
>>          { .compatible = "brcm,kona-sdhci"},
>>          { .compatible = "bcm,kona-sdhci"}, /* deprecated name */
>>          {}
>>
> Sorry for giving you trouble over such a simple patch (especially
> one that I have acked already), but I just noticed that this is
> not following the common style we use in the kernel.
It's all good. It's not like you haven't saved me a tonne of time 
already! :)

> Almost everywhere in Linux, we use
>
> static const struct of_device_id sdhci_bcm_kona_of_match[] = {
>
> not
>
> static struct of_device_id const sdhci_bcm_kona_of_match[] = {
True enough. I put the const where I did to be in keeping with the 
intent of __initconst, making the array const instead of the contained type.

> AFAICT they behave in identical ways,
Indeed. For C in both cases the resulting array of struct of_device_id 
ends up in .rodata, so functionally equivalent.

>   but the first one seems
> easier to read for someone familiar with kernel code.
No worries. Happy to post a v3.

Linus Walleij: Would you like me to respin the "gpio, bcm-kona, 
LLVMLinux: Remove use of __initconst" patch as well?

Behan

-- 
Behan Webster
behanw@converseincode.com

