Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaBGPBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 10:01:52 -0500
Received: from yotta.elopez.com.ar ([31.220.24.173]:32954 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaBGPBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 10:01:50 -0500
Message-ID: <52F4F502.2010703@elopez.com.ar>
Date: Fri, 07 Feb 2014 12:00:18 -0300
From: =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
CC: Mike Turquette <mturquette@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] clk: respect the clock dependencies in of_clk_init
References: <1391554766-11285-1-git-send-email-gregory.clement@free-electrons.com> <52F4DA40.4090804@elopez.com.ar> <20140207142430.GU8533@titan.lakedaemon.net> <20140207144325.GA8218@localhost> <52F4F279.6010006@free-electrons.com>
In-Reply-To: <52F4F279.6010006@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 07/02/14 11:49, Gregory CLEMENT escribió:
> On 07/02/2014 15:43, Ezequiel Garcia wrote:
>> On Fri, Feb 07, 2014 at 09:24:30AM -0500, Jason Cooper wrote:
>>> On Fri, Feb 07, 2014 at 10:06:08AM -0300, Emilio López wrote:
>>>
>>> [snip a great explanation]
>>>
>>> Guys, can I get some Tested-by's on this?
>>>
>>
>> In case someone missed Emilio's comment about it, I gave his oneliner
>> a test on A370 Reference Design. It worked just as well as Sebastian's.
>
> Well ok it's working but this patch is not better than Sebastian, it is
> even worth. I don't think it is a good idea at all to totally ignore the
> information given by the device tree.

With a bit more work, you can replace the clk_get magic with a call to 
of_clk_get_parent_name() or similar to be able to keep overriding stuff 
from DT. This way it would completely match the behaviour on 
mvebu_coreclk_setup (default to "tclk", allow overriding with DT).

Emilio
