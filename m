Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbaCMNks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 09:40:48 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42554 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbaCMNkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 09:40:45 -0400
Message-ID: <5321B535.5040802@ti.com>
Date: Thu, 13 Mar 2014 15:40:05 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "joelf@ti.com" <joelf@ti.com>, "Koul, Vinod" <vinod.koul@intel.com>,
        "nsekhar@ti.com" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jyri Sarha <jsarha@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Mark Brown <broonie@kernel.org>,
        "mporter@linaro.org" <mporter@linaro.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [alsa-devel] [PATCH 13/18] dma: edma: Print the direction value
 as well when it is not supported
References: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com> <1394702320-21743-14-git-send-email-peter.ujfalusi@ti.com> <1394715793.28803.240.camel@smile.fi.intel.com>
In-Reply-To: <1394715793.28803.240.camel@smile.fi.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 03:03 PM, Shevchenko, Andriy wrote:
> On Thu, 2014-03-13 at 11:18 +0200, Peter Ujfalusi wrote:
>> In case of not supported direction it is better to print the direction also.
>> It is unlikely, but in such an event it helps with the debugging.
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> ---
>>  drivers/dma/edma.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
>> index 47abaac7eb18..69dd4e3de67e 100644
>> --- a/drivers/dma/edma.c
>> +++ b/drivers/dma/edma.c
>> @@ -426,7 +426,7 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
>>  		dev_width = echan->cfg.dst_addr_width;
>>  		burst = echan->cfg.dst_maxburst;
>>  	} else {
>> -		dev_err(dev, "%s: bad direction?\n", __func__);
>> +		dev_err(dev, "%s: bad direction: %d\n", __func__, direction);
> 
> Is it possible to have direction less than zero? Maybe %u?

It is 'enum dma_transfer_direction direction'. %d should be fine.

> 
>>  		return NULL;
>>  	}
>>  
>> @@ -519,7 +519,7 @@ static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
>>  		dev_width = echan->cfg.dst_addr_width;
>>  		burst = echan->cfg.dst_maxburst;
>>  	} else {
>> -		dev_err(dev, "%s: bad direction?\n", __func__);
>> +		dev_err(dev, "%s: bad direction: %d\n", __func__, direction);
> 
> Ditto.
> 
>>  		return NULL;
>>  	}
>>  
> 
> 


-- 
Péter
