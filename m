Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbaBQPcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 10:32:05 -0500
Received: from yotta.elopez.com.ar ([31.220.24.173]:39716 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbaBQPcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:32:04 -0500
Message-ID: <53022B59.3060905@elopez.com.ar>
Date: Mon, 17 Feb 2014 12:31:37 -0300
From: =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Mike Turquette <mturquette@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] clk: mvebu: fix clk init order
References: <1390673950-4521-1-git-send-email-sebastian.hesselbarth@gmail.com> <20140205183457.GW8533@titan.lakedaemon.net> <20140217141336.GA2765@localhost> <53021BD2.3090301@free-electrons.com> <53021FD9.2070406@elopez.com.ar> <53022504.1010908@free-electrons.com>
In-Reply-To: <53022504.1010908@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

El 17/02/14 12:04, Gregory CLEMENT escribió:
(snip)
> Please read what I have written: "if there is no output-name, which is our
> default case) this proposal just ignored the parent clock given by the device
> tree".
>
> Extract of your code from the link you pointed:
>
> const char *default_parent = "tclk";
>
> [...]
>
> of_property_read_string_index(clkspec.np, "clock-output-names",
> 					      clkspec.args_count ? clkspec.args[0] : 0,
> 					      &default_parent);
>
> example of a valid dts:
> 			gateclk: clock-gating-control@18220 {
> 				compatible = "marvell,foo-bar-gating-clock";
> 				reg = <0x18220 0x4>;
> 				clocks = <&coreclk 1>;
> 				#clock-cells = <1>;
> 			};
>
> So in this fictional but still valid example, the device tree indicates that the parent
> clock of the gating clock is the 2nd clock provided by the coreclk which is currently
> "cpuclk". As no clock-output-names is used, then this will be totally ignore and instead
> of using "cpuclk" as parent "tclk" will be used.

I can see your point now, but as this is completely fictional, I'd say 
it's irrelevant. You can just add the names if Marvell ever makes a chip 
that sources the gates from the second coreclk. As far as I can see on 
the device trees in Linux, all mvebu hardware always sources them from 
tclk. Don't try to over-engineer your driver for something that is 
unlikely to happen in reality.

If you in the future need to support another legacy platform with a 
half-cooked DT not listing the names, you can always list the right 
parent on the divisor table (see link for example) and override the default.

http://lxr.free-electrons.com/source/drivers/clk/mvebu/kirkwood.c?v=3.13#L222

> I hope this example will show you, what I disagree with this proposal and why it
> introduce some regression.

It's not a regression if things don't break :-)

Cheers,

Emilio
