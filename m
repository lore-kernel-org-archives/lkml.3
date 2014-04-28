Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbaD1Kx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:53:58 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:60893 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbaD1Kx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:53:56 -0400
Date: Mon, 28 Apr 2014 11:53:50 +0100
From: Lee Jones <lee.jones@linaro.org>
To: micky_ching@realsil.com.cn
Cc: chris@printf.net, ulf.hansson@linaro.org, sameo@linux.intel.com,
        gregkh@linuxfoundation.org, dan.carpenter@oracle.com,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, rogerable@realtek.com,
        wei_wang@realsil.com.cn
Subject: Re: [PATCH] mmc: rtsx: Revert "mmc: rtsx: add support for pre_req
 and post_req"
Message-ID: <20140428105350.GM21279@lee--X1>
References: <1398670584-26687-1-git-send-email-micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398670584-26687-1-git-send-email-micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Micky Ching <micky_ching@realsil.com.cn>
> 
> This reverts commit c42deffd5b53c9e583d83c7964854ede2f12410d.

Why was this patch even merged without an MFD Ack?

> commit <mmc: rtsx: add support for pre_req and post_req> did use
> mutex_unlock() in tasklet, but mutex_unlock() can't used in
> tasklet(atomic context). The driver need use mutex to avoid concurrency,
> so we can't use tasklet here, the patch need to be removed.
> 
> The spinlock host->lock and pcr->lock may deadlock, one way to solve the
> deadlock is remove host->lock in sd_isr_done_transfer(), but if using
> workqueue the we can avoid using the spinlock and also avoid the problem.
> 
> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> ---
>  drivers/mfd/rtsx_pcr.c            |  132 ++++--------
>  drivers/mmc/host/rtsx_pci_sdmmc.c |  418 ++++++-------------------------------
>  include/linux/mfd/rtsx_common.h   |    1 -
>  include/linux/mfd/rtsx_pci.h      |    6 -
>  4 files changed, 109 insertions(+), 448 deletions(-)

This patch should be sent to the -rcs as soon as possible:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
