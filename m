Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411AbaI3EaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 00:30:12 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:64109 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaI3EaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 00:30:10 -0400
Date: Tue, 30 Sep 2014 00:30:06 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Brian Norris <computersforpeace@gmail.com>
cc: linux-arm-kernel@lists.infradead.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, linux-rockchip@lists.infradead.org,
        Marc Carino <marc.ceeeee@gmail.com>
Subject: Re: [PATCH 0/5] ARM: move #include <asm/cp15.h> into cacheflush.h
In-Reply-To: <1412040930-16864-1-git-send-email-computersforpeace@gmail.com>
Message-ID: <alpine.LFD.2.11.1409300016060.5311@knanqh.ubzr>
References: <1412040930-16864-1-git-send-email-computersforpeace@gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014, Brian Norris wrote:

> There are several places where an explicit include of <asm/cp15.h> is needed
> just because cacheflush.h uses one of its macros in v7_exit_coherency_flush().
> Let's put the include in the proper header.
> 
> These obviously have some dependencies, so I'd focus on:
>   (1) Is patch 1 acceptable? If so, then:

Well, I'm wondering if it is really a gain to force a dependency for 
cp15.h on every user of cacheflush.h just because of the seldomly used 
v7_exit_coherency_flush(). But I don't mind either ways.


Nicolas
