Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbaIQNwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 09:52:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:64205 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287AbaIQNwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 09:52:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,540,1406617200"; 
   d="scan'208";a="478129540"
Message-ID: <54199240.7080705@intel.com>
Date: Wed, 17 Sep 2014 15:53:04 +0200
From: Loic Poulain <loic.poulain@intel.com>
Organization: Intel Corporation SAS - RCS Nanterre B 302 456 199 - 2 rue de
 Paris, 92196 Meudon Cedex, France 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mathias Nyman <mathias.nyman@linux.intel.com>,
        heikki.krogerus@linux.intel.com, mika.westerberg@intel.com,
        samuel.ortiz@intel.com
CC: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl: baytrail: Clear DIRECT_IRQ bit
References: <1410957035-13965-1-git-send-email-loic.poulain@intel.com> <54198A2D.30908@linux.intel.com>
In-Reply-To: <54198A2D.30908@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do you think a WARN necessary before clearing the bit?

Regards,
Loic

On 17/09/2014 15:18, Mathias Nyman wrote:
> On 09/17/2014 03:30 PM, Loic Poulain wrote:
>> Direct Irq En bit can be initialized to a bad value.
>> This bit has to be cleared for io access mode.
>>
>> Signed-off-by: Loic Poulain <loic.poulain@intel.com>
>> ---
>>   drivers/pinctrl/pinctrl-baytrail.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
>> index 975572e..94902f7 100644
>> --- a/drivers/pinctrl/pinctrl-baytrail.c
>> +++ b/drivers/pinctrl/pinctrl-baytrail.c
>> @@ -44,6 +44,7 @@
>>   
>>   /* BYT_CONF0_REG register bits */
>>   #define BYT_IODEN		BIT(31)
>> +#define BYT_DIRECT_IRQ		BIT(27)
>>   #define BYT_TRIG_NEG		BIT(26)
>>   #define BYT_TRIG_POS		BIT(25)
>>   #define BYT_TRIG_LVL		BIT(24)
>> @@ -232,7 +233,7 @@ static int byt_irq_type(struct irq_data *d, unsigned type)
>>   	/* For level trigges the BYT_TRIG_POS and BYT_TRIG_NEG bits
>>   	 * are used to indicate high and low level triggering
>>   	 */
>> -	value &= ~(BYT_TRIG_POS | BYT_TRIG_NEG | BYT_TRIG_LVL);
>> +	value &= ~(BYT_DIRECT_IRQ | BYT_TRIG_POS | BYT_TRIG_NEG | BYT_TRIG_LVL);
>>   
>>   	switch (type) {
>>   	case IRQ_TYPE_LEVEL_HIGH:
>>
> Just checked that there is a patch already upstream that warns if this bit is set.
> It defines BYT_DIRECT_IRQ_EN already, but doesn't clear the bit.
>
> commit ff998356b644ebe723127bd9eec6040b59a4a4f6
> Author: Eric Ernst <eric.ernst@linux.intel.com>
> Date:   Thu Jun 12 11:06:20 2014 -0700
>
>      pinctrl: baytrail: Warn if direct IRQ GPIO set to output
>
>
> Maybe adding a patch clearing the bit on top of that patch?
>
> And send that patch to Linus Walleij as well (added to cc)
>
> Thanks
> -Mathias

-- 
Intel Open Source Technology Center
http://oss.intel.com/

