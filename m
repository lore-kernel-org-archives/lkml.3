Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbaCYStF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:49:05 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:46545 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbaCYStB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:49:01 -0400
MIME-Version: 1.0
In-Reply-To: <5331CD43.1010601@ahsoftware.de>
References: <1394016605-24120-1-git-send-email-sebastian.capella@linaro.org>
	<1394016605-24120-3-git-send-email-sebastian.capella@linaro.org>
	<20140316070917.GA3094@arch.cereza>
	<CADHgK6s58EJyJxB-47K8w26H8ZCBFQ2zu7PGAQU9O+2g7=fPwA@mail.gmail.com>
	<20140317204410.GA1118@arch.cereza>
	<CADHgK6tHngKVZS=jo=VYt3Nt3dhiEmiWr28iDy7q_uR9goBj=Q@mail.gmail.com>
	<20140319154434.GA3488@arch.cereza>
	<CADHgK6vLB3h0zrdpve=ZyjNu2pe1VYsGxrYgv=2C-JV37vE9tQ@mail.gmail.com>
	<CADHgK6vkwjXyJxRcOXjJpJJaR0-YR869NpPZ+CBBS8kEdE0qCQ@mail.gmail.com>
	<5331CD43.1010601@ahsoftware.de>
Date: Tue, 25 Mar 2014 11:48:59 -0700
Message-ID: <CADHgK6tqYH=47LJkJfg3ktormiJHimc3dQxg5vTAJm8H0NO6Wg@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] ARM hibernation / suspend-to-disk
From: Sebastian Capella <sebastian.capella@linaro.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Len Brown <len.brown@intel.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Austin <jonathan.austin@arm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Sricharan R <r.sricharan@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Russ Dill <Russ.Dill@ti.com>,
        Nicolas Pitre <nico@linaro.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jiang Liu <liuj97@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

Thanks for your comments.

I've posted a different solution for arm only here, that just causes a
while loop in machine_power_off in the event it's called but does not
halt.

https://lkml.org/lkml/2014/3/24/299

On 25 March 2014 11:38, Alexander Holler <holler@ahsoftware.de> wrote:
> Both states, power off and sys halt, do sound pretty final and I would
> assume something is broken, if power off is called before sys halt or vice
> versa. At least I would never expect that the reboot/poweroff/syshalt
> notifier may be called twice (and thats why the heartbeat-trigger may
> crash).
>
> But just in case, changing that behaviour in ledtrig-heartbeat.c would be
> pretty easy, just remove the heartbeat_reboot_notifier (which plays nice and
> deregisters the trigger on reboot) and use the panic_notifier (which doesn't
> unregister the trigger but just turns off the led) for reboot too. Another
> solution would be to unregister the reboot_notifier in the reboot_nofifier
> itself. I've just seen one watchdog driver (drivers/rtc/rtc-m41t80.c) which
> does that. But I still think such shouldn't be necessary (and I haven't had
> a look at other reboot_notifier users).

I hope this will all be handled by the loop in machine_power_off, so
maybe this will not be needed.

Thanks!

Sebastian
