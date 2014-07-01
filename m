Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbaGANVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:21:50 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:48043 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbaGANVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:21:49 -0400
Message-ID: <53B2B5E5.50502@gmail.com>
Date: Tue, 01 Jul 2014 15:21:41 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: mvebu: add armada drm init to Dove board setup
References: <1404219871-18419-1-git-send-email-sebastian.hesselbarth@gmail.com> <1404219871-18419-5-git-send-email-sebastian.hesselbarth@gmail.com> <20140701131026.GO32514@n2100.arm.linux.org.uk>
In-Reply-To: <20140701131026.GO32514@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 03:10 PM, Russell King - ARM Linux wrote:
> On Tue, Jul 01, 2014 at 03:04:31PM +0200, Sebastian Hesselbarth wrote:
>> +	pdev = platform_device_register_full(&armada_drm_dev_info);
>> +	/* assign last found lcd node to drm device for clk lookup */
>> +	pdev->dev.of_node = clknp;
>
> NAK.  This really isn't a good way to deal with this, even in a
> temporary basis.  While assigning a DT node to a manually created
> platform device does solve that problem, it also introduces the
> problem that this platform device will now match any platform driver
> which recognises the "marvell,dove-lcd" compatible type, which may
> occur _before_ we find the driver to match using the legacy strings.

Right, I never said it is a good solution but there is no driver for
"marvell,dove-lcd" *and* there is no way to assign clock aliases for
clocks not yet registered.

> There really isn't an easy solution to this other than doing the thing
> properly.

Well, you may have noticed that three moving subsystems plus new
bindings plus non-DT/DT drivers quickly create some kind of patch
deadlock. This is a dirty but tiny step to resolve one of those
deadlocks.

> The other problem in this series is that while you introduce some
> bindings which may work today, they're not going to work tomorrow, and
> that's a problem.  Don't do DT piecemeal like this and end up having to
> break the bindings (which we will have to do to add the endpoints.)

Adding new properties/subnodes never has been a problem for us at all.
New generic bindings were introduced *often* in the past and added to
existing bindings, e.g. clocks, gpio, pinctrl.

The proposed binding for dove-lcd simply reflects the tiny part that
is mandatory for identifying the lcd controllers. It only contains
reg and interrupts which would also be in the corresponding
platform_device.

> If you want to do this then you need to add the endpoints from the start
> even though the driver doesn't yet make use of them - or don't add the
> DT bits at all.

If you really think that way, I definitely give up on mainline Dove and
SolidRun Cubox. You are /really/ proposing to wait for *all* related
subsystem bindings to settle before even starting to add DT support?

Sebastian

