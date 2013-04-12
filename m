Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab3DLQNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 12:13:32 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46212 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3DLQNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 12:13:31 -0400
Date: Fri, 12 Apr 2013 17:13:25 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 3/8] dmaengine: ste_dma40: Actually write the runtime
 configuration to registers
Message-ID: <20130412161325.GB18459@gmail.com>
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org>
 <1365532783-27425-3-git-send-email-lee.jones@linaro.org>
 <CAH+eYFB_fYmCjvh5PXKRhd-FnaWfeu+LtH+q3VywhCk-PYhHVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH+eYFB_fYmCjvh5PXKRhd-FnaWfeu+LtH+q3VywhCk-PYhHVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Apr 2013, Rabin Vincent wrote:

> 2013/4/9 Lee Jones <lee.jones@linaro.org>:
> > Someone has spent a fair amount of effort writing a runtime configuration
> > changing algorithm for DMA clients. However, the config appears to never
> > actually make it to hardware. In order for the configuration to take hold
> > we need to issue a d40_config_write(), as this is the routine which writes
> > it into the hardware's registers.
> 
> No, it's not.  This function is only for initial configuration which
> should only be written when the channel is allocated.  In fact, by
> calling it here in runtime_config, you are introducing a serious bug:
> other logical channels on the same physical channel will stop because of
> the SSLNK/SDLNK of the physical channel being zeroed.
> 
> The runtime config already makes it the hardware in the existing code,
> via d40_*_cfg().

Ah, I see. I'll move it all back and investigate my bug further then.

Thanks for taking the time to write such a well written review.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
