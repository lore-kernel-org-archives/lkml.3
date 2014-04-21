Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbaDUTbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 15:31:06 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:41389 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbaDUTa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 15:30:58 -0400
MIME-Version: 1.0
In-Reply-To: <1397136261-16408-1-git-send-email-gautam.vivek@samsung.com>
References: <1397136261-16408-1-git-send-email-gautam.vivek@samsung.com>
Date: Tue, 22 Apr 2014 01:00:57 +0530
X-Google-Sender-Auth: r9frgX34YIbUIYi9cXWxcNLCewY
Message-ID: <CAFp+6iGrgMTE27FxpFTQfALJO_XypxGSZ1-wny8KAoY1sLBbWw@mail.gmail.com>
Subject: Re: [PATCH] usb: ohci-exynos: Add facility to use phy provided by the
 generic phy framework
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>, robh+dt@kernel.org,
        Jingoo Han <jg1.han@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 6:54 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> Add support to consume phy provided by Generic phy framework.
> Keeping the support for older usb-phy intact right now, in order
> to prevent any functionality break in absence of relevant
> device tree side change for ohci-exynos.
> Once we move to new phy in the device nodes for ohci, we can
> remove the support for older phys.

Any comments on this please.
I think whatever the approach we follow, that can be common to both
ehci-exynos[1], and ohci-exynos, since
both are needed to move to the new generic phy framework, keeping
support for older usb-phy
so as to have smooth transition, in order to avoid any regression.

> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Cc: Jingoo Han <jg1.han@samsung.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> ---
>
> Based on 'usb-next' branch of Greg's usb tree.
> Tested with local dt patches, similar to ehci dt changes posted by Kamil[1].
> Tested on Exynos5250 smdk.
>
 [1] [PATCH v6 4/8] dts: Add usb2phy to Exynos 5250
     https://lkml.org/lkml/2014/1/29/302
>
>  .../devicetree/bindings/usb/exynos-usb.txt         |   14 ++++
>  drivers/usb/host/ohci-exynos.c                     |   79 ++++++++++++++++++--
>  2 files changed, 85 insertions(+), 8 deletions(-)
>
[snip]
