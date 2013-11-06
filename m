Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab3KFQPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:15:31 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:63495 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3KFQPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:15:06 -0500
Message-ID: <527A6B08.5020302@gmail.com>
Date: Wed, 06 Nov 2013 10:15:04 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Robert Richter <rric@kernel.org>, linux-edac@vger.kernel.org
Subject: Re: [PATCH] edac, highbank: remove dependency on ARCH_HIGHBANK
References: <1383708352-19527-1-git-send-email-robherring2@gmail.com> <20131106142025.GB16072@x1.alien8.de>
In-Reply-To: <20131106142025.GB16072@x1.alien8.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 08:20 AM, Borislav Petkov wrote:
> On Tue, Nov 05, 2013 at 09:25:52PM -0600, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> In order to enable on arm64 and improve the build coverage, remove the
>> dependency on ARCH_HIGHBANK.
>>
>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> Cc: Doug Thompson <dougthompson@xmission.com>
>> Cc: Robert Richter <rric@kernel.org>
>> Cc: linux-edac@vger.kernel.org
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
> 
> Please, no, this'll get enabled on other arches where this driver is
> simply N/A. It should only depend on the ARM arches it supports.

Other maintainers disagree because it reduces build coverage. Having
done some cross arch clean-up, I have to agree with that position.
Iterating builds over different arches is bad enough, but iterating over
all configs for each arch is a pain. It would be nice to have a uniform
policy here.

Rob


