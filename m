Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaHKH7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 03:59:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34204 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbaHKH7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 03:59:34 -0400
Message-ID: <53E877BA.6040705@ti.com>
Date: Mon, 11 Aug 2014 10:58:50 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: <nsekhar@ti.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH] ARM: edma: Fix configuration parsing for SoCs with multiple
 eDMA3 CC
References: <1407155216-20267-1-git-send-email-peter.ujfalusi@ti.com> <20140805163229.GZ8181@intel.com>
In-Reply-To: <20140805163229.GZ8181@intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 07:32 PM, Vinod Koul wrote:
> On Mon, Aug 04, 2014 at 03:26:56PM +0300, Peter Ujfalusi wrote:
>> The edma_setup_from_hw() should know about the CC number when parsing the
>> CCCFG register - when it reads the register to be precise. The base
>> addresses for CCs stored in an array and we need to provide the correct id
>> to edma_read() in order to read the correct register.
> 
> Just an othognal question:
> 
> I still see lot of code for edma in arm/. What is the plan to re/move that
> to dma/

Yes, there's still a big split. The code under arch/arm/common/ provides still
the 'legacy' edma API. This is still used by audio
sound/soc/davinci/davinci-pcm for older daVinci devices (AM335x. AM43xx uses
the edma-pcm).

And it is not that simple to deprecate davinci-pcm: it can use so called
ping-pong mode for audio data transfer. This mode is not possible via
dmaengine AFAIK.
I'm going to check if edma-pcm would work fine instead of the ping-pong mode.
If it does I can remove davinci-pcm and we can start cleaning up the edma code.

-- 
Péter
