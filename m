Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab3JRR1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:27:40 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:63802 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445Ab3JRR1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:27:38 -0400
Message-ID: <52616F81.8060504@gmail.com>
Date: Fri, 18 Oct 2013 19:27:29 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
CC: Andrew Lunn <andrew@lunn.ch>, Kevin Hilman <khilman@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: kirkwood: remove lagacy clk workarounds
References: <1382097253-15624-1-git-send-email-sebastian.hesselbarth@gmail.com> <20131018144741.GL22434@titan.lakedaemon.net> <20131018161743.GA29595@localhost>
In-Reply-To: <20131018161743.GA29595@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2013 06:17 PM, Ezequiel Garcia wrote:
> On Fri, Oct 18, 2013 at 10:47:41AM -0400, Jason Cooper wrote:
>> On Fri, Oct 18, 2013 at 01:54:13PM +0200, Sebastian Hesselbarth wrote:
>>> With legacy devices converted to DT and a proper ethernet MAC
>>> workaround, we can now remove the clk workarounds for legacy
>>> devices. While at it, also cleanup the list of includes.
>>>
>>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>>> ---
>>> As a follow-up patch for latest mvebu PRs, this patch is based on
>>>   git://git.infradead.org/linux-mvebu.git tags/soc-3.13-2
>>>
>>> Cc: Jason Cooper <jason@lakedaemon.net>
>>> Cc: Andrew Lunn <andrew@lunn.ch>
>>> Cc: Russell King <linux@arm.linux.org.uk>
>>> Cc: Kevin Hilman <khilman@linaro.org>
>>> Cc: linux-arm-kernel@lists.infradead.org
>>> Cc: linux-kernel@vger.kernel.org
>>> ---
>>>   arch/arm/mach-kirkwood/board-dt.c |   42 ++----------------------------------
>>>   1 files changed, 3 insertions(+), 39 deletions(-)
>>
>> Applied to mvebu/soc
>>
>
> Weird: I've tried to do this clean-up myself and my usual tests with network
> built as a module failed somehow. Maybe I missed something and did something
> stupid?

Ezequiel,

you need commits
b5d82db net: mv643xx_eth: fix missing device_node for port devices
f564412 net: mv643xx_eth: fix orphaned statistics timer crash
041b4dd net: mv643xx_eth: update statistics timer from timer context only

from git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

Those are the three net driver fixes and have not yet been pulled into
mainline linux.

Can you re-test with those three applied (or you can just merge in
above master)? I am compiling right now and will report.

Sebastian
