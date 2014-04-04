Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaDDOlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:41:42 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50471 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753010AbaDDOlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:41:40 -0400
Date: Fri, 4 Apr 2014 15:41:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Subject: Re: [PATCH] arm: Fix DEBUG_LL for multi-platform kernels (without
	PL01X)
Message-ID: <20140404144108.GD7528@n2100.arm.linux.org.uk>
References: <1396610269-11580-1-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396610269-11580-1-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 12:17:49PM +0100, Daniel Thompson wrote:
> When building a multi_v7_defconfig kernel it is not possible to configure
> DEBUG_LL to use any serial device except a ARM Primecell PL01X, or more
> accurately and worse, it is possible to configure a different serial
> device but KConfig does not honour this request.
> 
> The happens because the multi-platform mode may include ARCH_SPEAR13XX
> and this forcibly engages DEBUG_UART_PL01X to provide some kind of
> compatibility with single platform builds (SPEAr supports both single and
> multi-platform). This in turn causes DEBUG_LL_INCLUDE to wedge at
> debug/pl01x.S.
> 
> Problem is fixed by only deploying the compatibility options for SPEAr
> when ARCH_MULTIPLATFORM is not set.

I think it's probably about time we killed the def_bool and just made
this a plain 'bool'.  The affected platforms should be using
DEBUG_LL_UART_PL01X by now.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
