Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbaEHHyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 03:54:07 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:55073 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbaEHHyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 03:54:05 -0400
Date: Thu, 8 May 2014 08:53:57 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <chris@printf.net>, micky <micky_ching@realsil.com.cn>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@linuxdriverproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Roger <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 2/2] mmc: rtsx: Revert "mmc: rtsx: add support for
 pre_req and post_req"
Message-ID: <20140508075357.GB5307@lee--X1>
References: <cover.1398735435.git.micky_ching@realsil.com.cn>
 <6a8f18cad47244e849adf8a731c621932fa777e0.1398735435.git.micky_ching@realsil.com.cn>
 <CAPDyKFqSdvjJrsbDeX1KbjQtOjfoAwC0xz3y7Rm-BsD0T8tmxg@mail.gmail.com>
 <CAPDyKFoEWkzHDfPn3BXVuXFMcfsLFtZdvsV36a7ic0DjCgu+NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPDyKFoEWkzHDfPn3BXVuXFMcfsLFtZdvsV36a7ic0DjCgu+NA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> This reverts commit c42deffd5b53c9e583d83c7964854ede2f12410d.
> >>
> >> commit <mmc: rtsx: add support for pre_req and post_req> did use
> >> mutex_unlock() in tasklet, but mutex_unlock() can't used in
> >> tasklet(atomic context). The driver need use mutex to avoid concurrency,
> >> so we can't use tasklet here, the patch need to be removed.
> >>
> >> The spinlock host->lock and pcr->lock may deadlock, one way to solve the
> >> deadlock is remove host->lock in sd_isr_done_transfer(), but if using
> >> workqueue the we can avoid using the spinlock and also avoid the problem.
> >>
> >> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> >
> > Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
> 
> Hi Lee,
> 
> Would you mind to pick this up and send it for 3.15 fixes?
> 
> The other revert "[PATCH 1/2] mmc: rtsx: Revert "mmc: rtsx: modify
> error handle and remove smatch warnings", needs to go through the mmc
> tree.

Sent.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
