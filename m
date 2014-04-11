Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbaDKUwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 16:52:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55176 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbaDKUwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 16:52:12 -0400
Message-ID: <534855DF.2040309@ti.com>
Date: Fri, 11 Apr 2014 15:51:43 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: <dan.j.williams@intel.com>, <nsekhar@ti.com>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>
Subject: Re: [PATCH v2 03/14] dma: edma: Add support for DMA_PAUSE/RESUME
 operation
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com> <1396357575-30585-4-git-send-email-peter.ujfalusi@ti.com> <20140411164327.GD32284@intel.com>
In-Reply-To: <20140411164327.GD32284@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 11:43 AM, Vinod Koul wrote:
> On Tue, Apr 01, 2014 at 04:06:04PM +0300, Peter Ujfalusi wrote:
>> Pause/Resume can be used by the audio stack when the stream is paused/resumed
>> The edma platform code has support for this and the legacy audio stack used
>> this.
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> ---
>>  drivers/dma/edma.c | 28 ++++++++++++++++++++++++++++
>>  1 file changed, 28 insertions(+)
>>
>> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
>> index 2742867fd1e6..7891378a03f0 100644
>> --- a/drivers/dma/edma.c
>> +++ b/drivers/dma/edma.c
>> @@ -240,6 +240,26 @@ static int edma_slave_config(struct edma_chan *echan,
>>  	return 0;
>>  }
>>  
>> +static int edma_dma_pause(struct edma_chan *echan)
>> +{
>> +	/* Pause/Resume only allowed with cyclic mode */
>> +	if (!echan->edesc->cyclic)
>> +		return -EINVAL;
> why this artificial restriction? The driver can do pause even for non cyclic
> cases too? Yes the usage is in cyclic context but why should we limit any future
> work on this?
> 

We struggled with this, and we certainly we don't want pauses in
non-cyclic EDMA... we tried doing a "pause" and it was a disaster as the
events keep coming in and those can't be paused, and EDMA hardware wont
queue them during the pause, it'll just generate an error interrupt storm.

Thanks,
-Joel
