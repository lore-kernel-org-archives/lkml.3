Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaISAVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 20:21:34 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:61134 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaISAVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 20:21:33 -0400
Date: Thu, 18 Sep 2014 17:21:01 -0700
From: Lee Jones <lee.jones@linaro.org>
To: micky <micky_ching@realsil.com.cn>
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com, wei_wang@realsil.com.cn
Subject: Re: [PATCH] mfd: rtsx: fix PM suspend for 5227 & 5249
Message-ID: <20140919002101.GB29852@lee--X1>
References: <1411004156-9057-1-git-send-email-micky_ching@realsil.com.cn>
 <20140918045316.GB8740@lee--X1>
 <541A7286.1080008@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <541A7286.1080008@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014, micky wrote:

> On 09/18/2014 12:53 PM, Lee Jones wrote:
> >On Thu, 18 Sep 2014, micky_ching@realsil.com.cn wrote:
> >
> >>From: Micky Ching <micky_ching@realsil.com.cn>
> >>
> >>Fix rts5227&5249 failed send buffer cmd after suspend,
> >>PM_CTRL3 should reset before send any buffer cmd after suspend.
> >>Otherwise, buffer cmd will failed, this will lead resume fail.
> >>
> >>Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> >>---
> >>  drivers/mfd/rts5227.c        |   19 +++++++++++++++++++
> >>  drivers/mfd/rts5249.c        |    4 ++++
> >>  drivers/mfd/rtsx_pcr.h       |    1 +
> >>  include/linux/mfd/rtsx_pci.h |   12 ++++++++++++
> >>  4 files changed, 36 insertions(+)
> >I think you'll find you just broke the build.
> >
> >What happens when you compile these as modules?
> I build as modules with no warning or error, did you find anything wrong?

Yes, you don't export the functions.

EXPORT_SYMBOL()

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
