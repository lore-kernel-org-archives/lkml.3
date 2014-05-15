Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbaEOUod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:44:33 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:45856 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbaEOUob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:44:31 -0400
MIME-Version: 1.0
In-Reply-To: <5375169F.3060809@wwwdotorg.org>
References: <1400113986-339-1-git-send-email-abrestic@chromium.org>
	<5375169F.3060809@wwwdotorg.org>
Date: Thu, 15 May 2014 13:44:30 -0700
X-Google-Sender-Auth: Pawnuruf3QwW9DFtfOw7RkHZO7w
Message-ID: <CAL1qeaHb7GK+zb9E2yWZ3aWH6yaMKWouRFScxmK_XpOvASSRgw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] Tegra XHCI support
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-usb@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 12:33 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/14/2014 06:32 PM, Andrew Bresticker wrote:
>> This is a first pass at the host and PHY drivers necessary for USB3.0
>> support on Tegra114 and Tegra124.  The Tegra XHCI host controller requires
>> external firmware [1] which must be loaded before using any USB ports owned
>> by the controller.  The XUSB PHY driver handles mapping and enabling of
>> the UTMI, HSIC, and SuperSpeed pads to the XHCI controller.
>>
>> Tested on a Venice2 with a variety of USB2.0 and USB3.0 memory sticks
>> and ethernet dongles.
>>
>> Notes:
>>  - I've included support for Tegra114, but since I don't have Tegra114-based
>>    hardware, it is completely untested.
>>  - The PCIe and SATA PHYs also are programmed using the XUSB_PADCTL space
>>    as well.  At least some of the code can be re-used, specifically with
>>    respect to lane programming.  I believe Thierry is working on the PCIe
>>    parts of this.
>
> If I understand the HW correctly, there's a separate "pad control" HW
> block that provides routing/sharing of signals from USB2(?), USB3, SATA,
> and PCIe to the pads.
>
> I believe Thierry is working on exposing this block as a pinctrl driver,
> or at least something that the other drivers can call into in order to
> configure that block. It'd be good if you can co-ordinate with him to
> rebase this driver on top of that, rather than (I assume; haven't read
> the code yet...) directly manipulating the padctrl registers inside each
> of the different drivers.

Yes, ideally i'd like to rebase this on top of Theirry's series once
it's ready.  It sounds like there will be a pinctrl driver which
handles the lane muxing between XUSB, PCIe, and SATA and a generic PHY
driver will deal wit the actual PHY programming.  I'm not sure what
the PCIe and SATA PHY drivers will look like, but the XUSB one
requires quite a bit of USB-specific programming of the padctl
registers, so I'm not sure we'll be able to fit all three PHY types
into a single PHY provider driver.  Either way, there's probably a
good deal of PHY code that could be broken out and shared among the
three.
