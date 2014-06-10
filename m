Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaFJKKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 06:10:33 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:52371 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751611AbaFJKKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 06:10:31 -0400
Date: Tue, 10 Jun 2014 11:10:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: debug: fix broken DEBUG_LL_INCLUDE for multi
	platform
Message-ID: <20140610101021.GX23430@n2100.arm.linux.org.uk>
References: <1402394236-14778-1-git-send-email-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402394236-14778-1-git-send-email-srinivas.kandagatla@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 10:57:16AM +0100, Srinivas Kandagatla wrote:
> On multi_v7_defconfig using def_bool in Kconfig can override the selection
> made as part of DEBUG_LL. This is because def_bool will set the config to true
> if the expression evaluates to true, which is what was happening in
> multi_v7_defconfig. ARCH_SPEAR13XX selects DEBUG_UART_PL01X overiding any
> previous DEBUG_LL selections.
> 
> Making the def_bool to bool and depends made sense in this case, and
> fixes the issue too.

NAK.

1. you haven't tested this - if you select DEBUG_BCM2835 in the choice,
   it will select DEBUG_UART_PL01X, which, with your patch, will not
   have its new dependencies satisfied.

2. there is nothing to select this debug option on the platforms which
   you make it depend upon.

The real solution here is to convert these (and the other) remaining
platforms to the choice mechanism.  Same for the 8250 one.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
