Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab3KVPJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:09:41 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52299 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826Ab3KVPJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:09:39 -0500
Message-ID: <528F7397.5070603@ti.com>
Date: Fri, 22 Nov 2013 09:09:11 -0600
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <benoit.cousson@linaro.org>,
        <santosh.shilimkar@ti.com>, <jgchunter@gmail.com>, <rnayak@ti.com>
Subject: Re: [PATCH 5/8] ARM: OMAP2+: timer: Introduce OF-friendly clocksource/clockevent
 system timers
References: <1385085414-9034-1-git-send-email-joelf@ti.com> <1385085414-9034-6-git-send-email-joelf@ti.com> <20131122035127.GA1417@saruman.home>
In-Reply-To: <20131122035127.GA1417@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 09:51 PM, Felipe Balbi wrote:
> Hi,
> 
> On Thu, Nov 21, 2013 at 07:56:51PM -0600, Joel Fernandes wrote:
> 
> [...]
> 
>> New functions for OF-only boot are introduced, and we can soon delete the old
>> versions once we migrate all platforms. Currently only AM335x is migrated and
> 
> actually, you don't need to initialize .init_timer at all in DT boot.

Actually we still do, because the plan is to keep the hwmod stuff that's
required in timer.c in a custom .init_time, and then of_clocksource_init maybe
called to do what you're suggesting but (not yet) more on that below.

> Just use CLKSOURCE_OF_DECLARE() and pass your omap_generic_timer_init()
> as argument (although, I'd call it omap_of_timer_init()).
> That will put of_device_id structure on a special section
> (__clksource_of_table) and pass your function as a data argument. That
> function will be called automatically during init.
>

I thought of doing that, but currently the timer selection for clocksource
is not a simple matching of compatible string, rather it is selecting the timer
based on properties such as ti,timer-alwon and such.

In omap3 for example, there are needs for specific timers and such have been
provided with the macros passing in timer id etc. Right now, this can be forced
through DT with the "ti,timer-clocksource" property I introduced. All this
selection algorithm is too complex to be handle directly by the
CLOCKSOURCE_OF_DECLARE / clocksource_of_init matching mechanism.

thanks,

-Joel


