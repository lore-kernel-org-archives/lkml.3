Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbaBTMxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 07:53:44 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:34158 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674AbaBTMxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 07:53:42 -0500
MIME-Version: 1.0
In-Reply-To: <5305F928.5070600@imgtec.com>
References: <1391793327-9578-1-git-send-email-markos.chandras@imgtec.com>
	<5305F928.5070600@imgtec.com>
Date: Thu, 20 Feb 2014 13:53:41 +0100
Message-ID: <CAFLxGvyA+2QTkUwOthLiaH5iVT-6HvzwWEBoUaPoqrBxbLzxLw@mail.gmail.com>
Subject: Re: [PATCH] Makefile: Unset stack-protector gcc flag if it is not supported
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Markos Chandras <Markos.Chandras@imgtec.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 1:46 PM, Markos Chandras
<Markos.Chandras@imgtec.com> wrote:
> On 02/07/2014 05:15 PM, Markos Chandras wrote:
>>
>> In case the compiler does not support the stack-protector option,
>> unset the flag to avoid build failures. Printing a warning is enough
>> to let the user know that this flag will not be used.
>> Fixes the following build problem when using a toolchain which does
>> not support the -fstack-protector-strong flag:
>>
>> Makefile:614: Cannot use CONFIG_CC_STACKPROTECTOR_STRONG:
>> -fstack-protector-strong not supported by compiler
>> mips-linux-gnu-gcc: error: unrecognized command line option
>> '-fstack-protector-strong'
>> scripts/Makefile.build:308: recipe for target 'scripts/mod/empty.o' failed
>> make[2]: *** [scripts/mod/empty.o] Error 1
>> make[2]: *** Waiting for unfinished jobs....
>> scripts/Makefile.build:455: recipe for target 'scripts/mod' failed
>>
>> Cc: Michal Marek <mmarek@suse.cz>
>> Cc: linux-kbuild@vger.kernel.org
>> Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
>> ---
>>   Makefile | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/Makefile b/Makefile
>> index 606ef7c..63a5333 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -607,12 +607,14 @@ ifdef CONFIG_CC_STACKPROTECTOR_REGULAR
>>     ifeq ($(call cc-option, $(stackp-flag)),)
>>       $(warning Cannot use CONFIG_CC_STACKPROTECTOR: \
>>               -fstack-protector not supported by compiler))
>> +    stackp-flag :=
>>     endif
>>   else ifdef CONFIG_CC_STACKPROTECTOR_STRONG
>>     stackp-flag := -fstack-protector-strong
>>     ifeq ($(call cc-option, $(stackp-flag)),)
>>       $(warning Cannot use CONFIG_CC_STACKPROTECTOR_STRONG: \
>>               -fstack-protector-strong not supported by compiler)
>> +    stackp-flag :=
>>     endif
>>   else
>>     # Force off for distro compilers that enable stack protector by
>> default.
>>
>
> Ping again?

This is by design. We want the build fail if
CONFIG_CC_STACKPROTECTOR_STRONG is set
but the toolchain does not support it.
Otherwise we could end up with a kernel without stackprotector even if
the config symbol is set.

-- 
Thanks,
//richard
