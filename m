Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323AbaLOVXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:23:54 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64982 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750722AbaLOVXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:23:52 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Mike Turquette <mturquette@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] genirq: Support mixing IRQF_NO_SUSPEND/IRQF_SUSPEND on shared irqs
Date: Mon, 15 Dec 2014 22:45:35 +0100
Message-ID: <2845526.bsrmWSBaOD@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418660152-17185-2-git-send-email-boris.brezillon@free-electrons.com>
References: <1418660152-17185-1-git-send-email-boris.brezillon@free-electrons.com> <1418660152-17185-2-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 15, 2014 05:15:48 PM Boris Brezillon wrote:
> The current implementation forbid sharing an irq line on devices that do
> not request the same behavior on suspend/resume (controlled via the
> IRQF_NO_SUSPEND/IRQF_FORCE_RESUME flags).

IRQF_NO_SUSPEND is practically only for timers and IPIs now.  Any other
usages are strongly discouraged.

> Add a flag (IRQF_SUSPEND_NOACTION) to specify that you don't want to be
> called in suspend mode, and that you already took care of disabling the
> interrupt on the device side.
> 
> The suspend_device_irq will now move actions specifying the
> IRQF_SUSPEND_NOACTION into a temporary list so that they won't be called
> when the interrupt is triggered, and resume_irq_actions restores the
> suspended actions into the active action list.

Why is the current way of handling wakeup interrupts not sufficient?


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
