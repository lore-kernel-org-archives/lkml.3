Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaGaUqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 16:46:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaGaUqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 16:46:48 -0400
Message-ID: <53DAAB35.8080206@suse.cz>
Date: Thu, 31 Jul 2014 22:46:45 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Behan Webster <behanw@converseincode.com>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org,
        =?UTF-8?B?SmFuLVNpbW9uIE3DtmxsZXI=?= <dl9pf@gmx.de>,
        Mark Charlebois <charlebm@gmail.com>, bp@alien8.de
Subject: Re: [PATCH v2] kbuild, LLVMLinux: Supress warnings unless W=1-3
References: <53D8ED5D.8070604@suse.cz> <1406780181-7973-1-git-send-email-behanw@converseincode.com> <53D9FBC6.9070908@suse.cz> <53DA6AFC.3060002@converseincode.com>
In-Reply-To: <53DA6AFC.3060002@converseincode.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 31.7.2014 18:12, Behan Webster napsal(a):
> On 07/31/14 01:18, Michal Marek wrote:
>> Dne 31.7.2014 06:16, behanw@converseincode.com napsal(a):
>>> @@ -55,6 +45,18 @@ warning-3 += -Wswitch-default
>>>   warning-3 += $(call cc-option, -Wpacked-bitfield-compat)
>>>   warning-3 += $(call cc-option, -Wvla)
>>>   +ifeq ($(COMPILER),clang)
>>> +ifndef $(W)
>>> +KBUILD_CFLAGS += $(call cc-disable-warning, initializer-overrides)
>>> +KBUILD_CFLAGS += $(call cc-disable-warning, unused-value)
>>> +KBUILD_CFLAGS += $(call cc-disable-warning, format)
>>> +KBUILD_CFLAGS += $(call cc-disable-warning, unknown-warning-option)
>>> +KBUILD_CFLAGS += $(call cc-disable-warning, sign-compare)
>>> +KBUILD_CFLAGS += $(call cc-disable-warning, format-zero-length)
>>> +KBUILD_CFLAGS += $(call cc-disable-warning, uninitialized)
>>> +endif
>>> +endif
>>> +
>> Please remove this part, it has no effect. I assume that if it works for
>> you, these warning are not as annoying so they do not need to be
>> disabled?
> Actually they are annoying, that's why they're disabled normally. Most
> of them complain about practices which are relatively common in kernel
> code.
> 
> clang warns about a lot more things than gcc does. It means that code
> which compiles cleanly in gcc often doesn't with clang. This cuts out
> the warnings which are unlikely to to be fixed in kernel code anytime
> soon, but which are probably worth exposing when W=1 is used.
> 
> This part of the patch explicitly deals with complaints from some in the
> kernel community that clang is too noisy with kernel code.
> 
> This part of the patch needs to be somewhere. This seemed the best place.

You placed it inside a branch that is only evaluated when W= is given.

Michal
