Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaBQPFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 10:05:06 -0500
Received: from top.free-electrons.com ([176.31.233.9]:39597 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752537AbaBQPFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:05:04 -0500
Message-ID: <53022504.1010908@free-electrons.com>
Date: Mon, 17 Feb 2014 16:04:36 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Mike Turquette <mturquette@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] clk: mvebu: fix clk init order
References: <1390673950-4521-1-git-send-email-sebastian.hesselbarth@gmail.com> <20140205183457.GW8533@titan.lakedaemon.net> <20140217141336.GA2765@localhost> <53021BD2.3090301@free-electrons.com> <53021FD9.2070406@elopez.com.ar>
In-Reply-To: <53021FD9.2070406@elopez.com.ar>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/02/2014 15:42, Emilio López wrote:
> Hi Gregory, Ezequiel,
> 
>  >> Are we still in time to consider Emilio's oneline proposal?
>>> (Emilio: would you mind preparing a suitable patch against dove,
>>> kirkwood, armada370/xp, so we can see the real thing?).
> 
> The patch is in a common file, so it does not need patching anything for 
> each platform.
> 
>> I am still strongly against this proposal because hard-coded the parent
>> clock name in the driver seems very wrong
> 
> It is hardcoded already when the parent is registered, so I do not 
> understand your concern.
> 
> http://lxr.free-electrons.com/source/drivers/clk/mvebu/common.c?v=3.13#L34
> 
>> and moreover in some circumstances
>> (if there is no output-name, which is our default case) this proposal
>> just ignored the parent clock given by the device tree and this looked
>> more wrong.
> 
> I have sent a second patch addressing this comment, but you do not seem 
> to have taken too serious a look at it.
> 
> http://www.spinics.net/lists/arm-kernel/msg305922.html
> 

Please read what I have written: "if there is no output-name, which is our
default case) this proposal just ignored the parent clock given by the device
tree".

Extract of your code from the link you pointed:

const char *default_parent = "tclk";

[...]

of_property_read_string_index(clkspec.np, "clock-output-names",
					      clkspec.args_count ? clkspec.args[0] : 0,
					      &default_parent);

example of a valid dts:
			gateclk: clock-gating-control@18220 {
				compatible = "marvell,foo-bar-gating-clock";
				reg = <0x18220 0x4>;
				clocks = <&coreclk 1>;
				#clock-cells = <1>;
			};

So in this fictional but still valid example, the device tree indicates that the parent
clock of the gating clock is the 2nd clock provided by the coreclk which is currently
"cpuclk". As no clock-output-names is used, then this will be totally ignore and instead
of using "cpuclk" as parent "tclk" will be used.

I hope this example will show you, what I disagree with this proposal and why it
introduce some regression.

Regards,

Gregory


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
