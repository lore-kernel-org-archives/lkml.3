Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab3KKPGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:06:51 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:39643 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab3KKPGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:06:45 -0500
Message-ID: <5280F281.1050801@gmail.com>
Date: Mon, 11 Nov 2013 09:06:41 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Robert Richter <rric@kernel.org>
CC: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org
Subject: Re: [PATCH] edac, highbank: remove dependency on ARCH_HIGHBANK
References: <1383708352-19527-1-git-send-email-robherring2@gmail.com> <20131111110904.GQ7429@rric.localhost>
In-Reply-To: <20131111110904.GQ7429@rric.localhost>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 05:09 AM, Robert Richter wrote:
> On 05.11.13 21:25:52, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> In order to enable on arm64 and improve the build coverage, remove the
>> dependency on ARCH_HIGHBANK.
>>
>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> Cc: Doug Thompson <dougthompson@xmission.com>
>> Cc: Robert Richter <rric@kernel.org>
>> Cc: linux-edac@vger.kernel.org
> 
> Rob, I will apply your patch with the changes we discussed if this is
> ok for you.

Thanks. It should be (ARM || ARM64 || COMPILE_TEST) rather than
ARM_MULTI_V7. The L2 ECC driver can be ARM only.

Rob

> 
> -Robert
> 
>> ---
>>  drivers/edac/Kconfig | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
>> index 878f090..fc8aaaf 100644
>> --- a/drivers/edac/Kconfig
>> +++ b/drivers/edac/Kconfig
>> @@ -328,14 +328,14 @@ config EDAC_TILE
>>  
>>  config EDAC_HIGHBANK_MC
>>  	tristate "Highbank Memory Controller"
>> -	depends on EDAC_MM_EDAC && ARCH_HIGHBANK
>> +	depends on EDAC_MM_EDAC
>>  	help
>>  	  Support for error detection and correction on the
>>  	  Calxeda Highbank memory controller.
>>  
>>  config EDAC_HIGHBANK_L2
>>  	tristate "Highbank L2 Cache"
>> -	depends on EDAC_MM_EDAC && ARCH_HIGHBANK
>> +	depends on EDAC_MM_EDAC
>>  	help
>>  	  Support for error detection and correction on the
>>  	  Calxeda Highbank memory controller.
>> -- 
>> 1.8.1.2
>>

