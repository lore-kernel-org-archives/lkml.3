Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab3D2N2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 09:28:39 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:5482 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab3D2N2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 09:28:37 -0400
Message-ID: <517E7589.5030205@atmel.com>
Date: Mon, 29 Apr 2013 15:28:41 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: <ludovic.desroches@atmel.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mmc@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/6] at_hdmac: move to generic DMA binding
References: <1366362683-14496-1-git-send-email-ludovic.desroches@atmel.com> <1366362683-14496-2-git-send-email-ludovic.desroches@atmel.com> <51750F68.4040701@atmel.com> <20130423034407.GY24632@intel.com>
In-Reply-To: <20130423034407.GY24632@intel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2013 05:44 AM, Vinod Koul :
> On Mon, Apr 22, 2013 at 12:22:32PM +0200, Nicolas Ferre wrote:
>> On 04/19/2013 11:11 AM, ludovic.desroches@atmel.com :
>>> From: Ludovic Desroches <ludovic.desroches@atmel.com>
> 
>>> +#ifdef CONFIG_OF
>>> +static bool at_dma_filter(struct dma_chan *chan, void *slave)
> this is not defined for else case here. Also this could be CONFIG_DMA_OF...?

in fact, at_dma_filter() is only used in corresponding
dma_request_channel() in at_dma_xlate() function just below and only in
case of CONFIG_OF.
As the at_dma_xlate() is an empty function in !CONFIG_OF case, the
at_dma_filter() is not needed.

For the use of CONFIG_OF and not CONFIG_OF_DMA, it is simply because it
it the directive that we currently use in drivers when we have to put
the device tree condition around a piece of code. It is quite a common
pattern I think.
Moreover, it is what is used in dw_dmac.c and mv_xor.c...

>>> +{
>>> +	struct at_dma_slave *atslave = slave;
>>> +
>>> +	if (atslave->dma_dev == chan->device->dev) {
>>> +		chan->private = atslave;
>>> +		return true;
>>> +	} else {
>>> +		return false;
>>> +	}
>>> +}
> 
> --
> ~Vinod

Best regards,
-- 
Nicolas Ferre
