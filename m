Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaG3NEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:04:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbaG3NEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:04:32 -0400
Message-ID: <53D8ED5D.8070604@suse.cz>
Date: Wed, 30 Jul 2014 15:04:29 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: behanw@converseincode.com, dl9pf@gmx.de
CC: Borislav Petkov <bp@alien8.de>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, pageexec@freemail.hu, mcharleb@gmail.com
Subject: Re: [PATCH] kbuild, LLVMLinux: only use warnings when using clang
References: <20140629201308.GC12943@pd.tnic> <1404175346-12330-1-git-send-email-behanw@converseincode.com> <20140701101214.GA14882@pd.tnic>
In-Reply-To: <20140701101214.GA14882@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-01 12:12, Borislav Petkov wrote:
> On Mon, Jun 30, 2014 at 05:42:26PM -0700, behanw@converseincode.com wrote:
>> From: Behan Webster <behanw@converseincode.com>
>>
>> Only consider clang warnings in Kbuild when using the clang compiler.
>>
>> Signed-off-by: Behan Webster <behanw@converseincode.com>
>> ---
>>  scripts/Makefile.extrawarn | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
>> index 6564350..e350127 100644
>> --- a/scripts/Makefile.extrawarn
>> +++ b/scripts/Makefile.extrawarn
>> @@ -26,7 +26,7 @@ warning-1 += $(call cc-option, -Wmissing-include-dirs)
>>  warning-1 += $(call cc-option, -Wunused-but-set-variable)
>>  warning-1 += $(call cc-disable-warning, missing-field-initializers)
>>  
>> -# Clang
>> +ifeq ($(COMPILER),clang)
>>  warning-1 += $(call cc-disable-warning, initializer-overrides)
>>  warning-1 += $(call cc-disable-warning, unused-value)
>>  warning-1 += $(call cc-disable-warning, format)
>> @@ -35,6 +35,7 @@ warning-1 += $(call cc-disable-warning, sign-compare)
>>  warning-1 += $(call cc-disable-warning, format-zero-length)
>>  warning-1 += $(call cc-disable-warning, uninitialized)
>>  warning-1 += $(call cc-option, -fcatch-undefined-behavior)
>> +endif
> 
> Ok, just to make sure I understand that whole use case correctly:
> 
> The disabling of those warnings is really intended for the case where
> people build the kernel with "W=1" on the make cmdline *and* clang?

Behan, Jan-Simon,

can you explain why are those -Wno-... options needed in the W=1 case?
The whole point of the W= option is to enable noisy warnings, so I don't
quite get why you want to silence these.

Thanks,
Michal

