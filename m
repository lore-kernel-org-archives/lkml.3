Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897Ab3GWSxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:53:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56790 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933293Ab3GWSx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:53:29 -0400
Date: Tue, 23 Jul 2013 14:53:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Manjunath Goudar <manjunath.goudar@linaro.org>
cc: linux-usb@vger.kernel.org, <linux-arm-kernel@lists.infradead.org>,
        <patches@linaro.org>, <arnd@linaro.org>,
        <linaro-kernel@lists.linaro.org>, Greg KH <greg@kroah.com>,
        Wan ZongShun <mcuos.com@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] USB: EHCI: make ehci-w90X900 a separate driver
In-Reply-To: <1374488380-26428-1-git-send-email-manjunath.goudar@linaro.org>
Message-ID: <Pine.LNX.4.44L0.1307231450340.1304-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jul 2013, Manjunath Goudar wrote:

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
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg KH <greg@kroah.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Wan ZongShun <mcuos.com@gmail.com>
> Cc: linux-usb@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
> V2:
>  -Arranged  #include's in alphabetical order.
>  -Replaced "w90p910" by "w90x900" because it is supports
>   all series of w90x900.

> +MODULE_DESCRIPTION(DRIVER_DESC);
>  MODULE_AUTHOR("Wan ZongShun <mcuos.com@gmail.com>");
> -MODULE_DESCRIPTION("w90p910 usb ehci driver!");
> -MODULE_LICENSE("GPL");
>  MODULE_ALIAS("platform:w90p910-ehci");
> +MODULE_LICENSE("GPL v2");

Are you sure the license is supposed to be changed?  Is that okay with 
Wan ZongShun?

Alan Stern

