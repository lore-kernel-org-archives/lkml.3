Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3IMH2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 03:28:12 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:53181 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab3IMH2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 03:28:08 -0400
Date: Fri, 13 Sep 2013 08:28:03 +0100
From: Lee Jones <lee.jones@linaro.org>
To: wwang <wei_wang@realsil.com.cn>
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com, micky_ching@realsil.com.cn
Subject: Re: [PATCH v3] mfd: rtsx: Modify rts5249_optimize_phy
Message-ID: <20130913072803.GT11227@lee--X1>
References: <1378804397-28640-1-git-send-email-wei_wang@realsil.com.cn>
 <20130910092857.GB1456@lee--X1>
 <522EED3A.9080806@realsil.com.cn>
 <20130910110821.GD1456@lee--X1>
 <522FC82C.4020000@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <522FC82C.4020000@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >I'm not asking for in-depth analysis, just an overview.
> >
> >What's wrong with the default config?
> >Why is the signal quality bad and what makes it bad?
> >What did the old magic numbers do?
> >How will the configuration differ if I applied your patch?

I'm not sure I'm getting the answers I crave here.

> It is a little different between simulation and real chip. We have
> no idea about which configuration is better before tape-out. We set
> default settings according to simulation, but need to tune these
> parameters after getting the real chip.

What parameters? I can see they've changed, but what were they before?

> Those old magic numbers are proper in simulation environment, but
> not good in real ASIC chip.

I'm sure they suited at some point or they wouldn't have been used,
but what's the difference between the old magic numbers and the new
defines? 0xFE46 tells me nothing. I can't make a comparison without
you telling me, in words, in the commit log what you're actually
doing.

> If the new patch won't be applied, we may failed to access SD card
> in those platforms equipped with rts5249 module.

Fine. I get that. I have no problem applying the patch, but I'd really
like to know what it is that you're changing before blindly doing so.

Other changes which deserve a little explaining:

  Why don't you set the PHY_BPCR anymore? 0x05C0 looks like quite a bit
  of configuration. What was it and why isn't it required anymore?

  And why is there a need to set the; PHY_PCR, PHY_RCR2, PHY_FLD4,
  PHY_RDR, PHY_RCR1, PHY_FLD3 and PHY_TUNE registers where there
  wasn't this requirement before?

You don't need to reply to this message. Write a proper, informative
commit log into the patch and resubmit. If I'm satisfied I know what
you're actually adapting in the configuration I'll have no issue and
apply the patch - the code looks good.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
