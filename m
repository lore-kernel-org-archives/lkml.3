Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab3GCIPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 04:15:34 -0400
Received: from nasmtp02.atmel.com ([204.2.163.16]:46457 "EHLO
	nasmtp02.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab3GCINu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 04:13:50 -0400
Message-ID: <51D3DD28.8050900@atmel.com>
Date: Wed, 3 Jul 2013 16:13:28 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Mark Brown <broonie@kernel.org>, <alsa-devel@alsa-project.org>,
        <richard.genoud@gmail.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        <linux-kernel@vger.kernel.org>, <linux-sound@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [alsa-devel] [PATCH 2/2] ASoC: atmel-pcm: use generic dmaengine
 framework
References: <1372755849-19546-1-git-send-email-voice.shen@atmel.com> <1372755849-19546-3-git-send-email-voice.shen@atmel.com> <51D2F306.7040603@metafoo.de> <51D37F87.2010008@atmel.com> <51D3D482.1050100@metafoo.de> <51D3D969.1060308@atmel.com> <51D3DBE8.4090407@metafoo.de>
In-Reply-To: <51D3DBE8.4090407@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

On 7/3/2013 16:08, Lars-Peter Clausen wrote:
> On 07/03/2013 09:57 AM, Bo Shen wrote:
>> Hi Lars,
>>
>> On 7/3/2013 15:36, Lars-Peter Clausen wrote:
>>>>>> +        slave_config->dst_addr = (dma_addr_t)ssc->phybase + SSC_THR;
>>>>>>> [...]
>>>>>>>>> +        slave_config->src_addr = (dma_addr_t)ssc->phybase + SSC_RHR;
>>>>>>>
>>>>>>> Change the type of phybase to dma_addr_t
>>>>>
>>>>> It should be:
>>>>> slave_config->dst_addr = (dma_addr_t)(ssc->phybase + SSC_THR);
>>>>> slave_config->src_addr = (dma_addr_t)(ssc->phybase + SSC_RHR);
>>> The type of phybase in the ssc_device struct should be changed from
>>> resource_size_t to dma_addr_t.
>>
>> Actually, the phybase in ssc_device structure is resource_size_t which used to
>> access the ssc device register.
>> Here, we use ssc register as dma source address or destination address, so we
>> convert it to dma_addr_t type. So, not need to change, am I right?
>
> Isn't 'regs' used to access the registers? As far as I can see phybase is only
> used in the audio DMA driver.

Thanks for point out this. I will change the phybase type from 
resource_size_t to dma_addr_t.

> - Lars
>

Best Regards,
Bo Shen
