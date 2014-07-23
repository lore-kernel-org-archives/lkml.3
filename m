Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbaGWLnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:43:13 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:55313 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaGWLnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:43:10 -0400
Message-ID: <53CF9FC4.1050404@gmail.com>
Date: Wed, 23 Jul 2014 19:43:00 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: herbert@gondor.apana.org.au
CC: davem@davemloft.net, linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: Re: [PATCH] drivers/crypto/Kconfig: Let 'DEV_QCE' depend on both
 HAS_DMA and HAS_IOMEM
References: <53C1F692.4000105@gmail.com> <53C3C92F.8010504@gmail.com>
In-Reply-To: <53C3C92F.8010504@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, sorry, this patch can still be alive, after a long discussion, we
need keep current status no touch -- still let individual modules to
depends on HAS_IOMEM and/or HAS_DMA, if they need them.

So please help check the patch, when you have time.

Thanks.

On 07/14/2014 08:12 PM, Chen Gang wrote:
> Hello all:
> 
> This patch is obsoleted according to the other discussion thread about
> IOMEM and COMPILE_TEST.
> 
> I shall fix it, and maybe not need touch drivers/crypto again, so maybe
> not need send patch v2 for it.
> 
> Thanks.
> 
> On 07/13/2014 11:01 AM, Chen Gang wrote:
>> 'DEV_QCE' needs both HAS_DMA and HAS_IOMEM, so let it depend on them.
>>
>> The related error (with allmodconfig under score):
>>
>>     MODPOST 1365 modules
>>   ERROR: "devm_ioremap_resource" [drivers/crypto/qce/qcrypto.ko] undefined!
>>   ERROR: "dma_map_sg" [drivers/crypto/qce/qcrypto.ko] undefined!
>>   ERROR: "dma_set_mask" [drivers/crypto/qce/qcrypto.ko] undefined!
>>   ERROR: "dma_supported" [drivers/crypto/qce/qcrypto.ko] undefined!
>>   ERROR: "dma_unmap_sg" [drivers/crypto/qce/qcrypto.ko] undefined!
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>  drivers/crypto/Kconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
>> index 5ef9ec9..2fb0fdf 100644
>> --- a/drivers/crypto/Kconfig
>> +++ b/drivers/crypto/Kconfig
>> @@ -422,7 +422,7 @@ source "drivers/crypto/qat/Kconfig"
>>  
>>  config CRYPTO_DEV_QCE
>>  	tristate "Qualcomm crypto engine accelerator"
>> -	depends on ARCH_QCOM || COMPILE_TEST
>> +	depends on (ARCH_QCOM || COMPILE_TEST) && HAS_DMA && HAS_IOMEM
>>  	select CRYPTO_AES
>>  	select CRYPTO_DES
>>  	select CRYPTO_ECB
>>
> 

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
