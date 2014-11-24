Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbaKXTIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:08:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:34838 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293AbaKXTIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:08:53 -0500
MIME-Version: 1.0
In-Reply-To: <1416685634-5864-3-git-send-email-al.kochet@gmail.com>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com>
	<1416685634-5864-1-git-send-email-al.kochet@gmail.com>
	<1416685634-5864-3-git-send-email-al.kochet@gmail.com>
Date: Mon, 24 Nov 2014 11:08:48 -0800
Message-ID: <CAMAWPa8whctBR6fBFaSzPvm3qn+QK06CimRrxFxxH=0kNkF4UA@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] i2c: omap: implement workaround for handling
 invalid BB-bit values
From: Kevin Hilman <khilman@kernel.org>
To: Alexander Kochetkov <al.kochet@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>
Cc: linux-omap <linux-omap@vger.kernel.org>, linux-i2c@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Wolfram Sang <wsa@the-dreams.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 11:47 AM, Alexander Kochetkov
<al.kochet@gmail.com> wrote:
> In a multimaster environment, after IP software reset, BB-bit value doesn't
> correspond to the current bus state. It may happen what BB-bit will be 0,
> while the bus is busy due to another I2C master activity.
>
> Any transfer started when BB=0 and bus is busy wouldn't be completed by IP
> and results in controller timeout. More over, in some cases IP could
> interrupt another master's transfer and corrupt data on wire.
>
> The commit implement method allowing to prevent IP from entering into
> "controller timeout" state and from "data corruption" state.
>
> The one drawback is the need to wait for 10ms before the first transfer.
>
> Tested on Beagleboard XM C.
> Tested on BBB and AM437x Starter Kit by Felipe Balbi.
>
> Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
> Tested-by: Felipe Balbi <balbi@ti.com>
> Reviewed-by: Felipe Balbi <balbi@ti.com>

This patch recently hit linux-next (as commit 903c3859f77f) and boot
breakage[1] in next-20141124 on OMAP3530 Beagle and Overo/Tobi boards
was bisected down to this commit.

Kevin

[1] http://status.armcloud.us/boot/?next-20141124&omap
