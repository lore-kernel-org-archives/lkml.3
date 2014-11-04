Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaKDUoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 15:44:55 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:39136 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaKDUox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:44:53 -0500
MIME-Version: 1.0
In-Reply-To: <CAL1qeaFcyoSUbVdgUdWZ6RtRiuj0X1H-ohXCsckwF8=VPw8jRA@mail.gmail.com>
References: <1414535277-15645-1-git-send-email-abrestic@chromium.org>
	<1414535277-15645-6-git-send-email-abrestic@chromium.org>
	<20141029094338.GA28356@ulmo.nvidia.com>
	<CAL1qeaEf0mTQfMgnY8jHGDBvbQ7ivtzAQRWaE9K24TJ86hWYMg@mail.gmail.com>
	<20141030135500.GC19802@ulmo.nvidia.com>
	<CAL1qeaG701hKtcUL5a67b=X38hbcYunUOUBziZMpxemvhhAayA@mail.gmail.com>
	<20141030172432.GA8944@ulmo.nvidia.com>
	<CAL1qeaEbRkOQApyjkpwxBd3mGkQ3JuXNiar1MbBd844NWe5h9g@mail.gmail.com>
	<20141031113249.GD10778@ulmo.nvidia.com>
	<CAL1qeaFcyoSUbVdgUdWZ6RtRiuj0X1H-ohXCsckwF8=VPw8jRA@mail.gmail.com>
Date: Tue, 4 Nov 2014 12:44:52 -0800
X-Google-Sender-Auth: fP2PbuFs7HC40cD9MZGPAi2X4Ig
Message-ID: <CAL1qeaEbQoXFgYjtxVvAwULC6P_9xrb56_=-HjKOmUBaLVUh2w@mail.gmail.com>
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

On Fri, Oct 31, 2014 at 9:41 AM, Andrew Bresticker
<abrestic@chromium.org> wrote:
> On Fri, Oct 31, 2014 at 4:32 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
>> On Thu, Oct 30, 2014 at 10:26:47AM -0700, Andrew Bresticker wrote:
>>> On Thu, Oct 30, 2014 at 10:24 AM, Thierry Reding
>>> <thierry.reding@gmail.com> wrote:
>>> > On Thu, Oct 30, 2014 at 10:19:21AM -0700, Andrew Bresticker wrote:
>>> >> On Thu, Oct 30, 2014 at 6:55 AM, Thierry Reding
>>> >> <thierry.reding@gmail.com> wrote:
>>> >> > On Wed, Oct 29, 2014 at 09:37:14AM -0700, Andrew Bresticker wrote:
>>> >> >> On Wed, Oct 29, 2014 at 2:43 AM, Thierry Reding
>>> >> >> <thierry.reding@gmail.com> wrote:
>>> >> >> > On Tue, Oct 28, 2014 at 03:27:50PM -0700, Andrew Bresticker wrote:
>>> >> >> > [...]
>>> >> >> >> diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-xusb-padctl.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-xusb-padctl.txt
>>> >> >> > [...]
>>> >> >> >> +Optional properties:
>>> >> >> >> +-------------------
>>> >> >> >> +- vbus-{0,1,2}-supply: VBUS regulator for the corresponding UTMI pad.
>>> >> >> >> +- vddio-hsic-supply: VDDIO regulator for the HSIC pads.
>>> >> >> >> +- nvidia,usb3-port-{0,1}-lane: PCIe/SATA lane to which the corresponding USB3
>>> >> >> >> +  port is mapped.  See <dt-bindings/pinctrl/pinctrl-tegra-xusb.h> for the list
>>> >> >> >> +  of valid values.
>>> >> >> >
>>> >> >> > I dislike how we now need to provide a list of all pins in the header
>>> >> >> > file, where previously we used strings for this. This could become very
>>> >> >> > ugly if the set of pins changes in future generations of this IP block.
>>> >> >> >
>>> >> >> > Could we instead derive this from the pinmux nodes? For example you have
>>> >> >> > this in the example below:
>>> >> >> >
>>> >> >> >         usb3p0 {
>>> >> >> >                 nvidia,lanes = "pcie-0";
>>> >> >> >                 ...
>>> >> >> >         };
>>> >> >> >
>>> >> >> > Perhaps what we need is to either key off the node name or add another
>>> >> >> > property, such as:
>>> >> >> >
>>> >> >> >         nvidia,usb3-port = <0>;
>>> >> >> >
>>> >> >> > This would match the nvidia,usb2-port property that you've added below.
>>> >> >>
>>> >> >> That is actually how I described the USB3 port to SS lane mapping
>>> >> >> originally, but in review of an earlier version of this series,
>>> >> >> Stephen suggested that I make it a separate, not pinconfig property
>>> >> >> since it wasn't a value written directly to the hardware.  I'm fine
>>> >> >> with changing it back as the pinconfig property makes more sense to me
>>> >> >> as well.
>>> >> >
>>> >> > Hmm... I had considered it a mux option of the specific lane. If the
>>> >> > function is usb3, it'd still need to be muxed to one of the ports. So
>>> >> > it's additional information associated with the usb3 function.
>>> >> >
>>> >> > I did look through the driver changes and can't really make out which
>>> >> > part of the code actually performs this assignment. Can you point me to
>>> >> > it?
>>> >>
>>> >> There's not really an assignment.  The property is used to map between
>>> >> a lane (e.g. PCIe-0 or SATA) and the USB3.0 port it's mapped to.  For
>>> >> an example of where it's used, take a look at usb3_phy_power_on().
>>> >> There are certain per-lane registers which need to be programmed in
>>> >> addition to the per-USB3.0 port pad registers.  This mapping is used
>>> >> to determine which lane needs to be programmed.
>>> >
>>> > Are you saying the mapping of lane to USB port is fixed? That is, PCIe-0
>>> > lane is always used for USB port X and SATA always for USB port Y?
>>>
>>> No, sorry if that was unclear, it's not fixed - it's a board specific
>>> property.
>>
>> Okay, but there's no register that contains the mapping of the port to a
>> lane, similar to what's done for the functions, right?
>
> Correct.
>
>> I mean the driver only uses the lane to find out which register to write.
>> Doesn't that imply that two lanes (or more) could be mapped to the same
>> USB 3.0 port?
>
> I guess?  Not sure how that would work in hardware to have two
> SuperSpeed lanes wired up to a single port.
>
>> I'm not sure I'm being clear here, so let me try another way. In order
>> to establish a mapping between USB port and lane, I would've expected
>> one of the following to happen:
>>
>>         - A value derived from the lane number is written to a register
>>           belonging to a given port.
>>
>>         - A value derived from the port number is written to a register
>>           belonging to a given lane.
>>
>> I can't see the code do either of the above, which to me implies that
>> there's a fixed mapping between lanes and ports. What am I missing?
>
> It's fixed in that it's not a software-modifiable property.  It's
> describing an electrical connection between lane and port.  For
> example, it's possible that one board has PCIe lane 1 wired up to
> SuperSpeed port 1 and on another board for the SATA lane to be wired
> up to SuperSpeed port 1.  Does that make sense?

So what's the verdict here?
