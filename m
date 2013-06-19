Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab3FSUBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 16:01:36 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:45694 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935091Ab3FSUBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 16:01:33 -0400
From: Kevin Hilman <khilman@linaro.org>
To: <balbi@ti.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH 1/5] i2c: omap: fix spurious IRQs: disable/enable IRQ at INTC when idle
References: <1370630768-4077-1-git-send-email-grygorii.strashko@ti.com>
	<1370630768-4077-2-git-send-email-grygorii.strashko@ti.com>
	<87li6llk4w.fsf@linaro.org> <51C1F9FA.9000502@ti.com>
	<20130619193111.GD4779@arwen.pp.htv.fi>
Date: Wed, 19 Jun 2013 13:01:28 -0700
In-Reply-To: <20130619193111.GD4779@arwen.pp.htv.fi> (Felipe Balbi's message
	of "Wed, 19 Jun 2013 22:31:11 +0300")
Message-ID: <878v257tuv.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi <balbi@ti.com> writes:

[...]

> If you have 200 pm_runtime_get() followed by 200 pm_runtime_put() (put
> is called only after 200 gets, no put-get ping-pong), your
> ->runtime_resume() gets called once, your ->runtime_suspend() gets
> called once but your ->runtime_idle() will get called 200 times.

No. The driver's ->runtime_idle() will only be called when the usecount
goes to zero.

Kevin
