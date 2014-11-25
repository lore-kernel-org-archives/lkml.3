Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaKYOzD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:55:03 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55455 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbaKYOy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:54:58 -0500
Message-ID: <54749804.8070400@ti.com>
Date: Tue, 25 Nov 2014 16:53:56 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kevin Hilman <khilman@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robh+dt@kernel.org>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>, <ssantosh@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 1/2] ARM: keystone: pm: switch to use generic pm domains
References: <1415631557-22897-1-git-send-email-grygorii.strashko@ti.com> <15074721.IbfeeI3ajE@wuerfel> <54746349.3000306@ti.com> <2301239.aDOlWg3gEs@wuerfel> <5474846C.2000308@ti.com> <20141125140440.GF3836@n2100.arm.linux.org.uk>
In-Reply-To: <20141125140440.GF3836@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On 11/25/2014 04:04 PM, Russell King - ARM Linux wrote:
> On Tue, Nov 25, 2014 at 03:30:20PM +0200, Grygorii Strashko wrote:
>> On 11/25/2014 02:09 PM, Arnd Bergmann wrote:
>>> It might be possible to do this implicitly if the driver calls clk_get(),
>>> basically doing clk_get() (or another call if necessary) would prevent the
>>> simple pmdomain from turning it off during suspend.
>>
>> Unfortunately, clk_get() will not work, because drivers still need to use it
>> to get functional clocks even if they are not going to control them explicitly.
>> For example, if it need to know clock's rate.
> 
> If you don't want a clock to be turned off, then clk_get() it, then
> clk_prepare() it, and finally clk_enable() it.
> 
> Even if someone else gets it, the only time that a clock is turned off
> is when _all_ users of it mutually agree that it can be turned off - by
> every user disabling (and possibly unpreparing) it.
> 
> So, if the PM domain code gets a clock, prepares and enables it, then
> a driver gets the same clock, prepares and enables it also, it won't
> be disabled until _both_ the PM domain code _and_ the driver disable
> and unprepare the clock.
> 

All 100% true :)

But the question here is how prevent pm_clk domain (clock_ops.c) from
getting the control on clock if this particular clock is optional from driver's
perspective. So, only driver should control it. As opposite, all other clocks
should be controlled by pm-domain (in case of GPD from .start/stop callbacks).

You can find more detailed description of problem which this patch was
created to solve here:
https://lkml.org/lkml/2014/11/19/225

Thanks for your time.

regards,
-grygorii
