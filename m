Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab3LOLHq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 06:07:46 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:35333 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab3LOLHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 06:07:44 -0500
Message-ID: <52AD8D6D.6090303@gmail.com>
Date: Sun, 15 Dec 2013 19:07:25 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 6/7] arm64, jump label: optimize jump label implementation
References: <1386691433-6827-1-git-send-email-liuj97@gmail.com>	<1386691433-6827-7-git-send-email-liuj97@gmail.com>	<20131213154104.GG19177@mudshark.cambridge.arm.com>	<20131213105023.67e45640@gandalf.local.home> <20131213105223.664f960b@gandalf.local.home>
In-Reply-To: <20131213105223.664f960b@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2013 11:52 PM, Steven Rostedt wrote:
> On Fri, 13 Dec 2013 10:50:23 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> On Fri, 13 Dec 2013 15:41:04 +0000
>> Will Deacon <will.deacon@arm.com> wrote:
>>
>>>> +#include <linux/kernel.h>
>>>> +#include <linux/jump_label.h>
>>>> +#include <asm/jump_label.h>
>>>> +#include <asm/insn.h>
>>>> +
>>>> +#ifdef HAVE_JUMP_LABEL
>>>
>>> Slightly worrying... this should be CONFIG_HAVE_JUMP_LABEL, right? How did
>>> you manage to test this code?
>>
>> In <linux/jump_label.h> we have:
>>
>> #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
>>
>> [...]
>>
>> # include <asm/jump_label.h>
> 
> This also makes the include of <asm/jump_label.h> in the C file
> redundant.
> 
> -- Steve
Thanks, Steve.
Will remove the redundant include header file.

> 
>> # define HAVE_JUMP_LABEL
>> #endif	/* CC_HAVE_ASM_GOTO && CONFIG_JUMP_LABEL */
>>
>>
>> -- Steve
> 

