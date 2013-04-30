Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005Ab3D3BLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 21:11:10 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:62255 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758753Ab3D3BLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 21:11:06 -0400
Message-ID: <517F1A27.3030206@linaro.org>
Date: Mon, 29 Apr 2013 18:11:03 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 07/15] clocksource: Provide unbind interface in sysfs
References: <20130425142452.908423538@linutronix.de> <20130425143435.964218245@linutronix.de>
In-Reply-To: <20130425143435.964218245@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 01:31 PM, Thomas Gleixner wrote:
> With the module refcount held for the current clocksource there is no
> way to unload the module.
>
> Provide a sysfs interface which allows to unbind the clocksource. One
> could argue that the clocksource override could be (ab)used to do so,
> but the clocksource override cannot be used from the kernel itself,
> while an unbind function can be used to programmatically check whether
> a clocksource can be shutdown or not.
>
> The unbind functionality uses the new skip current feature of
> clocksource_select and verifies that a fallback clocksource has been
> installed. If the clocksource which should be unbound is the current
> clocksource and no fallback can be found, unbind returns -EBUSY.
>
> This does not support the unbinding of a clocksource which is used as
> the watchdog clocksource. No point in fostering crappy hardware.

So.. if the clocksource you want to unbind is the highest rated 
continuous clocksource that doesn't need a watchdog (basically what's 
likely to be in-use and required to be unbinded), its likely to be 
selected as the watchdog already.

ie: on a system that has only HPET/ACPI_PM, you can't unbind HPET, since 
its a watchdog.

Or are you really wanting to prohibit this functionality for all 
CONFIG_CLOCKSOURCE_WATCHDOG hardware, which would be easier to do via 
build time ifdefs?

thanks
-john

