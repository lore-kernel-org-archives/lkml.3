Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab3HBA3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 20:29:07 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:42171 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3HBA3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 20:29:05 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 3/3] ARM: Kconfig: allow virt CPU accounting
References: <1372876601-23881-1-git-send-email-khilman@linaro.org>
	<1372876601-23881-4-git-send-email-khilman@linaro.org>
	<20130719161708.GB21752@somewhere>
Date: Thu, 01 Aug 2013 17:29:00 -0700
In-Reply-To: <20130719161708.GB21752@somewhere> (Frederic Weisbecker's message
	of "Fri, 19 Jul 2013 18:17:10 +0200")
Message-ID: <877gg5szoz.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> On Wed, Jul 03, 2013 at 11:36:41AM -0700, Kevin Hilman wrote:
>> With the 64-bit requirement removed from virt CPU accounting,
>> allow ARM platforms to enable it.
>> 
>> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
>> Signed-off-by: Kevin Hilman <khilman@linaro.org>
>> ---
>>  arch/arm/Kconfig | 1 +
>>  1 file changed, 1 insertion(+)
>> 
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index 136f263..7850612 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -61,6 +61,7 @@ config ARM
>>  	select OLD_SIGSUSPEND3
>>  	select OLD_SIGACTION
>>  	select HAVE_CONTEXT_TRACKING
>> +	select HAVE_VIRT_CPU_ACCOUNTING
>
> I think you got confused here. HAVE_VIRT_CPU_ACCOUNTING is the arch capability
> for VIRT_CPU_ACCOUNTING_NATIVE, not for VIRT_CPU_ACCOUNTING_GEN that only requires
> support for context tracking.

Yes, I am confused. :/

> That's my bad, all those names start to be confusing now.
> The VIRT based Kconfig naming is a bit weird, that doesn't really reflect what the feature
> is doing. "Virtual cputime accounting" just doesn't give any clue, except perhaps suggesting
> the stuff deals with virtualization while it actually has nothing to do with.
> I don't even know what virtual refers to here.
>
> Same goes for vtime based APIs. In fact I just based my work on the legacy that was
> there and expanded further the non-sense ;-)
>
> I'll need to do a big renaming one day.
>
> But to begin with I should rename s/HAVE_VIRT_CPU_ACCOUNTING/HAVE_VIRT_CPU_ACCOUNTING_NATIVE.

OK, I just tested and I can indeed drop this patch.

Thanks for clarifying,

Kevin

