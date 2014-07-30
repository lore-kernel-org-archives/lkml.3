Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaG3Vjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 17:39:51 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:43691 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbaG3Vjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 17:39:49 -0400
Message-ID: <53D96620.10700@converseincode.com>
Date: Wed, 30 Jul 2014 14:39:44 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, dl9pf@gmx.de
CC: Borislav Petkov <bp@alien8.de>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, pageexec@freemail.hu, mcharleb@gmail.com
Subject: Re: [PATCH] kbuild, LLVMLinux: only use warnings when using clang
References: <20140629201308.GC12943@pd.tnic> <1404175346-12330-1-git-send-email-behanw@converseincode.com> <20140701101214.GA14882@pd.tnic> <53D8ED5D.8070604@suse.cz>
In-Reply-To: <53D8ED5D.8070604@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/14 06:04, Michal Marek wrote:
> On 2014-07-01 12:12, Borislav Petkov wrote:
>> On Mon, Jun 30, 2014 at 05:42:26PM -0700, behanw@converseincode.com wrote:
>>> From: Behan Webster <behanw@converseincode.com>
>>>
>>> Only consider clang warnings in Kbuild when using the clang compiler.
>>>
>>> Signed-off-by: Behan Webster <behanw@converseincode.com>
>>> ---
>>>   scripts/Makefile.extrawarn | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
>>> index 6564350..e350127 100644
>>> --- a/scripts/Makefile.extrawarn
>>> +++ b/scripts/Makefile.extrawarn
>>> @@ -26,7 +26,7 @@ warning-1 += $(call cc-option, -Wmissing-include-dirs)
>>>   warning-1 += $(call cc-option, -Wunused-but-set-variable)
>>>   warning-1 += $(call cc-disable-warning, missing-field-initializers)
>>>   
>>> -# Clang
>>> +ifeq ($(COMPILER),clang)
>>>   warning-1 += $(call cc-disable-warning, initializer-overrides)
>>>   warning-1 += $(call cc-disable-warning, unused-value)
>>>   warning-1 += $(call cc-disable-warning, format)
>>> @@ -35,6 +35,7 @@ warning-1 += $(call cc-disable-warning, sign-compare)
>>>   warning-1 += $(call cc-disable-warning, format-zero-length)
>>>   warning-1 += $(call cc-disable-warning, uninitialized)
>>>   warning-1 += $(call cc-option, -fcatch-undefined-behavior)
>>> +endif
>> Ok, just to make sure I understand that whole use case correctly:
>>
>> The disabling of those warnings is really intended for the case where
>> people build the kernel with "W=1" on the make cmdline *and* clang?
> Behan, Jan-Simon,
>
> can you explain why are those -Wno-... options needed in the W=1 case?
> The whole point of the W= option is to enable noisy warnings, so I don't
> quite get why you want to silence these.
Sorry for the delay.

That code is indeed not what was intended. It's more that these warnings 
should normally be disabled, and when W is set they should not be disabled.

Just putting the final touches on a patch which addresses this situation.

Behan

-- 
Behan Webster
behanw@converseincode.com

