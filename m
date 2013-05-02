Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3EBIf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 04:35:28 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:58717 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab3EBIfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 04:35:23 -0400
Message-ID: <51822547.20605@free-electrons.com>
Date: Thu, 02 May 2013 10:35:19 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mxs: icoll: Add function to register an interrupt as
 FIQ source
References: <1367243917-5177-1-git-send-email-maxime.ripard@free-electrons.com> <20130502023858.GD3442@S2101-09.ap.freescale.net>
In-Reply-To: <20130502023858.GD3442@S2101-09.ap.freescale.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

Le 02/05/2013 04:39, Shawn Guo a écrit :
> On Mon, Apr 29, 2013 at 03:58:37PM +0200, Maxime Ripard wrote:
>> MXS, unlike other ARM platforms,
> 
> How are other ARM platforms handling that?

Just like that. You can look at mxc_set_irq_fiq in
arch/arm/mach-imx/irq-common.c or s3c24xx_set_fiq in
arch/arm/mach-s3c24xx/irq.c

I've also thought about declaring a IRQ type and using the .irq_set_type
to register an interrupt as a FIQ source, but since FIQ are
ARM-specific, it's probably a bad idea.

>> has no way to make a FIQ from an
>> interrupt from a driver, without poking directly into the icoll.
>>
>> Add an exported function to do this.
>>
>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>> ---
>>  arch/arm/mach-mxs/icoll.c | 11 +++++++++++
> 
> This will become drivers/irqchip/irq-mxs.c after the merge window.

Ok, I'll rebase and repost then.

Thanks,
Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
