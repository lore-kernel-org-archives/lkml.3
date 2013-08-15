Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab3HOHDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:03:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53255 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab3HOHDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:03:39 -0400
Message-ID: <520C7D13.8060900@ti.com>
Date: Thu, 15 Aug 2013 02:02:43 -0500
From: Joel Fernandes <joelf@ti.com>
Reply-To: <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Greer <mgreer@animalcreek.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 00/10] crypto: omap-aes: DMA and PIO mode improvements
References: <1376521969-16807-1-git-send-email-joelf@ti.com> <520C1327.8090607@ti.com> <520C6E0A.8030505@samsung.com>
In-Reply-To: <520C6E0A.8030505@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2013 12:58 AM, Dmitry Kasatkin wrote:
> On 15/08/13 02:30, Joel Fernandes wrote:
>> On 08/14/2013 06:12 PM, Joel Fernandes wrote:
>>> This patch series is a rewrite of the DMA portion of omap-aes driver
>>> and also adds support for PIO mode. Both these modes, give better
>>> performance than before.
>>>
>>> Earlier, only a single SG was used for DMA purpose, and the SG-list
>>> passed from the crypto layer was being copied and DMA'd one entry at
>>> a time. This turns out to be quite inefficient, so we replace it with
>>> much simpler code that directly passes the SG-list from crypto to the
>>> DMA layer.
>>>
>>> We also add PIO mode support to the driver, and switch to PIO mode
>>> whenever the DMA channel allocation is not available. This is only for
>>> OMAP4 platform will work on any platform on which IRQ information is
>>> populated.
>>>
>>> Tests performed on am33xx and omap4 SoCs , notice the 50% perf improvement
>> Just correcting, this is more like 35% not 50% when using DMA.
> 
> Hmm :)
> 
> 1766/1460 = ~20%

Yes sorry, I messed the cover letter up. If I resend the series again,
I'll update this number.

On OMAP4 though, I saw 2800 ops/sec vs 1800 ops/sec which is around 50%
so it depends on SoC and DMA controller. OMAP4 uses SDMA while AM335x
uses EDMA.

Also with very large blocks, this improvement will be much higher as we
will not be doing all the intermediate copy but I haven't tested with
such large blocks.

Thanks,

-Joel

