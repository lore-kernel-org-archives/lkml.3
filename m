Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143Ab3DYLOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:14:23 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:53979 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab3DYLOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:14:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130422101833.GI3432@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-18-git-send-email-lee.jones@linaro.org>
	<20130422093423.GD24632@intel.com>
	<20130422101833.GI3432@gmail.com>
Date: Thu, 25 Apr 2013 13:14:18 +0200
Message-ID: <CACRpkdbsH=vZxMcoeW+RJQsLaKAs_Lzx2pGpbT7fO_Hk90x6Gw@mail.gmail.com>
Subject: Re: [PATCH 17/32] dmaengine: ste_dma40: Remove redundant argument
 from d40_phy_cfg()
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 12:18 PM, Lee Jones <lee.jones@linaro.org> wrote:

>> > +   if ((cfg->dir ==  STEDMA40_PERIPH_TO_MEM) ||
>> > +       (cfg->dir == STEDMA40_PERIPH_TO_PERIPH)) {
>>
>> Why would you need your own direction defines, I see that there is not much
>> diff between these and what dmaengine defines, so perhpas you could use
>> those?
>
> I agree. I'll speak to the STE folk.

This is because the driver was written before the dmaengine had
the enum dma_transfer_direction.

A simple search-and-replace patch would do the trick...

Yours,
Linus Walleij
