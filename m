Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab3EWIXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 04:23:16 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:53938 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab3EWIXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 04:23:13 -0400
Date: Thu, 23 May 2013 09:23:08 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Leon Romanovsky <leon@leon.nu>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: mfd: tps65912: Convert to use devm_kzalloc
Message-ID: <20130523082308.GB22683@gmail.com>
References: <1368609586-20905-1-git-send-email-leon@leon.nu>
 <CALq1K=KP4pADX89QJ3MJzaC+uTeEVOy7FUNikEnYddb0u-rihw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALq1K=KP4pADX89QJ3MJzaC+uTeEVOy7FUNikEnYddb0u-rihw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > There is no need to call kfree while using devm_kzalloc,
> > remove it from *_device_init function.
> >
> > Signed-off-by: Leon Romanovsky <leon@leon.nu>
> > ---
> >  drivers/mfd/tps65912-core.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> To be honest the whole tps65912 looks strange to me.
> For example,  kfree(tps65912) calls all over the code.
> 
> tps65912_i2c_probe allocates tps65912 struct, but tps65912_device_exit
> releases it.

Yes, this is expected.

tps65912_[spi|i2c]_remove() both call tps65912_device_exit() which in
turn frees tps65912. Saves duplicating code.

I'll clean thinks up a little, so this is less confusing.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
