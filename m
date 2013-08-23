Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab3HWLjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:39:40 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49611 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754599Ab3HWLjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:39:39 -0400
Message-ID: <521749E5.6020008@free-electrons.com>
Date: Fri, 23 Aug 2013 13:39:17 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 08/17] ARM: mvebu: remove custom .init_time hook
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376964271-22715-9-git-send-email-sebastian.hesselbarth@gmail.com> <52173408.1000702@free-electrons.com> <52173A3E.2040509@gmail.com>
In-Reply-To: <52173A3E.2040509@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/08/2013 12:32, Sebastian Hesselbarth wrote:
> On 08/23/13 12:06, Gregory CLEMENT wrote:
>> On 20/08/2013 04:04, Sebastian Hesselbarth wrote:
>>> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
>>> remove custom .init_time hooks.
>>
>> As a feared it won't work on Armada XP. You moved coherency_init(), and
>> l2x0_of_init() in the init_machine hook. However init_machine is an
>> arch_initcall, and as all the initcall it is called at the end of the
>> do_basic_setup() which is called after smp_prepare_cpus(). The issue is
>> that smp_prepare_cpus need coherency (and I think L2 cache) already enable.
> 
> Ok, I see. I remember mvebu smp relies on mbus mappings also? Can you
> try below as replacement for the mach-mvebu/armada-370-xp.c changes?
> 
> It will move coherency_init(), l2x0_of_init(), and mvebu_mbus_dt_init()
> to .init_early hook.
> 

I can't test it, because I don't receive the patch 1 and 2 neither directly
or through linux-arm-kernel (it should have been bounced), or even at
https://github.com/shesselba/linux-dove.git

If you don't want to send them again, could you at least push our branch on your
github?

Thanks

> Sebastian
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
