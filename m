Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbbANPXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:23:12 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:50415 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbbANPXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:23:10 -0500
MIME-Version: 1.0
In-Reply-To: <2760189.hGZZQd3ELS@wuerfel>
References: <2760189.hGZZQd3ELS@wuerfel>
Date: Wed, 14 Jan 2015 16:23:09 +0100
Message-ID: <CACRpkdYTY4-4zqgkXoKqjizhj_nb_QhTmnT15EvewqOwkMBT-w@mail.gmail.com>
Subject: Re: [PATCH] dma: coh901318: fix function return types build warnings
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 10:17 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> A recent patch that removed coh901318_control() replaced it
> with a number of pointers to existing functions, but those
> unfortunately have the wrong return  type and need to be
> changed to return an 'int' with an error value rather than
> a 'void' to avoid these build warnings:
>
> drivers/dma/coh901318.c:2697:32: warning: assignment from incompatible pointer type
>   base->dma_slave.device_config = coh901318_dma_set_runtimeconfig;
>                                 ^
> drivers/dma/coh901318.c:2698:31: warning: assignment from incompatible pointer type
>   base->dma_slave.device_pause = coh901318_pause;
>                                ^
> drivers/dma/coh901318.c:2699:32: warning: assignment from incompatible pointer type
>   base->dma_slave.device_resume = coh901318_resume
>
> The coh901318_base_init function has the correct return type
> already, but needs to be marked 'static' to avoid a sparse
> warning about a missing declaration.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 6782af118b6c ("dmaengine: coh901318: Split device_control")

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
