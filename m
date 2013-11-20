Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab3KTTxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 14:53:21 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:65051 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001Ab3KTTxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 14:53:17 -0500
Message-ID: <528D132A.3010207@linaro.org>
Date: Wed, 20 Nov 2013 11:53:14 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Magnus Damm <magnus.damm@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        khilman@linaro.org, linux-sh@vger.kernel.org,
        daniel.lezcano@linaro.org, horms@verge.net.au, olof@lixom.net,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 01/03] clocksource: Add Kconfig entries for CMT, MTU2,
 TMU and STI
References: <20131106110508.6806.48070.sendpatchset@w520> <201311141340.38208.arnd@arndb.de> <528D001C.9010009@linaro.org> <201311202034.34384.arnd@arndb.de>
In-Reply-To: <201311202034.34384.arnd@arndb.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 11:34 AM, Arnd Bergmann wrote:
> On Wednesday 20 November 2013, John Stultz wrote:
>> On 11/14/2013 04:40 AM, Arnd Bergmann wrote:
>>
>> Sorry, somehow this mail slipped by me.
>>
>> So yea, as I mentioned earlier, the build testing is the one thing I
>> don't have a good argument against. But I still would rather not having
>> user prompts for these sorts of things.
>>
>> Even so, it seems to me that it would be better to still avoid prompting
>> the user for the build test and instead just always build the drivers if
>> BUILD_TEST is enabled.
>>
>> Is the driver by driver fine-granularity for build testing actually
>> worth having all the module prompts?  Or could we coarsen it a bit, and
>> have BUILT_TEST_TOPIC, so under kernel hacking or something you can
>> enable build testing and select the categories of items you want to
>> build (rather then having to go through them one by one?)
> I would much prefer keeping things consistent across subsystems, which
> means one symbol with prompt per driver. 

My main issue though is that with clocksource/clockevents, these are not
classic drivers. They are much closer to platform drivers, and in the
majority of cases are much more tightly bound to specific systems.

They were abstracted out to be more classic driver like, because that
gave us more flexibility to support various systems at runtime. I just
hate to see that flexibility abused at the cost of users trying to build
kernels that will boot on their devices.

> The only technical argument for
> this is that it lets you disable some drivers when they do break in a
> randconfig or allmodconfig build.
If you have to add special Kconfig annotation anyway to support
BUILD_TEST, why not ensure the drivers build before adding that
annotation? That way any build regressions will be more easily found
(and not accidentally missed because it wasn't enabled via randconfig),
and we don't have to pester users with redundant config options.

thanks
-john

