Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab3HVMh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 08:37:57 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:62633 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab3HVMh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 08:37:56 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: linus.walleij@linaro.org, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] dma: ste_dma: Fix warning when CONFIG_ARM_LPAE=y
References: <1377131642-19494-1-git-send-email-festevam@gmail.com>
Date: Thu, 22 Aug 2013 05:37:52 -0700
In-Reply-To: <1377131642-19494-1-git-send-email-festevam@gmail.com> (Fabio
	Estevam's message of "Wed, 21 Aug 2013 21:34:02 -0300")
Message-ID: <87mwo9x5nj.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabio Estevam <festevam@gmail.com> writes:

> From: Fabio Estevam <fabio.estevam@freescale.com>
>
> When CONFIG_ARM_LPAE=y the following build warning are generated:
>
> drivers/dma/ste_dma40.c:3228:2: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' [-Wformat]
> drivers/dma/ste_dma40.c:3582:3: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' [-Wformat]
> drivers/dma/ste_dma40.c:3582:3: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'resource_size_t' [-Wformat]
> drivers/dma/ste_dma40.c:3593:5: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'resource_size_t' [-Wformat]
>
> According to Documentation/printk-formats.txt '%pa' can be used to properly 
> print 'resource_size_t'.
>
> Also, for printing memory region the '%pr' is more convenient.
>
> Reported-by: Kevin Hilman <khilman@linaro.org>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Kevin Hilman <khilman@linaro.org>

And I verified the compile problem is gone away with arm_v7_defconfig +
CONFIG_ARM_LPAE=y

Thanks for the fix!

Kevin
