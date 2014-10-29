Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934551AbaJ2QhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:37:19 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:62060 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934439AbaJ2QhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:37:15 -0400
MIME-Version: 1.0
In-Reply-To: <20141029094338.GA28356@ulmo.nvidia.com>
References: <1414535277-15645-1-git-send-email-abrestic@chromium.org>
	<1414535277-15645-6-git-send-email-abrestic@chromium.org>
	<20141029094338.GA28356@ulmo.nvidia.com>
Date: Wed, 29 Oct 2014 09:37:14 -0700
X-Google-Sender-Auth: hZB0BoZvLjTQgCQaas9ozCzUqLM
Message-ID: <CAL1qeaEf0mTQfMgnY8jHGDBvbQ7ivtzAQRWaE9K24TJ86hWYMg@mail.gmail.com>
Subject: Re: [PATCH RESEND V4 5/9] of: Add NVIDIA Tegra xHCI controller binding
From: Andrew Bresticker <abrestic@chromium.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
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

On Wed, Oct 29, 2014 at 2:43 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Tue, Oct 28, 2014 at 03:27:50PM -0700, Andrew Bresticker wrote:
> [...]
>> diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-xusb-padctl.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-xusb-padctl.txt
> [...]
>> +Optional properties:
>> +-------------------
>> +- vbus-{0,1,2}-supply: VBUS regulator for the corresponding UTMI pad.
>> +- vddio-hsic-supply: VDDIO regulator for the HSIC pads.
>> +- nvidia,usb3-port-{0,1}-lane: PCIe/SATA lane to which the corresponding USB3
>> +  port is mapped.  See <dt-bindings/pinctrl/pinctrl-tegra-xusb.h> for the list
>> +  of valid values.
>
> I dislike how we now need to provide a list of all pins in the header
> file, where previously we used strings for this. This could become very
> ugly if the set of pins changes in future generations of this IP block.
>
> Could we instead derive this from the pinmux nodes? For example you have
> this in the example below:
>
>         usb3p0 {
>                 nvidia,lanes = "pcie-0";
>                 ...
>         };
>
> Perhaps what we need is to either key off the node name or add another
> property, such as:
>
>         nvidia,usb3-port = <0>;
>
> This would match the nvidia,usb2-port property that you've added below.

That is actually how I described the USB3 port to SS lane mapping
originally, but in review of an earlier version of this series,
Stephen suggested that I make it a separate, not pinconfig property
since it wasn't a value written directly to the hardware.  I'm fine
with changing it back as the pinconfig property makes more sense to me
as well.
