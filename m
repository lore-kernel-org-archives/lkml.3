Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab3C2C4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 22:56:43 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:44475 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab3C2C4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 22:56:41 -0400
MIME-Version: 1.0
In-Reply-To: <1364507705-22012-3-git-send-email-arnd@arndb.de>
References: <1364507705-22012-1-git-send-email-arnd@arndb.de>
	<1364507705-22012-3-git-send-email-arnd@arndb.de>
Date: Fri, 29 Mar 2013 08:26:41 +0530
X-Google-Sender-Auth: VZYIjaBurHGT7UkzJrnng8HWgQk
Message-ID: <CAOh2x==_0iR2FQFXCM2mHm28+KDj9tO4HmYMrStK_V8opmQowA@mail.gmail.com>
Subject: Re: [PATCH v3 2/7] USB: EHCI: make ehci-spear a separate driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Deepak Saxena <dsaxena@linaro.org>,
        Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 3:25 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> From: Manjunath Goudar <manjunath.goudar@linaro.org>
>
> Separate the SPEAr host controller driver from ehci-hcd host code
> so that it can be built as a separate driver module.
> This work is part of enabling multi-platform kernels on ARM;
> however, note that other changes are still needed before SPEAr can be
> booted with a multi-platform kernel, but they are queued in the
> arm-soc tree for 3.10.
>
> With the infrastructure added by Alan Stern in patch 3e0232039
> "USB: EHCI: prepare to make ehci-hcd a library module", we can
> avoid this problem by turning a bus glue into a separate
> module, as we do here for the SPEAr bus glue.
>
> In V3:
>  -Detailed commit message added here about why this patch is required.
>  -Eliminated ehci_spear_setup routine beacuse hcd registers
>   directly setting in spear_ehci_hcd_drv_probe function.
>  -spear_overrides struct initialized.
>  -Eliminate struct ehci_hcd ehci from struct spear_ehci,to enable SPEAr clock
>   uses directly usb_hcd *hcd in spear_start_ehci function.
>  -to_spear_ehci() macro modified for spear_ehci.
>
> In V2:
> Replaced spear as SPEAr everywhere, leaving functions/variables/config options.
>
> Signed-off-by: Deepak Saxena <dsaxena@linaro.org>
> Signed-off-by: Manjunath Goudar <manjunath.goudar@linaro.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Viresh Kumar <viresh.linux@gmail.com>

This version has changed from what i Acked, but it still looks fine.

Thanks.

Viresh
