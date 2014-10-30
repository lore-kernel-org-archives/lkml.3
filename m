Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbaJ3Jvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 05:51:45 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:6370 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454AbaJ3Jvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 05:51:44 -0400
Message-ID: <54520A2D.5080304@imgtec.com>
Date: Thu, 30 Oct 2014 09:51:41 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Markos Chandras <Markos.Chandras@imgtec.com>,
        Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        <linux-mips@linux-mips.org>, <nbd@openwrt.org>, <yanh@lemote.com>,
        <linux-kernel@vger.kernel.org>, <ralf@linux-mips.org>,
        <alex.smith@imgtec.com>, <taohl@lemote.com>, <chenhc@lemote.com>,
        <blogic@openwrt.org>
Subject: Re: [PATCH] MIPS: DMA: fix coherent alloc in non-coherent systems
References: <20141030014753.13189.48344.stgit@linux-yegoshin> <54520969.8030900@imgtec.com>
In-Reply-To: <54520969.8030900@imgtec.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markos,

On 30/10/14 09:48, Markos Chandras wrote:
>> diff --git a/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h b/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
>> index f9f4486..fe0b465 100644
>> --- a/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
>> +++ b/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
>> @@ -52,7 +52,7 @@ static inline int plat_dma_supported(struct device *dev, u64 mask)
>>  	return 0;
>>  }
>>  
>> -static inline int plat_device_is_coherent(struct device *dev)
>> +static inline int plat_device_is_coherent(const struct device *dev)
> 
> Why adding const here?
> 

<snip>

> Is it just a matter of consistence with the rest of the interfaces? Do
> you need to move these into a separate patch since they don't quite fit
> here.

See the new new call to plat_device_is_coherent(), which passes dev,
which is const.

Cheers
James
