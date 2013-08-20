Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab3HTTrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 15:47:43 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:48438 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3HTTrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 15:47:41 -0400
Message-ID: <5213C7E1.4070401@gmail.com>
Date: Tue, 20 Aug 2013 21:47:45 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 02/17] ARM: call clk_of_init from time_init
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376964271-22715-3-git-send-email-sebastian.hesselbarth@gmail.com> <52138F56.6030008@wwwdotorg.org>
In-Reply-To: <52138F56.6030008@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 05:46 PM, Stephen Warren wrote:
> On 08/19/2013 08:04 PM, Sebastian Hesselbarth wrote:
>> Most DT ARM machs require common clock providers initialized before timers.
>> Currently, arch/arm machs use .init_time to call clk_of_init right before
>> clocksource_of_init. This prevents to remove that hook and use the default
>> hook instead. clk_of_init now checks for multiple calls to it, so add
>> the call to ARM arch time_init by default.
>
> Some SoCs call this function in .init_irq() rather than .init_time().
> Perhaps we adjust this patch to do that instead. That way, we can
> presumably get rid of patch 1/17 since we can eliminate any duplicate
> calls, and adjust patch 14/17 (Tegra board file) to remove its custom
> call to of_clock_init(NULL)?

Currently as of -next from yesterday, only tegra is requiring clocks
that early, while others are fine with them close to timers. I really
have no strong opinion on that. That decision should rather be made
by those with a far more complete insight of the consequences than I
have.

Sebastian
