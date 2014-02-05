Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbaBEOIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 09:08:11 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36363 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaBEOIJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 09:08:09 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "Sebastian Hesselbarth" <sebastian.hesselbarth@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1390673950-4521-1-git-send-email-sebastian.hesselbarth@gmail.com>
Cc: "Jason Cooper" <jason@lakedaemon.net>, "Andrew Lunn" <andrew@lunn.ch>,
        "Gregory Clement" <gregory.clement@free-electrons.com>,
        "Thomas Petazzoni" <thomas.petazzoni@free-electrons.com>,
        "Ezequiel Garcia" <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1390673950-4521-1-git-send-email-sebastian.hesselbarth@gmail.com>
Message-ID: <20140205140802.9977.19747@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 0/4] clk: mvebu: fix clk init order
Date: Wed, 05 Feb 2014 06:08:02 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sebastian Hesselbarth (2014-01-25 10:19:06)
> This patch set fixes clk init order that went upside-down with
> v3.14. I haven't really investigated what caused this, but I assume
> it is related with DT node reordering by addresses.
> 
> Anyway, with v3.14 for MVEBU SoCs, the clock gating driver gets
> registered before core clocks driver. Unfortunately, we cannot
> return -EPROBE_DEFER in drivers initialized by clk_of_init. As the
> init order for our drivers is always core clocks before clock gating,
> we maintain init order ourselves by hooking CLK_OF_DECLARE to one
> init function that will register core clocks before clock gating
> driver.
> 
> This patch is based on pre-v3.14-rc1 mainline and should go in as
> fixes for it. As we now send MVEBU clk pull-requests to Mike directly,
> I suggest Jason picks it up as a topic branch.

Sebastian,

These patches look OK to me. I'd rather take Gregory Clement's "respect
the clock dependencies in of_clk_init" patch towards 3.15, so this fix
will still be necessary for the current -rc's.

Jason, will you be sending a PR?

Thanks,
Mike

> 
> The patches have been boot tested on Dove and compile-tested only
> for Kirkwood, Armada 370 and XP.
> 
> Sebastian Hesselbarth (4):
>   clk: mvebu: armada-370: maintain clock init order
>   clk: mvebu: armada-xp: maintain clock init order
>   clk: mvebu: dove: maintain clock init order
>   clk: mvebu: kirkwood: maintain clock init order
> 
>  drivers/clk/mvebu/armada-370.c | 21 ++++++++++-----------
>  drivers/clk/mvebu/armada-xp.c  | 20 +++++++++-----------
>  drivers/clk/mvebu/dove.c       | 19 +++++++++----------
>  drivers/clk/mvebu/kirkwood.c   | 34 ++++++++++++++++------------------
>  4 files changed, 44 insertions(+), 50 deletions(-)
> 
> ---
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> -- 
> 1.8.5.2
> 
