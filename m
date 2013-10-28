Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab3J1QSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:18:45 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33592 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab3J1QSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:18:44 -0400
Message-ID: <526E8E62.7070700@codeaurora.org>
Date: Mon, 28 Oct 2013 09:18:42 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        linux-arm-kernel@lists.infradead.org, rmk@arm.linux.org.uk,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] ARM: Kconfig: allow full nohz CPU accounting
References: <tip-31c1fc8187158cb80ccd57c19e024c55af901797@git.kernel.org> <20131016121416.GD12773@localhost.localdomain> <20131018163740.GA21983@codeaurora.org> <526DBEAA.4030707@linaro.org>
In-Reply-To: <526DBEAA.4030707@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/13 18:32, Kevin Hilman wrote:
> Hi Stephen,
>
> On 10/18/2013 09:37 AM, Stephen Boyd wrote:
>> On 10/16, Frederic Weisbecker wrote:
>>> On Thu, Oct 03, 2013 at 06:58:03AM -0700, tip-bot for Kevin Hilman wrote:
>>>> Commit-ID:  31c1fc8187158cb80ccd57c19e024c55af901797
>>>> Gitweb:     http://git.kernel.org/tip/31c1fc8187158cb80ccd57c19e024c55af901797
>>>> Author:     Kevin Hilman <khilman@linaro.org>
>>>> AuthorDate: Mon, 16 Sep 2013 15:28:22 -0700
>>>> Committer:  Frederic Weisbecker <fweisbec@gmail.com>
>>>> CommitDate: Mon, 30 Sep 2013 15:37:05 +0200
>>>>
>>>> ARM: Kconfig: allow full nohz CPU accounting
>>>>
>>>> With the 64-bit requirement removed from VIRT_CPU_ACCOUNTING_GEN,
>>>> allow ARM platforms to enable it.  Since VIRT_CPU_ACCOUNTING_GEN is a
>>>> dependency for full NO_HZ, this allows ARM platforms to enable full
>>>> NO_HZ as well.
>>> I realize that arm doesn't implement irq work raise. It hooks on the
>>> timer to execute pending irq work. You'll need to implement arch_irq_work_raise()
>>> and implement some sort of self IPI to trigger irq work. The full dynticks subsystem
>>> relies on that to work correctly. It often use that to re-evaluate and possibly restart
>>> the tick after scheduler, posix timer updates, etc...
>>>
>>> That notwithstanding that if you have no tick, tick based irq work can't
>>> work.
>>>
>> Something like this? The only problem is that this latches on to
>> the SMP support for IPIs. If CONFIG_SMP is disabled we won't get
>> arch_irq_work_raise() but perhaps that isn't so big of a deal? Or
>> we should think about exposing IPI support to UP systems on ARM.
> Care to submit a proper patch for this to LAKML?  or if you prefer I can
> do it (keeping your authorship.)   We need this for proper full NOHZ
> support on ARM.  Thanks.

Sure no problem. Let me write up some sort of commit text and I'll send
it off again.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

