Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaKHAXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 19:23:47 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60004 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753372AbaKHAXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 19:23:45 -0500
Date: Sat, 8 Nov 2014 00:23:34 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Doug Anderson <dianders@chromium.org>
Cc: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: Propagate prepare and enable when reparenting
 orphans
Message-ID: <20141108002334.GT4042@n2100.arm.linux.org.uk>
References: <1415386312-23741-1-git-send-email-dianders@chromium.org>
 <20141107185844.GR4042@n2100.arm.linux.org.uk>
 <CAD=FV=WhWqMB=-ErD-59-z=y7OCZx4r7REkr3DpyYR=76SEJ6A@mail.gmail.com>
 <20141107233607.GS4042@n2100.arm.linux.org.uk>
 <CAD=FV=WCwGjuLNFPANqqq-+rEN_jhqi+Bfss2ugDJEgjf3z_Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=WCwGjuLNFPANqqq-+rEN_jhqi+Bfss2ugDJEgjf3z_Gg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 04:14:23PM -0800, Doug Anderson wrote:
> Russell,
> I guess I'm still confused.  My patch continues to be about orphans
> and I don't see the bug you are pointing to.

Ah, in which case, the question changes: how can an orphaned clock be
succesfully prepared and enabled?

Drivers expect that a clock for which clk_enable() has returned
successfully _will_ at that point be supplying the clock.  If we don't
yet know it's parent, how do we know that it will be supplying that
clock?

What about a driver calling clk_set_rate() on an orphaned clock?

>From what I can see (__clk_reparent will re-set the child's clock when
reparenting) having a driver able to claim an orphaned clock, let
alone prepare and enable it, looks rather buggy to me.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
