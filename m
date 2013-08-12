Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab3HLURN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 16:17:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3HLURM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 16:17:12 -0400
Date: Mon, 12 Aug 2013 13:17:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Manjunath Goudar <manjunath.goudar@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org, arnd@linaro.org,
        dsaxena@linaro.org, linaro-kernel@lists.linaro.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] USB: EHCI: make ehci-w90X900 a separate driver
Message-ID: <20130812201710.GA26239@kroah.com>
References: <1372347109-5563-1-git-send-email-manjunath.goudar@linaro.org>
 <1376120073-30502-1-git-send-email-manjunath.goudar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376120073-30502-1-git-send-email-manjunath.goudar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 10, 2013 at 01:04:33PM +0530, Manjunath Goudar wrote:
> Separate the W90X900(W90P910) on-chip host controller driver from
> ehci-hcd host code so that it can be built as a separate driver module.
> This work is part of enabling multi-platform kernels on ARM;
> however, note that other changes are still needed before W90X900(W90P910)
> can be booted with a multi-platform kernel
> 
> and an ehci driver that only works on one of them.
> 
> With the infrastructure added by Alan Stern in patch 3e0232039
> "USB: EHCI: prepare to make ehci-hcd a library module", we can
> avoid this problem by turning a bus glue into a separate
> module, as we do here for the w90X900 bus glue.
> 
> Signed-off-by: Manjunath Goudar <manjunath.goudar@linaro.org>
> Signed-off-by: Deepak Saxena <dsaxena@linaro.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Wan ZongShun <mcuos.com@gmail.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> Cc: Greg KH <greg@kroah.com>
> Cc: linux-usb@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
> V2:
> -Arranged  #include's in alphabetical order.
> -Replaced "w90p910" by "w90x900" because it is supports
>  all series of w90x900.
> 
>  drivers/usb/host/Kconfig        |    2 +-
>  drivers/usb/host/Makefile       |    1 +
>  drivers/usb/host/ehci-hcd.c     |    5 ---
>  drivers/usb/host/ehci-w90x900.c |   85 ++++++++++++++++-----------------------
>  4 files changed, 37 insertions(+), 56 deletions(-)

This patch fails to apply:

checking file drivers/usb/host/Kconfig
Hunk #1 succeeded at 236 with fuzz 1 (offset -8 lines).
checking file drivers/usb/host/Makefile
Hunk #1 FAILED at 35.
1 out of 1 hunk FAILED
checking file drivers/usb/host/ehci-hcd.c
Hunk #1 succeeded at 1246 (offset -3 lines).
checking file drivers/usb/host/ehci-w90x900.c
Hunk #2 FAILED at 114.
1 out of 3 hunks FAILED

Please redo it against the latest usb-next branch and resend.

thanks,

greg k-h
