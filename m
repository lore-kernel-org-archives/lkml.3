Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760562Ab3BHTdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:33:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:9678 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760357Ab3BHTdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:33:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,630,1355126400"; 
   d="scan'208";a="284680581"
Date: Fri, 8 Feb 2013 20:33:03 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: wei_wang@realsil.com.cn
Cc: cjb@laptop.org, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, gregkh@linuxfoundation.org,
        adam.lee@canonical.com, rogerable@realtek.com
Subject: Re: [PATCH] mfd:rtsx: Fix issue that booting OS with SD card inserted
Message-ID: <20130208193303.GD20996@sortiz-mobl>
References: <1360308268-6911-1-git-send-email-wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360308268-6911-1-git-send-email-wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

On Fri, Feb 08, 2013 at 03:24:27PM +0800, wei_wang@realsil.com.cn wrote:
> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> Realtek card reader supports both SD and MS card. According to the
> settings of rtsx MFD driver, SD host will be probed before MS host.
> If we boot/reboot Linux with SD card inserted, the resetting flow of SD
> card will succeed, and the following resetting flow of MS is sure to fail.
> Then MS upper-level driver will ask rtsx driver to turn power off. This
> request leads to the result that the following SD commands fail and SD card
> can't be accessed again.
> 
> In this commit, Realtek's SD and MS host driver will check whether the card
> that upper driver requesting is the one existing in the slot. If not, Realtek's
> host driver will refuse the operation to make sure the exlusive accessing
> at the same time.
> 
> Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
> ---
>  drivers/memstick/host/rtsx_pci_ms.c |    7 +++++++
>  drivers/mfd/rtsx_pcr.c              |   30 ++++++++++++++++++++++++++++++
>  drivers/mmc/host/rtsx_pci_sdmmc.c   |   18 ++++++++++++++++++
>  include/linux/mfd/rtsx_pci.h        |    2 ++
>  4 files changed, 57 insertions(+)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
