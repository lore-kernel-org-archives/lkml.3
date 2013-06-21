Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab3FUBh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 21:37:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55952 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758313Ab3FUBh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 21:37:57 -0400
Date: Thu, 20 Jun 2013 18:37:56 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rohit Vaswani <rvaswani@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joerg Roedel <joro@8bytes.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: [PATCH 00/11] MSM DT based multi-platform support
Message-ID: <20130621013756.GF6300@codeaurora.org>
References: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18, Stephen Boyd wrote:
> This patchset allows me to compile and run the DT based MSM
> platforms in the multi-platform ARM kernel. This is built on
> top of a couple patches I've sent out already (specifically
> the debug_ll patch series and the clocksource_of conversion)
> as well a patch from Rohit that didn't seem to make it into 
> MSM's for-next branch.
> 
> There is one problem though, the last two patches cause compile
> failures if you turn on MSM's sdcc or USB_OTG driver. It seems
> that the sdcc driver depends on the clk_reset() API and the custom
> DMA interface provided by mach layers. And the USB_OTG driver depends
> on clk_reset.
> 
> The simplest solution is to make these two drivers depend on the
> non-dt based MSM support so that they can't be compiled in the
> multi-platform config. Otherwise, we'll need to replace the clk_reset()
> calls with the new reset controller API, but doing that would
> require us to convert all MSM platforms over to devicetree or
> we'll need to add support to the reset controller API for non-DT based
> controllers. Even with that, the sdcc driver uses custom DMA things
> so we may need to put that all behind some #ifdef.
> 
> Patches are based on David Brown's for-next tree:

David, can you pick up all the patches in this series not marked
RFC and send them off to arm-soc? Most of them have been on the
list already.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
