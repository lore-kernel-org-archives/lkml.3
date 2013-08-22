Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab3HVEOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 00:14:55 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51506 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab3HVEOy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 00:14:54 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Boyd <sboyd@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <51E8586C.7040808@codeaurora.org>
Cc: linux-kernel@vger.kernel.org,
        =?utf-8?q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        devicetree-discuss@lists.ozlabs.org, Tero Kristo <t-kristo@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Matt Sealey <neko@bakuhatsu.net>, linux-arm-kernel@lists.infradead.org
References: <1371795256-16703-1-git-send-email-mturquette@linaro.org>
 <51E8586C.7040808@codeaurora.org>
Message-ID: <20130822041448.8231.16182@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v3 0/5] clk: dt: bindings for mux, divider & gate clocks
Date: Wed, 21 Aug 2013 21:14:48 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Boyd (2013-07-18 14:04:44)
> On 06/20/13 23:14, Mike Turquette wrote:
> > This series introduces binding definitions for common register-mapped
> > clock multiplexer, divider and gate IP blocks along with the
> > corresponding setup functions for matching DT data.  The bindings are
> > similar to the struct definitions but please don't hold that against the
> > binding: the struct definitions closely model the hardware register
> > layout.
> 
> I know there was some discussion about clock bindings and how they
> should and should not be done at Linaro Connect Europe last week. Can
> someone in that discussion reply to the mailing list with what came out
> of that? I only have second hand knowledge about the discussion so it
> would be good for me and others to know what was discussed. I'm
> especially curious because the arm soc update etherpad[1] says "DT
> describes what HW is (location, type, attributes), not how HW works
> (register descriptions, bitmasks, etc)." but these proposed generic
> clock bindings are describing registers and bitmasks.

Hi Stephen,

I just happened across a to-do list note telling me to respond to this
email. Better late than never.

The meeting you're referring to did not focus on clock provider bindings
as much as it focused on a pair of standard clock attributes that could
be referenced by clock consumers. They are "assigned-clock-parent" and
"assigned-clock-rate". The usage scribbled on the white board[1] was
something like:

mux: mux {
	clocks = <&clock-foo>, <&clock-bar>;
};

uart: uart {
	clocks = <&mux>;
	assigned-clock-parent = <1>;
};

In the example above assigned-clock-parent uses the index of the mux,
but I prefer the following:

uart: uart {
	clocks = <&mux>;
	assigned-clock-parent = <&clock-bar>;
};

This is a way to establish initial configuration from the consumer's
perspective. Similarly something can be done for the clock rate with
assigned-clock-rate.

With all of that said this is consumer-level stuff. We'll definitely
talk about the clock provider DT bindings at the ARM Summit, which is
what you discuss above.

Regards,
Mike

[1] https://plus.google.com/u/0/107457854652287465481/posts/cvRveAupUpa

> 
> [1] http://pad.linaro.org/p/LCE13_ARM_SOC_Tree_Consolidation_Update
> 
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
