Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbaKUSPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:15:23 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60771 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaKUSPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:15:17 -0500
Message-ID: <546F812A.1000103@einserver.de>
Date: Fri, 21 Nov 2014 19:15:06 +0100
From: Andreas Ruprecht <rupran@einserver.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH] media: pci: smipcie: Fix dependency for DVB_SMIPCIE
References: <1416592319-23644-1-git-send-email-rupran@einserver.de> <20141121161316.23963dc5@recife.lan>
In-Reply-To: <20141121161316.23963dc5@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.11.2014 19:13, Mauro Carvalho Chehab wrote:
> Em Fri, 21 Nov 2014 18:51:59 +0100
> Andreas Ruprecht <rupran@einserver.de> escreveu:
> 
>> In smipcie.c, the function i2c_bit_add_bus() is called. This
>> function is defined by the I2C bit-banging interfaces enabled
>> with CONFIG_I2C_ALGOBIT.
>>
>> As there was no dependency in Kconfig, CONFIG_I2C_ALGOBIT could
>> be set to "m" while CONFIG_DVB_SMIPCIE was set to "y", resulting
>> in a build error due to an undefined reference. This patch adds
>> the dependency on CONFIG_I2C_ALGOBIT in Kconfig.
>>
>> Signed-off-by: Andreas Ruprecht <rupran@einserver.de>
>> Reported-by: Jim Davis <jim.epost@gmail.com>
>> ---
>>  drivers/media/pci/smipcie/Kconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/pci/smipcie/Kconfig b/drivers/media/pci/smipcie/Kconfig
>> index 75a2992..c728721 100644
>> --- a/drivers/media/pci/smipcie/Kconfig
>> +++ b/drivers/media/pci/smipcie/Kconfig
>> @@ -1,6 +1,6 @@
>>  config DVB_SMIPCIE
>>  	tristate "SMI PCIe DVBSky cards"
>> -	depends on DVB_CORE && PCI && I2C
>> +	depends on DVB_CORE && PCI && I2C && I2C_ALGOBIT
> 
> IMHO, the best would be, instead, to select I2C_ALGOBIT.

Okay, I'll change that and submit a new version of this patch.

Regards,

Andreas Ruprecht
