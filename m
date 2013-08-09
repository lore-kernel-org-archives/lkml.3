Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967371Ab3HILfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 07:35:16 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:40709 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab3HILfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:35:14 -0400
Message-ID: <5204D3ED.70504@linaro.org>
Date: Fri, 09 Aug 2013 17:05:09 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Russell King <rmk+kernel@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH RFC 46/51] ARM: DMA-API: better handing of DMA masks for
 coherent allocations
References: <20130801213420.GL23006@n2100.arm.linux.org.uk> <E1V51EE-0006uO-C2@rmk-PC.arm.linux.org.uk>
In-Reply-To: <E1V51EE-0006uO-C2@rmk-PC.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 03:50 AM, Russell King wrote:
> We need to start treating DMA masks as something which is specific to
> the bus that the device resides on, otherwise we're going to hit all
> sorts of nasty issues with LPAE and 32-bit DMA controllers in >32-bit
> systems, where memory is offset from PFN 0.
> 
> In order to start doing this, we convert the DMA mask to a PFN using
> the device specific dma_to_pfn() macro.  This is the reverse of the
> pfn_to_dma() macro which is used to get the DMA address for the device.
> 
> This gives us a PFN mask, which we can then check against the PFN
> limit of the DMA zone.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  arch/arm/mm/dma-mapping.c |   49 ++++++++++++++++++++++++++++++++++++++++----
>  arch/arm/mm/init.c        |    2 +
>  arch/arm/mm/mm.h          |    2 +
>  3 files changed, 48 insertions(+), 5 deletions(-)
> 

Tested on Arndale board with ARM_LPAE enabled.

Tested-by: Tushar Behera <tushar.behera@linaro.org>

-- 
Tushar Behera
