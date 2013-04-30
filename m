Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933757Ab3D3UnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 16:43:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59734 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933412Ab3D3UnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 16:43:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/5] dmaengine: ste_dma40: Allow memcpy channels to be configured from DT
Date: Tue, 30 Apr 2013 22:42:23 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
References: <1367336497-10650-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1367336497-10650-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304302242.24002.arnd@arndb.de>
X-Provags-ID: V02:K0:WFnMqESsX59GC3Yeo5J2OFjE6OZ4o1F7qEUZDMvq1Pn
 7tXQIo16KbW3inAc78MpAvUj1xP/dZ0gDrGYqauiZKD4lnbaVF
 2D99ChBctXqqYigFW4lgrkqPU0YZHvTfTfxLLBkFIHjSnQ2pKY
 62MSrRdJYPSpDIE2PM3ty9Z/8ZHDcTso5fRRY39T2rlrjWEND8
 ThfnN46pS1JlOwY68VjRwber9nnneN+EixFZRS1SXmNaslsX6H
 G8aNGy+Ymrh6jdCL0pKgLiCF0GhOlXaykdmYbUPzVGAAvVH2Fz
 sc0g+OKRHFJeOdxhWv4R4JACl8Qn63cawRsMesMHLS7NiQksRv
 dA5kzPbM5T9l8PZNR9uE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 April 2013, Lee Jones wrote:
> @@ -6,6 +6,8 @@ Required properties:
>  - reg-names: Names of the above areas to use during resource look-up
>  - interrupt: Should contain the DMAC interrupt number
>  - #dma-cells: must be <3>
> +- memcpy-channels: Channels to be used for memcpy
> +- memcpy-num-chans: Number of channels to be used for memcpy
>  
>  Optional properties:
>  - dma-channels: Number of channels supported by hardware - if not present
> @@ -21,6 +23,8 @@ Example:
>                 interrupts = <0 25 0x4>;
>  
>                 #dma-cells = <2>;
> +               memcpy-channels  = <56, 57, 58, 59, 60>;
> +               memcpy-num-chans = <5>;
>                 dma-channels = <8>;
>         };
>  

I think you should remove the memcpy-num-chans property and instead evaluate the
length of the memcpy-channels property. Aside from this, it looks fine.

	Arnd
