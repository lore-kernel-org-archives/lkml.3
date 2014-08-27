Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbaH0Ali (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 20:41:38 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:39893 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437AbaH0Alh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 20:41:37 -0400
Date: Wed, 27 Aug 2014 02:35:27 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Mike Turquette <mturquette@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>, Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin@rab.in>, Tomasz Figa <t.figa@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 3/8] cpufreq: kirkwood: Remove use of the clk provider
 API
Message-ID: <20140827003527.GA6149@lunn.ch>
References: <1408375833-10703-1-git-send-email-tomeu.vizoso@collabora.com>
 <1408375833-10703-4-git-send-email-tomeu.vizoso@collabora.com>
 <20140820225513.5251.284@quantum>
 <53F5A587.9030200@collabora.com>
 <20140821133825.GH8608@lunn.ch>
 <20140822192933.5251.53733@quantum>
 <20140822201112.GH17277@lunn.ch>
 <20140826214631.5251.66177@quantum>
 <20140826223637.GA5324@lunn.ch>
 <20140826233008.5251.50447@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140826233008.5251.50447@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One final thought I have had is that it might be a good idea to have a
> mux clock which represents the clock signal that feeds into the cpu. It
> seems that a mux is exactly what is going on here with cpuclk rate and
> ddrclk rate.

I did think of this when i implemented the cpufreq driver. What makes
it hard is that this bit is mixed in the same 32 bit register as the
gate clocks. It would mean two clock providers sharing the same
register, sharing a spinlock, etc. And the gating provider is shared
with all mvebu platforms, dove, kirkword, orion5x, and four different
armada SoCs. So i'm pushing complexity into this shared code, which
none of the others need. Does the standard mux clock do what is
needed? Or would i have to write a new clock provider?

> I even wonder if it is even appropriate to model this transition with a
> clock enable operation? Maybe it is only a multiplex operation, or
> perhaps a combination of enabling the powersave clock and changing the
> parent input to the cpu?
> 
> My idea is instead of relying on a cpufreq driver to parse the state of
> your clocks and understand the multiplexing, you can use the clock
> framework for that. In fact that might help you get one step closer to
> using the cpufreq-cpu0.c/cpufreq-generic.c implementation.

So you want the whole disabling of interrupt delivery to the cpu,
flipping the mux, wait for interrupt and re-enabling of interrupt
delivery to the cpu inside the clock provider? That is way past a
simple mux clock.

       Andrew
