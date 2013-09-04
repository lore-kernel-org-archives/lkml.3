Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761297Ab3IDUwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:52:15 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:64033 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325Ab3IDUwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:52:13 -0400
Message-ID: <52279D79.9070408@gmail.com>
Date: Wed, 04 Sep 2013 22:52:09 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130827 Icedove/17.0.8
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH RFC v2 01/16] ARM: call clk_of_init from time_init
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <3837b119-baad-4e68-8805-2bc52c0135f9@DB9EHSMHS031.ehs.local> <521D2F1F.1070103@gmail.com> <201308291545.37520.arnd@arndb.de> <52278AC8.5080103@gmail.com> <6ba67c93-e0d0-42d4-b0a5-55c06938a15e@DB9EHSMHS013.ehs.local>
In-Reply-To: <6ba67c93-e0d0-42d4-b0a5-55c06938a15e@DB9EHSMHS013.ehs.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 10:41 PM, Sören Brinkmann wrote:
> On Wed, Sep 04, 2013 at 09:32:24PM +0200, Sebastian Hesselbarth wrote:
> [ ... ]
>> For mach-zynq I prepared a patch set that brings it close to .init_time
>> removal. I have pushed it to
>>    https://github.com/shesselba/linux-dove.git zynq-clk-init-v1
>> and will maybe post a patch set after this one is done.
>
> I think Steffen had a similar approach and we turned it down:
> Your proposal lets the clkc map the SLCR's registers. I think
> that approach is not right. It might be okay now, since the
> SLCR driver is pretty much a useless skeleton. But in general,
> there is a driver for the SLCR which maps that register
> region. No other driver should mess with it.
>
> Actually, one early version of my clkc looked pretty much like what you
> propose now and we changed it because of above reason.

Erm, passing the base address to clkc is less "mess with it" then
get it from DT?

Anyways, having a custom .init_time gives you full control over
of_clk_init and clocksource_of_init back again thanks to your
suggestion.

I'll stop converting zynq and let you decide on your own ;)

Sebastian
