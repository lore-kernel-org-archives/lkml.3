Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaHSKbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 06:31:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:4989 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbaHSKbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 06:31:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,893,1400050800"; 
   d="scan'208";a="560484929"
Message-ID: <53F32A8B.4070900@linux.intel.com>
Date: Tue, 19 Aug 2014 13:44:27 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: Linus <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio-lynxpoint: enable input sensing in resume
References: <1408444228-23733-1-git-send-email-mathias.nyman@linux.intel.com> <20140819102226.GM1660@lahna.fi.intel.com>
In-Reply-To: <20140819102226.GM1660@lahna.fi.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2014 01:22 PM, Mika Westerberg wrote:
> On Tue, Aug 19, 2014 at 01:30:28PM +0300, Mathias Nyman wrote:
>> It appears that input sensing bit might be reset during
>> suspend/resume. Set input sensing again for all requested gpios
>> in resume
>>
>> Tested-by: Jerome Blin <jerome.blin@intel.com>
>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>> ---
>>  drivers/gpio/gpio-lynxpoint.c | 24 ++++++++++++++++++++++++
>>  1 file changed, 24 insertions(+)
>>
>> diff --git a/drivers/gpio/gpio-lynxpoint.c b/drivers/gpio/gpio-lynxpoint.c
>> index ff9eb91..4165672 100644
>> --- a/drivers/gpio/gpio-lynxpoint.c
>> +++ b/drivers/gpio/gpio-lynxpoint.c
>> @@ -407,9 +407,33 @@ static int lp_gpio_runtime_resume(struct device *dev)
>>  	return 0;
>>  }
>>  
>> +static int lp_gpio_suspend(struct device *dev)
>> +{
>> +	return 0;
>> +}
> 
> If this function doesn't do anything why it needs to be defined here?
> 

I guess it doesn't, Added the suspend and resume functions as a pair, but only
resume turned out to do something,

I'll remove it.

-Mathias



