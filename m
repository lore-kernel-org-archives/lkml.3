Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaHRTfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 15:35:46 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:59889 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaHRTfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 15:35:43 -0400
MIME-Version: 1.0
In-Reply-To: <53F2381B.8020801@wwwdotorg.org>
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
	<53F2381B.8020801@wwwdotorg.org>
Date: Mon, 18 Aug 2014 12:35:42 -0700
X-Google-Sender-Auth: nt9bOE-Q49axdVwQcka9uLLG_xc
Message-ID: <CAL1qeaGuMWbaZ4GQWATtrnYe-RjuTwLpFnrdhibWGNWm0iF+=g@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] Tegra xHCI support
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 10:30 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/18/2014 11:08 AM, Andrew Bresticker wrote:
>>
>> This series adds support for xHCI on NVIDIA Tegra SoCs.  This includes:
>>   - adding a driver for the mailbox used to communicate with the xHCI
>>     controller's firmware,
>>   - extending the XUSB pad controller driver to support the USB PHY
>>     types (UTMI, HSIC, and USB3), and
>>   - adding a xHCI host-controller driver.
>
>
> Can you please remind us what dependencies exist between the patches? In
> other words, is it possible to apply parts of the series to their usual
> subsystem branches, or does the whole thing need to go into a single topic
> branch in order to avoid compile-time problems, or run-time problems in
> features unrelated to the new functionality? Thanks.

The whole thing will probably need to go into one branch.  Patch 4/9
("pinctrl: tegra-xusb: Add USB PHY support") has compile-time
dependencies on patch 2/9 ("mailbox: Add NVIDIA Tegra XUSB mailbox
driver") and patch 6/9 ("usb: xhci: Add NVIDIA Tegra xHCI
host-controller driver") has compile-time dependencies on both patches
2/9 and 4/9.
