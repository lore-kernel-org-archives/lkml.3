Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab3HWMNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:13:35 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:50072 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab3HWMNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:13:34 -0400
Message-ID: <521751E9.3000504@gmail.com>
Date: Fri, 23 Aug 2013 14:13:29 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 08/17] ARM: mvebu: remove custom .init_time hook
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376964271-22715-9-git-send-email-sebastian.hesselbarth@gmail.com> <52173408.1000702@free-electrons.com> <52173A3E.2040509@gmail.com> <521749E5.6020008@free-electrons.com>
In-Reply-To: <521749E5.6020008@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/13 13:39, Gregory CLEMENT wrote:
> On 23/08/2013 12:32, Sebastian Hesselbarth wrote:
>> On 08/23/13 12:06, Gregory CLEMENT wrote:
>>> On 20/08/2013 04:04, Sebastian Hesselbarth wrote:
>>>> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
>>>> remove custom .init_time hooks.
>>>
>>> As a feared it won't work on Armada XP. You moved coherency_init(), and
>>> l2x0_of_init() in the init_machine hook. However init_machine is an
>>> arch_initcall, and as all the initcall it is called at the end of the
>>> do_basic_setup() which is called after smp_prepare_cpus(). The issue is
>>> that smp_prepare_cpus need coherency (and I think L2 cache) already enable.
>>
>> Ok, I see. I remember mvebu smp relies on mbus mappings also? Can you
>> try below as replacement for the mach-mvebu/armada-370-xp.c changes?
>>
>> It will move coherency_init(), l2x0_of_init(), and mvebu_mbus_dt_init()
>> to .init_early hook.
>>
>
> I can't test it, because I don't receive the patch 1 and 2 neither directly
> or through linux-arm-kernel (it should have been bounced), or even at
> https://github.com/shesselba/linux-dove.git
>
> If you don't want to send them again, could you at least push our branch on your
> github?

Gregory,

I pushed a branch containing the latest state to
https://github.com/shesselba/linux-dove.git arm-clk-of-init

It still contains the changes to drivers/clk.c, that will become
obsolete, if there are no objections against Stephen's tegra patch.

Sebastian

