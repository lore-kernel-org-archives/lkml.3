Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab3IPLWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 07:22:30 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:54540 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306Ab3IPLW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 07:22:28 -0400
Date: Mon, 16 Sep 2013 12:22:24 +0100
From: Lee Jones <lee.jones@linaro.org>
To: wei_wang@realsil.com.cn
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com, micky_ching@realsil.com.cn
Subject: Re: [PATCH v4] mfd: rtsx: Modify rts5249_optimize_phy
Message-ID: <20130916112224.GB16984@lee--X1>
References: <1379065543-30421-1-git-send-email-wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1379065543-30421-1-git-send-email-wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Sep 2013, wei_wang@realsil.com.cn wrote:

> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> In some platforms, specially Thinkpad series, rts5249 won't be
> initialized properly. So we need adjust some phy parameters to
> improve the compatibility issue.
> 
> It is a little different between simulation and real chip. We have
> no idea about which configuration is better before tape-out. We set
> default settings according to simulation, but need to tune these
> parameters after getting the real chip.
> 
> I can't explain every change in detail here. The below information is
> just a rough description:
> 
> PHY_REG_REV: Disable internal clkreq_tx, enable rx_pwst
> PHY_BPCR: No change, just turn the magic number to macro definitions
> PHY_PCR: Change OOBS sensitivity, from 60mV to 90mV
> PHY_RCR2: Control charge-pump current automatically
> PHY_FLD4: Use TX cmu reference clock
> PHY_RDR: Change RXDSEL from 30nF to 1.9nF
> PHY_RCR1: Change the duration between adp_st and asserting cp_en from
> 0.32 us to 0.64us
> PHY_FLD3: Adjust internal timers
> PHY_TUNE: Fine tune the regulator12 output voltage
> 
> Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
> ---
>  drivers/mfd/rts5249.c        |   48 ++++++++++++++++++++++++++++++++++++--
>  include/linux/mfd/rtsx_pci.h |   53 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 99 insertions(+), 2 deletions(-)

Much better.

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
