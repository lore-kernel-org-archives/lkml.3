Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966993Ab3DRLGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 07:06:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63407 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965772Ab3DRLGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 07:06:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 24/32] dmaengine: ste_dma40: Supply full Device Tree parsing support
Date: Thu, 18 Apr 2013 13:06:34 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org> <1366279934-30761-25-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1366279934-30761-25-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304181306.34835.arnd@arndb.de>
X-Provags-ID: V02:K0:S3sgGG7iedz4itWiImxePTrjy0hw8Uvw03WbjGywyfF
 VACeh1ypHm7MIUIeNDphTj1K78ltlLPchRB/rNj3HAFmKa33R4
 H0SPsgZo98GPy5gHnbH70zrrEPjRg9roJffoBU0RLHV39dsqAo
 8I4OgjeRHvtnQGYPa0CF4t2WJQf66fXPA8p2PpdElMpOisaDnB
 JrwFvbNcq9EHDbrXVD6qCTKnVKD3vq7tq3C47rrxk4DjIyIHy5
 BoBLOZLMzyjJwmbbiTYU7lOrPir4BT0y7NOqWlDYyHDyyoVkVJ
 AxQIdRVv5tHMFwYZeewhdM2uQaJ1m00tgJlBRJDFmfN7QZkJdk
 keiHETQQgG/tjNkF3OZ0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Lee Jones wrote:
> Using the new DMA DT bindings and API, we can register the DMA40 driver
> as Device Tree capable. Now, when a client attempts to allocate a
> channel using the DMA DT bindings via its own node, we are able to parse
> the request and allocate a channel in the correct manor.

s/manor/manner/ ?

> +Optional properties:
> +- interrupt-parent: Should be the phandle for the interrupt controller
> +  that services interrupts for this device

I would not bother listing the interrupt-parent.

> +Clients
> +Required properties:
> +- dmas: Comma seperated list of dma channel requests
> +- dma-names: Names of the aforementioned requested channels
> +
> +Each dmas request consists of 4 cells:
> +  1. A phandle pointing to the DMA controller
> +  2. The DMA request line number (only when 'use fixed channel' is set)
> +  3. Device Type
> +  4. A 32bit mask specifying; mode, direction and endianess [NB: This list will grow]
> +        bits 1-2: Mode:
> +          00: Logical
> +          01: Physical
> +          10: Operation
> +          11: Undefined - will most likely return an error

The statement "will most likely return an error" is not very
specification-like. ;-) Maybe better call it "reserved".

What is actually an "Operation" channel? Do we need it for slaves?


> +        bits 3-4: Direction:
> +          00: Mem to Mem
> +          01: Mem to Dev
> +          10: Dev to Mem
> +          11: Dev to Dev

For slave channels, we only need mem-to-dev and dev-to-mem, so I would
use only one bit here.

> +        bit 5: Endianess:
> +           0: Little endian
> +           1: Big endian
> +        bit 6: Use fixed channel:
> +           0: Use automatic channel selection
> +           1: Use DMA request line number

I think you have mixed up the "device type" and "request line number".

The request line is what identifies the slave device (which you call
the device type), and I would put that number first.

	Arnd

