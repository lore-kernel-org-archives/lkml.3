Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab3HTUTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:19:33 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:43600 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3HTUTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:19:32 -0400
Message-ID: <5213CF58.50703@gmail.com>
Date: Tue, 20 Aug 2013 22:19:36 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 02/17] ARM: call clk_of_init from time_init
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376964271-22715-3-git-send-email-sebastian.hesselbarth@gmail.com> <52138F56.6030008@wwwdotorg.org> <5213C7E1.4070401@gmail.com> <5213C90F.9010407@wwwdotorg.org>
In-Reply-To: <5213C90F.9010407@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 09:52 PM, Stephen Warren wrote:
> On 08/20/2013 01:47 PM, Sebastian Hesselbarth wrote:
>> On 08/20/2013 05:46 PM, Stephen Warren wrote:
>>> Some SoCs call this function in .init_irq() rather than .init_time().
>>> Perhaps we adjust this patch to do that instead. That way, we can
>>> presumably get rid of patch 1/17 since we can eliminate any duplicate
>>> calls, and adjust patch 14/17 (Tegra board file) to remove its custom
>>> call to of_clock_init(NULL)?
>>
>> Currently as of -next from yesterday, only tegra is requiring clocks
>> that early, while others are fine with them close to timers. I really
>> have no strong opinion on that. That decision should rather be made
>> by those with a far more complete insight of the consequences than I
>> have.
>
> Perhaps if Tegra is a special-case, it shouldn't rely on the generic
> init_time() callback, and hence you could still eliminate patch 1/17?
>

Perhaps Tegra is the common case but other SoC haven't dug deep enough?
IMHO from a HW point-of-view clocks are really among the essential
things that need to be running before you can do anything useful.

Just consider boot loaders that run fine without irqs but don't without
clocks (even if just represented by API). Maybe you are right, and we
should call of_clk_init(NULL) as early as possible. That would also
eliminate patch 1/17 as you suggest.

Sebastian
