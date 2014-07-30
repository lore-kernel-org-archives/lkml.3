Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaG3UxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 16:53:08 -0400
Received: from mail.active-venture.com ([67.228.131.205]:65092 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbaG3UxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 16:53:06 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53D95B2E.6040308@roeck-us.net>
Date: Wed, 30 Jul 2014 13:53:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ingo Molnar <mingo@kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Heiko Stuebner <heiko@sntech.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-doc@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Tomasz Figa <t.figa@samsung.com>, Randy Dunlap <rdunlap@infradead.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Wim Van Sebroeck <wim@iguana.be>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 1/7] kernel: Add support for kernel restart handler
 call chain
References: <1405668856-13738-1-git-send-email-linux@roeck-us.net> <1405668856-13738-2-git-send-email-linux@roeck-us.net> <53D95330.1050904@codeaurora.org>
In-Reply-To: <53D95330.1050904@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 01:18 PM, Stephen Boyd wrote:
> On 07/18/14 00:34, Guenter Roeck wrote:
>> +/**
>> + *	do_kernel_restart - Execute kernel restart handler call chain
>> + *
>> + *	Calls functions registered with register_restart_handler.
>> + *
>> + *	Expected to be called from machine_restart as last step of the restart
>> + *	sequence.
>> + *
>> + *	Restarts the system immediately if a restart handler function has been
>> + *	registered. Otherwise does nothing.
>> + */
>> +void do_kernel_restart(char *cmd)
>> +{
>> +	blocking_notifier_call_chain(&restart_handler_list, reboot_mode, cmd);
>> +}
>
> Has this been tested with scheduling while atomic checking
> (CONFIG_DEBUG_ATOMIC_SLEEP) or lockdep (CONFIG_PROVE_LOCKING)? ARM would
> call this with irqs disabled and blocking_notifier_call_chain() would
> spit out a warning when it tries to down_read() on it's semaphore. This
> should probably be an atomic notifier chain instead.
>

Good point. I'll update the code accordingly.

I'll wait for additional comments until early next week to avoid unnecessary
churn.

Thanks,
Guenter

