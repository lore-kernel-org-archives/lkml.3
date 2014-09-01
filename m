Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbaIAIfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:35:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:56501 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaIAIfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:35:20 -0400
Date: Mon, 1 Sep 2014 10:35:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleksij Rempel <linux@rempel-privat.de>
cc: linux-kernel@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: Writing clocksource driver, tips?
In-Reply-To: <54035154.6080306@rempel-privat.de>
Message-ID: <alpine.DEB.2.10.1409011029020.3333@nanos>
References: <54035154.6080306@rempel-privat.de>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Aug 2014, Oleksij Rempel wrote:
> - 1 timer can be used for clocksource other as  clock_event_device, how
> can i use other 2 timers on same controller. and how can i use other 3
> controllers?

All you need is two.

One for the clocksource (free running counter):

    100MHz is fine, it gives the timekeeping code nice
    granularity. There is no need for a wrap around interrupt. The
    core code knows how to deal with it.

The second one is for the clock event device

    Avoid a match timer if possible, it's a pain in the neck. Either a
    autoreloading timer for the periodic mode or a simple downcounting
    one for one shot mode is good enough.

The other timers are not of any value for Linux. Just leave them
alone.

Thanks,

	tglx
