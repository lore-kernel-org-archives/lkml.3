Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab3JNPGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:06:21 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:48560 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab3JNPGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:06:18 -0400
Message-ID: <525C0820.7000601@mm-sol.com>
Date: Mon, 14 Oct 2013 18:05:04 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] hwrng: msm: Add PRNG support for MSM SoC's
References: <1381504601-23773-1-git-send-email-svarbanov@mm-sol.com> <1381504601-23773-3-git-send-email-svarbanov@mm-sol.com> <20131011203701.GC13139@codeaurora.org>
In-Reply-To: <20131011203701.GC13139@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Thanks for the review.

On 10/11/2013 11:37 PM, Stephen Boyd wrote:
> On 10/11, Stanimir Varbanov wrote:
>> This adds a driver for hardware random number generator present
>> on Qualcomm MSM SoC's.
>>
>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
>> ---
> 
> Just nitpicks.
> 
>> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
>> index 0aa9d91daef5..d902330cef43 100644
>> --- a/drivers/char/hw_random/Kconfig
>> +++ b/drivers/char/hw_random/Kconfig
>> @@ -314,3 +314,15 @@ config HW_RANDOM_TPM
>>  	  module will be called tpm-rng.
>>  
>>  	  If unsure, say Y.
>> +
>> +config HW_RANDOM_MSM
>> +        tristate "Qualcomm MSM Random Number Generator support"
>> +        depends on HW_RANDOM && ARCH_MSM && HAVE_CLK
> 
> It should be fine to drop HAVE_CLK here because ARCH_MSM always
> selects COMMON_CLK which indirectly selects HAVE_CLK.

It is leftover, I'll remove HAVE_CLK dependency.

> 
>> +        ---help---
>> +          This driver provides kernel-side support for the Random Number
>> +          Generator hardware found on Qualcomm MSM SoCs.
>> +
>> +          To compile this driver as a module, choose M here. the
>> +          module will be called msm-rng.
>> +
>> +          If unsure, say Y.
>> diff --git a/drivers/char/hw_random/msm-rng.c b/drivers/char/hw_random/msm-rng.c
>> new file mode 100644
>> index 000000000000..e219e94d02c1
>> --- /dev/null
>> +++ b/drivers/char/hw_random/msm-rng.c
>> @@ -0,0 +1,195 @@
>> +#include <linux/clk.h>
>> +#include <linux/hw_random.h>
>> +#include <linux/io.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/platform_device.h>
> 
> +#include <linux/err.h> for -ENOMEM usage.

OK

> 
>> +
>> +/* Device specific register offsets */
>> +#define PRNG_DATA_OUT		0x0000
>> +#define PRNG_STATUS		0x0004
>> +#define PRNG_LFSR_CFG		0x0100
>> +#define PRNG_CONFIG		0x0104
>> +
> [snip]
>> +
>> +MODULE_AUTHOR("The Linux Foundation");
>> +MODULE_DESCRIPTION("Qualcomm MSM random number generator driver");
>> +MODULE_LICENSE("GPL v2");
> 
> MODULE_ALIAS perhaps?

OK, I will add it.

regards,
Stan

