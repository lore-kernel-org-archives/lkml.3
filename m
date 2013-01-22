Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3AVGXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 01:23:30 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51647 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab3AVGX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 01:23:29 -0500
Message-ID: <50FE307F.9000701@ti.com>
Date: Tue, 22 Jan 2013 11:53:59 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>,
        Matt Sealey <matt@genesi-usa.com>, LKML <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben@simtec.co.uk>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <201301212041.17951.arnd@arndb.de> <20130121210341.GW23505@n2100.arm.linux.org.uk> <20130121232322.GK15361@atomide.com>
In-Reply-To: <20130121232322.GK15361@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2013 04:53 AM, Tony Lindgren wrote:
> * Russell King - ARM Linux <linux@arm.linux.org.uk> [130121 13:07]:
>>
>> As for Samsung and the rest I can't comment.  The original reason OMAP
>> used this though was because the 32768Hz counter can't produce 100Hz
>> without a .1% error - too much error under pre-clocksource
>> implementations for timekeeping.  Whether that's changed with the
>> clocksource/clockevent support needs to be checked.
>
> Yes that's why HZ was originally set to 128. That value (or some multiple)
> still makes sense when the 32 KiHZ clock source is being used. Of course
> we should rely on the local timer when running for the SoCs that have
> them.
>
This is right. It was only because of the drift associated when clocked
with 32KHz. Even on SOCs where local timers are available for power
management reasons we need to switch to 32KHz clocked device in
low power states. Hence the HZ value should be multiple of 32 on
OMAP.

Regards
Santosh

