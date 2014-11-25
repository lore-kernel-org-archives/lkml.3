Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaKYQ3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:29:47 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19169 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaKYQ3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:29:45 -0500
Message-ID: <5474AE31.8080901@oracle.com>
Date: Tue, 25 Nov 2014 08:28:33 -0800
From: santosh shilimkar <santosh.shilimkar@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kevin Hilman <khilman@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>, ssantosh@kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/2] ARM: keystone: pm: switch to use generic pm domains
References: <1415631557-22897-1-git-send-email-grygorii.strashko@ti.com> <15074721.IbfeeI3ajE@wuerfel> <54746349.3000306@ti.com> <2301239.aDOlWg3gEs@wuerfel> <5474846C.2000308@ti.com> <20141125140440.GF3836@n2100.arm.linux.org.uk> <54749804.8070400@ti.com>
In-Reply-To: <54749804.8070400@ti.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grygorii,

On 11/25/2014 6:53 AM, Grygorii Strashko wrote:
> Hi Russell,
>
> On 11/25/2014 04:04 PM, Russell King - ARM Linux wrote:
>> On Tue, Nov 25, 2014 at 03:30:20PM +0200, Grygorii Strashko wrote:
>>> On 11/25/2014 02:09 PM, Arnd Bergmann wrote:
>>>> It might be possible to do this implicitly if the driver calls clk_get(),
>>>> basically doing clk_get() (or another call if necessary) would prevent the
>>>> simple pmdomain from turning it off during suspend.
>>>
>>> Unfortunately, clk_get() will not work, because drivers still need to use it
>>> to get functional clocks even if they are not going to control them explicitly.
>>> For example, if it need to know clock's rate.
>>
>> If you don't want a clock to be turned off, then clk_get() it, then
>> clk_prepare() it, and finally clk_enable() it.
>>
>> Even if someone else gets it, the only time that a clock is turned off
>> is when _all_ users of it mutually agree that it can be turned off - by
>> every user disabling (and possibly unpreparing) it.
>>
>> So, if the PM domain code gets a clock, prepares and enables it, then
>> a driver gets the same clock, prepares and enables it also, it won't
>> be disabled until _both_ the PM domain code _and_ the driver disable
>> and unprepare the clock.
>>
>
> All 100% true :)
>
> But the question here is how prevent pm_clk domain (clock_ops.c) from
> getting the control on clock if this particular clock is optional from driver's
> perspective. So, only driver should control it. As opposite, all other clocks
> should be controlled by pm-domain (in case of GPD from .start/stop callbacks).
>
I know there has been lot of back and forth, we have done on getting
multiple clock handling and from the thread looks like we are converging
with simple power domain approach. Since we have already made several
different attempt to solve the problem and some how stumbled, I suggest
you to do a new RFC with new $subject so that we can get rest of the
folks eyes on it.

The reason I say that because may be just because of $subject, some
folks might ignore the thread ;-) and later raise objections.

Thanks for persisting with it.

Regards,
Santosh
