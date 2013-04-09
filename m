Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935429Ab3DIHGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:06:06 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:64138 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760753Ab3DIHGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:06:04 -0400
Date: Tue, 9 Apr 2013 08:05:58 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 1/5] ARM: ux500: Move DMA40 platform data includes file
 out to include/
Message-ID: <20130409070558.GG3084@gmail.com>
References: <1365434591-21569-1-git-send-email-lee.jones@linaro.org>
 <201304081817.42031.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201304081817.42031.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Apr 2013, Arnd Bergmann wrote:

> On Monday 08 April 2013, Lee Jones wrote:
> > The pin names for DB8500 based platforms need to be moved out of
> > ux500 platform data and into the new proper location in include/
> > linux/platform_data/. This way we an reference them from other
> > external locations, such as the main DMA50 driver(s).
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Hmm, not sure about this one. The slave numbers are not really platform_data
> and I think they should not be exposed to drivers. It makes sense to
> keep the numbers for the memcpy channels in the driver itself as they
> are hardwired in the driver, but the slave channels should stay in the
> platform I think.

Just looking at this again now. So you're right in that the main
reason for moving these out of platform code and into the system-wide
platform data area is for the memcpy channels. However, I'd prefer to
keep the channel allocation enum fully contiguous rather than
splitting them out.

The channels are only exposed to the one external driver which
includes them, and that's the D40 driver.

How against this move are you?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
