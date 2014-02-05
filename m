Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613AbaBEU2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:28:05 -0500
Received: from www.linutronix.de ([62.245.132.108]:57120 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932571AbaBEU15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:27:57 -0500
Date: Wed, 5 Feb 2014 21:27:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
cc: santosh.shilimkar@ti.com, rob@landley.net, linux@arm.linux.org.uk,
        galak@codeaurora.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        daniel.lezcano@linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, grygorii.strashko@ti.com
Subject: Re: [PATCH v5 1/3] clocksource: timer-keystone: introduce clocksource
 driver for Keystone
In-Reply-To: <1391608060-10760-2-git-send-email-ivan.khoronzhuk@ti.com>
Message-ID: <alpine.DEB.2.02.1402052123560.24986@ionos.tec.linutronix.de>
References: <1391608060-10760-1-git-send-email-ivan.khoronzhuk@ti.com> <1391608060-10760-2-git-send-email-ivan.khoronzhuk@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014, Ivan Khoronzhuk wrote:
> +	/* here we have to be sure the timer has been disabled */

Sigh. This is not a proper explanation for a barrier, really. You want
to explain what it serializes against what. i.e. you want to explain
why you are using the relaxed functions and avoid a separate non
relaxed variant in favour of an explicit barrier.

> +	__iowmb();

The proper thing is to have an inline function key_stone_barrier() and
a full explanation of the issue in exactly that place instead of
handwaving comments here and there.

Thanks,

	tglx
