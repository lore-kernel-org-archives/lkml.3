Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851AbaD2ICt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:02:49 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:38315 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884AbaD2ICr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:02:47 -0400
Date: Tue, 29 Apr 2014 09:02:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: micky_ching@realsil.com.cn
Cc: chris@printf.net, ulf.hansson@linaro.org, sameo@linux.intel.com,
        gregkh@linuxfoundation.org, dan.carpenter@oracle.com,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, rogerable@realtek.com,
        wei_wang@realsil.com.cn
Subject: Re: [PATCH 0/2] mmc: rtsx: revert support for mmc async request
Message-ID: <20140429080240.GC29462@lee--X1>
References: <cover.1398735435.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1398735435.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Micky Ching <micky_ching@realsil.com.cn>
> 
> The commit <mmc: rtsx: add support for pre_req and post_req> have some problem,
> using mutex_unlock() in atomic context, spinlock deadlock, it is hard to fix
> these problem, and better to use a new method. So just remove it.
> 
> The commit <mmc: rtsx: modify error handle and remove smatch warnings> depends
> on the previous patch. And mainly fix some problem for the previous patch. So
> need remove.
> 
> Micky Ching (2):
>   mmc: rtsx: Revert "mmc: rtsx: modify error handle and remove smatch
>     warnings"
>   mmc: rtsx: Revert "mmc: rtsx: add support for pre_req and post_req"
> 
>  drivers/mfd/rtsx_pcr.c            |  132 ++++-------
>  drivers/mmc/host/rtsx_pci_sdmmc.c |  459 +++++++------------------------------
>  include/linux/mfd/rtsx_common.h   |    1 -
>  include/linux/mfd/rtsx_pci.h      |    6 -
>  4 files changed, 124 insertions(+), 474 deletions(-)

Just to clarify, what commit did you base these changes on? Have you
tested to ensure everything works as it should with these two
reversions?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
