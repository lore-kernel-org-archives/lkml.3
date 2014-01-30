Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbaA3Kbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 05:31:39 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:58276 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaA3Kbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 05:31:37 -0500
Message-ID: <52EA2A04.2070109@gmail.com>
Date: Thu, 30 Jan 2014 11:31:32 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] clk: mvebu: fix clk init order
References: <1390673950-4521-1-git-send-email-sebastian.hesselbarth@gmail.com> <52EA2875.5020807@free-electrons.com>
In-Reply-To: <52EA2875.5020807@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/14 11:24, Gregory CLEMENT wrote:
> On 25/01/2014 19:19, Sebastian Hesselbarth wrote:
>> This patch set fixes clk init order that went upside-down with
>> v3.14. I haven't really investigated what caused this, but I assume
>> it is related with DT node reordering by addresses.
>
> Can you explain what kind of issue do you observe?

Sure. When probing CLK_OF_DECLAREed clock drivers, clock-gating driver
gets registered before core-clocks. It therefore cannot resolve it's
parent clock name for tclk and all clock gates will have no parent
clock.

Usually, you'll see in some drivers (e.g. v643xx_eth) div_by_zero errors
poping up, when they calculate a frequency division factors based on
clock gate frequency, which should have been tclk but is 0 now.

> I have just tested the master branch of Linus and (excepted for SATA
> but Andrew will send a patch set soon), I didn't experiment any
> issues on Armada 370 and Armada XP based boards.

