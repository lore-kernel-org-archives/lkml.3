Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbaI3Bfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 21:35:48 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52190 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaI3Bfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 21:35:47 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: <linux-arm-kernel@lists.infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, linux-rockchip@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Marc Carino <marc.ceeeee@gmail.com>
Subject: [PATCH 0/5] ARM: move #include <asm/cp15.h> into cacheflush.h
Date: Mon, 29 Sep 2014 18:35:25 -0700
Message-Id: <1412040930-16864-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several places where an explicit include of <asm/cp15.h> is needed
just because cacheflush.h uses one of its macros in v7_exit_coherency_flush().
Let's put the include in the proper header.

These obviously have some dependencies, so I'd focus on:
  (1) Is patch 1 acceptable? If so, then:
  (2) Make sure patch 1 is serialized before the rest

I did a cursory scan of every file that includes cp15.h, and these are the only
ones I found that only needed it for the sake of v7_exit_coherency_flush().

These are barely compile tested.

Thanks,
Brian

Brian Norris (5):
  ARM: include missing cp15.h header
  ARM: mvebu: drop unnecessary include
  ARM: rockchip: drop unnecessary include
  ARM: vexpress: drop unnecessary include
  ARM: brcmstb: drop unnecessary include

 arch/arm/include/asm/cacheflush.h   | 1 +
 arch/arm/mach-bcm/platsmp-brcmstb.c | 1 -
 arch/arm/mach-mvebu/pmsu.c          | 1 -
 arch/arm/mach-rockchip/platsmp.c    | 1 -
 arch/arm/mach-vexpress/dcscb.c      | 1 -
 arch/arm/mach-vexpress/tc2_pm.c     | 1 -
 6 files changed, 1 insertion(+), 5 deletions(-)

-- 
1.9.1

