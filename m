Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935028AbaH0QeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 12:34:04 -0400
Received: from mail-yk0-f182.google.com ([209.85.160.182]:65306 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbaH0QeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 12:34:00 -0400
MIME-Version: 1.0
In-Reply-To: <53FB84F7.8030509@wwwdotorg.org>
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
	<1408381705-3623-2-git-send-email-abrestic@chromium.org>
	<53FB84F7.8030509@wwwdotorg.org>
Date: Wed, 27 Aug 2014 09:33:59 -0700
X-Google-Sender-Auth: 3uRRB1vzMJCW1AWidH7l-TBi0e4
Message-ID: <CAL1qeaEkTPcn2C+KTO539NgAW_9DS0W+D8q5L9GwSwVop9Du0Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] of: Add NVIDIA Tegra XUSB mailbox binding
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

On Mon, Aug 25, 2014 at 11:48 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/18/2014 11:08 AM, Andrew Bresticker wrote:
>
>> diff --git a/include/dt-bindings/mailbox/tegra-xusb-mailbox.h
>> b/include/dt-bindings/mailbox/tegra-xusb-mailbox.h
>
>
>> +#define TEGRA_XUSB_MBOX_CHAN_HOST      0
>> +#define TEGRA_XUSB_MBOX_CHAN_PHY       1
>
>
> I can't work out how these values relate to hardware at all. Are they in
> fact properties of the particular firmware that's loaded into the XUSB
> module? If so, I don't think the DT should contain these values at all.

Yes this is rather ugly... they're used by software for the demuxing
of messages and don't correspond to actual hardware.

> I wonder if the individual MBOX_CMD_* values from patch 2 are any
> better, although I think those are also defined by the firmware, not the
> hardware?

They are indeed defined by the firmware, so this would become an issue
if the firmware API ever changed.
