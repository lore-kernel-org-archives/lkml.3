Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbaFYXCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 19:02:52 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:45512 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563AbaFYXCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 19:02:49 -0400
MIME-Version: 1.0
In-Reply-To: <53AB4530.2050106@wwwdotorg.org>
References: <1403072180-4944-1-git-send-email-abrestic@chromium.org>
	<1403072180-4944-6-git-send-email-abrestic@chromium.org>
	<53AB4530.2050106@wwwdotorg.org>
Date: Wed, 25 Jun 2014 16:02:48 -0700
X-Google-Sender-Auth: AetZQeZxksl6d2F1oWd2gwuDY5k
Message-ID: <CAL1qeaHThKVBoY0fikFCh9X00BFNJ=XKfovOBwztEyOVjHBLjg@mail.gmail.com>
Subject: Re: [PATCH v1 5/9] of: Add NVIDIA Tegra XHCI controller binding
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-usb@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 2:54 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/18/2014 12:16 AM, Andrew Bresticker wrote:
>> Add device-tree binding documentation for the XHCI controller present
>> on Tegra124 and later SoCs.
>
>> diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt b/Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt
>
>> + - clock-names: Must include the following entries:
>> +    - xusb_host
>> +    - xusb_falcon_src
>> +    - xusb_ss
>> +    - xusb_ss_src
>> +    - xusb_hs_src
>> +    - xusb_fs_src
>
> Looking at include/dt-bindings/clock/tegra124-car.h I see a few entries
> potentially missing here:
>
> #define TEGRA124_CLK_XUSB_HOST_SRC 252
> #define TEGRA124_CLK_XUSB_DEV_SRC 256
> #define TEGRA124_CLK_XUSB_DEV 257
> #define TEGRA124_CLK_XUSB_SS_DIV2 312

The driver doesn't use them, so I didn't put them in the binding.

>> +    - pll_u_480m
>
> Not just pll_u?

We specifically want pll_u_480M as that's what we use as the parent of
xusb_ss_src when scaling it to 120Mhz.
