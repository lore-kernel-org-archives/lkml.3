Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab3BRX4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 18:56:08 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:39294 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757691Ab3BRX4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 18:56:06 -0500
Message-ID: <5122BF88.1050007@gmail.com>
Date: Tue, 19 Feb 2013 00:55:52 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Question about fixed-clock
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This might be a stupid question, but I'm somehow stuck here. I'm using a
driver with the following DTS sub-node:

	ref25: ref25M {
		compatible = "fixed-clock";
		#clock-cells = <0>;
		clock-frequency = <25000000>;
	};

	clock-generator@0 {
				/* ... */
				#clock-cells = <1>;
				clocks = <&ref25>;
	}

The device driver for clock-generator uses something like the following
call to get its clock:

	clk = of_clk_get(np, 0);

but the return value is ERR_PTR(-ENOENT) and I also can't find this
clock in the clk debugfs tree.

This is on a OMAP/AM33xx device with kernel 3.8-rc7 plus the -next tips
of arm-soc and omap, but with no other special clock options selected in
the config. Is there anything I'm missing to correctly instantiate the
dummy clock?


Thanks for a pointer,
Daniel
