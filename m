Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaHORm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:42:26 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:40396 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751063AbaHORmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:42:25 -0400
Date: Fri, 15 Aug 2014 13:42:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        LKML <linux-kernel@vger.kernel.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mugunthan V N <mugunthanvnm@ti.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>,
        Markus Pargmann <mpa@pengutronix.de>,
        Robert Nelson <robertcnelson@gmail.com>, Felipe Balbi <balbi@ti.com>
Subject: Random MAC address on my BeagleBone White
Message-ID: <20140815134221.08c546a0@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using my BeagleBone White to debug some ftrace code and with the
help from people like Robert Nelson I was finally able to boot it and
test my kernel.

But I'm still having some other issues. The most annoying one is that
the new kernel assigns some random MAC address to my NIC and I can't
give my board the proper IP address via DHCP.

Seems there was talk about adding this via the device tree, but it was
rejected because U-Boot can do it. The problem I have is that U-Boot
doesn't!

I downloaded the latest U-Boot from git://git.denx.de/u-boot.git (Is
that the right place?) and had to tweak it so that I can boot a kernel
via tftp and still use the filesystem on the SD card.

When I place the 3.2 kernel that came with the board on my tftp server,
all works fine. I get the same MAC addr each boot and things just work.
But if I place the 3.16 kernel that I build on the tftp server, I get
some random MAC address, and then a dynamic IP to go with it :-(

This is in my dmesg:

[    2.304970] cpsw 4a100000.ethernet: Random MACID = 8a:fc:f5:aa:b6:e1

I can also see in the file arch/arm/boot/dts/am33xx.dtsi:


                        cpsw_emac0: slave@4a100200 {
                                /* Filled in by U-Boot */
                                mac-address = [ 00 00 00 00 00 00 ];
                        };

Well, it's not filled in by U-Boot.

My question to all of you is, how do I fix this? I need a static mac
addr.

One way is that I might have to update that file myself with a temp
patch, but I think that's a hack and not something worth doing.

What's the proper way to have the board always come up with the same
MAC addr?

Thanks, this is rather annoying.

-- Steve
