Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbaFYWhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:37:11 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:39879 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaFYWhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:37:07 -0400
MIME-Version: 1.0
In-Reply-To: <53AB422E.4040707@wwwdotorg.org>
References: <1403072180-4944-1-git-send-email-abrestic@chromium.org>
	<1403072180-4944-2-git-send-email-abrestic@chromium.org>
	<53AB422E.4040707@wwwdotorg.org>
Date: Wed, 25 Jun 2014 15:37:04 -0700
X-Google-Sender-Auth: QFjvn4ILhu3zYC9qfhcHdzYWHsY
Message-ID: <CAL1qeaFPjq9nqA2GDZZW+=DZsddWCkUjJcnRsfPkBWj8gmFsiw@mail.gmail.com>
Subject: Re: [PATCH v1 1/9] of: Add NVIDIA Tegra XUSB mailbox binding
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

On Wed, Jun 25, 2014 at 2:42 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/18/2014 12:16 AM, Andrew Bresticker wrote:
>> Add device-tree bindings for the Tegra XUSB mailbox which will be used
>> for communication between the Tegra XHCI controller and the host.
>
> Sorry for the slow review.
>
>> diff --git a/Documentation/devicetree/bindings/mailbox/nvidia,tegra124-xusb-mbox.txt b/Documentation/devicetree/bindings/mailbox/nvidia,tegra124-xusb-mbox.txt
>
>> +NVIDIA Tegra XUSB mailbox
>> +=========================
>> +
>> +The Tegra XUSB mailbox is used by the Tegra XHCI controller's firmware to
>> +communicate with the host.
>
> Isn't the mailbox an internal implementation detail of the XUSB controller.
>
> In other words, I'd naively think that there isn't a standalone generic
> mailbox that can be used by anything, but we just happen to want to use
> for XUSB. Rather, there's an XUSB controller, and part of the interface
> to that controller is a mailbox.

Yes, the mailbox isn't an actual piece of hardware but rather the
interface through which the XUSB host and AP communicate.

> As such, I don't think we want a standalone mailbox node in DT. Rather,
> we should add the required reg and interrupt values into the XUSB DT node.
>
> The driver for that XUSB HW module can either:
>
> a) Register as both a mailbox driver and an EHCI driver.
>
> b) Spawn a child device to instantiate the mailbox driver.
>
> Perhaps (b) could be assisted by using the MFD framework?

So in the RFC series I did something like (a) where the XUSB host
handled the mailbox interrupt with both the PHY and host could
registering notifiers to handle the messages.  It was suggested by
Arnd though that I make a separate mailbox driver.  Instead of having
a both a host and mailbox node, I could have a single XUSB host node
and have the mailbox driver bind to that - thoughts?
