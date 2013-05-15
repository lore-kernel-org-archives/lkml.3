Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834Ab3EOSlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 14:41:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:58778 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759672Ab3EOSln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 14:41:43 -0400
Date: Wed, 15 May 2013 20:41:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 07/15] clocksource: Provide unbind interface in sysfs
In-Reply-To: <5193BD85.8030803@linaro.org>
Message-ID: <alpine.LFD.2.02.1305152039350.1388@ionos>
References: <20130425142452.908423538@linutronix.de> <20130425143435.964218245@linutronix.de> <517F1A27.3030206@linaro.org> <alpine.LFD.2.02.1305151144550.1388@ionos> <5193BD85.8030803@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 May 2013, John Stultz wrote:
> On 05/15/2013 02:47 AM, Thomas Gleixner wrote:
> > TSC is current clocksource and we only have ACPI_PM as watchdog and
> > its used. So now you try to unbind ACPI_PM then the TSC would be left
> > w/o a watchdog instance. That's what I'm preventing. Will reword the
> > changelog accordingly.
> 
> You might double check the logic, because I feel like I actually hit this
> issue where on my vm machine w/ only hpet/acpi_pm I couldn't unbind the hpet.

Yes, that might be true. I'm only checking whether the clocksource is
assigned watchdog duty. So now if the TSC is not available we still
assign watchdog duty to HPET and therefor unbinding it does not work.

I really don't worry about that. The whole watchdog workaround is
horrible and all I want to prevent is wreckage of that fragile piece
of ...

Thanks,

	tglx

