Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935536Ab3DITJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:09:22 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37036 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761628Ab3DITJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:09:21 -0400
Date: Tue, 9 Apr 2013 20:09:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 5/8] dmaengine: ste_dma40: Ensure src and dst registers
 are configured correctly
Message-ID: <20130409190916.GF25316@gmail.com>
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org>
 <1365532783-27425-5-git-send-email-lee.jones@linaro.org>
 <201304092057.29684.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201304092057.29684.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Apr 2013, Arnd Bergmann wrote:

> On Tuesday 09 April 2013, Lee Jones wrote:
> > Confusingly d40_log_cfg() is used to set up the logical channel
> > configuration registers, but d40_phy_cfg() is used to configure
> > physical and logical registers, so it should be called in both
> > cases. It is the function call's final attribute which determines
> > whether it's a physical or logical channel, not whether the
> > function is called or not.
> 
> So how did it ever work? Your description sounds like it was
> broken all along, but I would assume that someone tested the code.

>From what I can see, not.

My best guess is that the 'test' was to see if the configuration
changed using the debug print at the end of the function. I don't see
how else the configuration can be written to hardware.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
