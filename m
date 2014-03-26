Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbaCZQCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 12:02:47 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54172 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750956AbaCZQCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 12:02:45 -0400
Message-ID: <5332FA20.4010206@free-electrons.com>
Date: Wed, 26 Mar 2014 17:02:40 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: Mike Turquette <mturquette@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Shawn Guo <shawn.guo@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Olof Johansson <olof@lixom.net>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v3] clk: respect the clock dependencies in of_clk_init
References: <1393265413-16641-1-git-send-email-gregory.clement@free-electrons.com> <531068F4.3060903@free-electrons.com> <20140321035233.32624.98694@quantum> <CAGa+x85XLDZqCkz9R95d2Vj9eODx4q8W=9QhmMfivdPf2GdsaQ@mail.gmail.com>
In-Reply-To: <CAGa+x85XLDZqCkz9R95d2Vj9eODx4q8W=9QhmMfivdPf2GdsaQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/03/2014 16:19, Kevin Hilman wrote:
> [+ imx6 maintainers ]
> 
> On Thu, Mar 20, 2014 at 8:52 PM, Mike Turquette <mturquette@linaro.org> wrote:
>> Quoting Gregory CLEMENT (2014-02-28 02:46:12)
>>> Hi Mike,
>>>
>>> On 24/02/2014 19:10, Gregory CLEMENT wrote:
>>>> Until now the clock providers were initialized in the order found in
>>>> the device tree. This led to have the dependencies between the clocks
>>>> not respected: children clocks could be initialized before their
>>>> parent clocks.
>>>>
>>>> Instead of forcing each platform to manage its own initialization order,
>>>> this patch adds this work inside the framework itself.
>>>>
>>>> Using the data of the device tree the of_clk_init function now delayed
>>>> the initialization of a clock provider if its parent provider was not
>>>> ready yet.
>>>>
>>>> The strict dependency check (all parents of a given clk must be
>>>> initialized) was added by Boris BREZILLON
>>>
>>> Are you ok with this version?
>>> Will you take it for 3.15?
>>> Or maybe you expected that it will be part of a pull request?
>>>
>>> However as it is modifying the core of the framework I thought that you
>>> would take it and apply yourself.
>>
>> Hi Gregory,
>>
>> I have taken this into clk-next. If no regressions pop up over the next
>> few days then it should go into 3.15.
> 
> $SUBJECT patch (as commit 1771b10d605) is in -next has been fingered
> by bisection to be the reason behind boot failures[1] on imx6 wand
> boards in the last several -next kernels.
> 
> Reverting the patch on top of next/master gets these boards booting again.
> 
> The boot failures result in no console output, so I haven't done any
> further debugging.

I don't have any imx6 board, but should it be possible for you or the imx6
maintainer to add earlyprintk to see exactly what happen here?


Thanks,

Gregory


> 
> Kevin
> 
> [1] http://lists.linaro.org/pipermail/kernel-build-reports/2014-March/002927.html
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
