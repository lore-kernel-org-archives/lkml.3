Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab3FRInw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:43:52 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:56457 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab3FRIns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:43:48 -0400
MIME-Version: 1.0
In-Reply-To: <20130618084017.GA7161@zurbaran>
References: <1371025182-31386-1-git-send-email-sachin.kamat@linaro.org>
	<20130618084017.GA7161@zurbaran>
Date: Tue, 18 Jun 2013 14:13:48 +0530
Message-ID: <CAK9yfHxUzMx13UXkfd1s5KNhKJ+MeKEQHU2rEMDDmOPpKvAFKg@mail.gmail.com>
Subject: Re: [PATCH Resend 1/1] mfd: davinci_voicecodec: Convert to use devm_* APIs
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, lee.jones@linaro.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On 18 June 2013 14:10, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Sachin,
>
> On Wed, Jun 12, 2013 at 01:49:42PM +0530, Sachin Kamat wrote:
>> devm_* APIs are device managed and make code simpler.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> Cc: Miguel Aguilar <miguel.aguilar@ridgerun.com>
>> ---
>> CC'd Lee Jones
>>
>> Patch is based on mfd-next tree and compile tested.
>> This driver gives following compilation error (not introduced by this patch):
>> drivers/mfd/davinci_voicecodec.c:86:3: error: implicit declaration
>> of function ‘io_v2p’ [-Werror=implicit-function-declaration]
>>    (dma_addr_t)(io_v2p(davinci_vc->base) + DAVINCI_VC_WFIFO);
>>
>> In order to test my changes I added the following to davinci_voicecodec.h file:
>> +#define IO_OFFSET      0xfd000000 /* Virtual IO = 0xfec00000 */
>> +#define io_v2p(va)     ((va) - IO_OFFSET)
>>
>> I am not sure if these changes are right fix for the above error.
> io_v2p is define in davinci's mach/hardware.h so I believe this is what
> you should include in davinci_voicecodec.h.

Thanks. That was only required for compile testing my patch.
Does the patch look good?


-- 
With warm regards,
Sachin
