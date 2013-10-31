Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab3JaSze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 14:55:34 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37748 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab3JaSzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 14:55:32 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-fa-5272a7a2dc85
Message-id: <5272A7A0.7020800@samsung.com>
Date: Thu, 31 Oct 2013 19:55:28 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, jiada_wang@mentor.com,
        kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
        linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        linux-mips@linux-mips.org, linux-sh@vger.kernel.org,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH v7 5/5] clk: Implement clk_unregister()
References: <1383076268-8984-1-git-send-email-s.nawrocki@samsung.com>
 <1383076268-8984-6-git-send-email-s.nawrocki@samsung.com>
 <5272A24A.30800@wwwdotorg.org>
In-reply-to: <5272A24A.30800@wwwdotorg.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t/xq7qLlhcFGXyaZW3R86fS4mzTG3aL
	zolL2C02Pb7GanF51xw2iwlTJ7FbHFzYxmgx588UZovbl3ktnk64yGbx6mAbi8XChi/sDjwe
	Lc09bB4rp3t7zO6Yyepx59oeNo+jK9cyeWxeUu+x+2sTo0ffllWMHp83yXlsnBsawBXFZZOS
	mpNZllqkb5fAlbHrwxe2gu/cFWu2XGVuYLzK2cXIySEhYCIx4WQfI4QtJnHh3nq2LkYuDiGB
	pYwS69ZOZwNJCAl8YpR4Od0DxOYV0JLY9rybBcRmEVCVeL92DTOIzSZgKNF7FGKQqECYxNGm
	n6wQ9YISPybfA6sXAeqd9OwfI8gCZoG3TBKHpvSCFQkLWEvMWHqLBWLzIkaJW7uus4MkOAW0
	JRr//QfbwCygI7G/dRobhC0vsXnNW+YJjAKzkCyZhaRsFpKyBYzMqxhFU0uTC4qT0nMN9YoT
	c4tL89L1kvNzNzFCYujLDsbFx6wOMQpwMCrx8L7oKwoSYk0sK67MPcQowcGsJMIrkgMU4k1J
	rKxKLcqPLyrNSS0+xMjEwSnVwOhgP99/bc+ve7sKJT+f+3aSK2Rdcf0sV8EXpTtYDx+etvvy
	U02JSb5X3nV1pM9O8Gwy8Tl1uWXGjhrWskf7JDbnOl5vSg0/3/C/adEFrXnurgVipWUPOk6e
	eZzGfpA/sDBR71SI2Jrbk8U3dDx6s5rBzd7gfsq9/dW652xM5x+dvLZsUlfMlB9KLMUZiYZa
	zEXFiQDJURO/fwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/10/13 19:32, Stephen Warren wrote:
> On 10/29/2013 01:51 PM, Sylwester Nawrocki wrote:
>> > clk_unregister() is currently not implemented and it is required when
>> > a clock provider module needs to be unloaded.
>> > 
>> > Normally the clock supplier module is prevented to be unloaded by
>> > taking reference on the module in clk_get().
>> > 
>> > For cases when the clock supplier module deinitializes despite the
>> > consumers of its clocks holding a reference on the module, e.g. when
>> > the driver is unbound through "unbind" sysfs attribute, there are
>> > empty clock ops added. These ops are assigned temporarily to struct
>> > clk and used until all consumers release the clock, to avoid invoking
>> > callbacks from the module which just got removed.
>
> This patch is now in Mike's clk-next and hence next-20131031, and causes
> both a WARN and an OOPS when booting the Tegra Dalmore board. (See log
> below)
> 
> If I do the following to fix some other issues:
> 
> 1) Apply:
> http://www.spinics.net/lists/arm-kernel/msg283619.html
> clk: fix boot panic with non-dev-associated clocks
> 
> 2) Merge some Tegra-specific bug-fixes:
> https://lkml.org/lkml/2013/10/29/771
> Re: pull request for Tegra clock rework and Tegra124 clock support
> 
> ... then revert this patch a336ed7 "clk: Implement clk_unregister()",
> everything works again.

Does it still crash when you apply this patch
http://www.spinics.net/lists/arm-kernel/msg283550.html ?

--
Thanks,
Sylwester
