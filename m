Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab3DLNuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 09:50:13 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:33416 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab3DLNuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 09:50:12 -0400
MIME-Version: 1.0
In-Reply-To: <1365532783-27425-3-git-send-email-lee.jones@linaro.org>
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org> <1365532783-27425-3-git-send-email-lee.jones@linaro.org>
From: Rabin Vincent <rabin@rab.in>
Date: Fri, 12 Apr 2013 15:49:31 +0200
X-Google-Sender-Auth: aGnVfVJTzehhny2rpCo0e3G18SI
Message-ID: <CAH+eYFB_fYmCjvh5PXKRhd-FnaWfeu+LtH+q3VywhCk-PYhHVQ@mail.gmail.com>
Subject: Re: [PATCH 3/8] dmaengine: ste_dma40: Actually write the runtime
 configuration to registers
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/9 Lee Jones <lee.jones@linaro.org>:
> Someone has spent a fair amount of effort writing a runtime configuration
> changing algorithm for DMA clients. However, the config appears to never
> actually make it to hardware. In order for the configuration to take hold
> we need to issue a d40_config_write(), as this is the routine which writes
> it into the hardware's registers.

No, it's not.  This function is only for initial configuration which
should only be written when the channel is allocated.  In fact, by
calling it here in runtime_config, you are introducing a serious bug:
other logical channels on the same physical channel will stop because of
the SSLNK/SDLNK of the physical channel being zeroed.

The runtime config already makes it the hardware in the existing code,
via d40_*_cfg().
