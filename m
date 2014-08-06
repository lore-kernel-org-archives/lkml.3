Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbaHFOGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:06:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42400 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbaHFOGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:06:38 -0400
Message-ID: <53E23669.5050309@suse.cz>
Date: Wed, 06 Aug 2014 16:06:33 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: shuah.kh@samsung.com, gregkh@linuxfoundation.org
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: devtest - new make target for build all and run
 tests
References: <1405716274-24420-1-git-send-email-shuah.kh@samsung.com> <53E232E6.8060506@suse.cz> <53E235DE.70604@samsung.com>
In-Reply-To: <53E235DE.70604@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-06 16:04, Shuah Khan wrote:
> On 08/06/2014 07:51 AM, Michal Marek wrote:
>> On 2014-07-18 22:44, Shuah Khan wrote:
>>> Add a new devtest make target to enable developer testing. This
>>> new target does full build (make all) and then runs selftests.
>>
>> I agree with Sam that the name is rather ambiguous, but I can't suggest
>> a better alternative right now.
> 
> Does kselftest or kern_selftest sound better?

It does sound better to me than dev(ice)test, but I'm not a native
English speaker. Greg?


>>> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>>> ---
>>>   Makefile | 11 +++++++++++
>>>   1 file changed, 11 insertions(+)
>>>
>>> diff --git a/Makefile b/Makefile
>>> index f3c543d..1ef3128 100644
>>> --- a/Makefile
>>> +++ b/Makefile
>>> @@ -1034,6 +1034,14 @@ headers_check: headers_install
>>>   	$(Q)$(MAKE) $(hdr-inst)=arch/$(hdr-arch)/include/uapi/asm $(hdr-dst) HDRCHECK=1
>>>
>>>   # ---------------------------------------------------------------------------
>>> +# Kernel devtest
>>> +
>>> +PHONY += devtest
>>> +devtest:
>>> +	make all
>>
>> devtest: all
>>
>>
>>> +	make -C tools/testing/selftests run_tests
>>
>> Please use $(Q)$(MAKE), to keep the build silent by default and to
>> consistently use the same make program with the same options throughout
>> the build.
>>
> 
> Working on the change - send v2 patch.

Great!

Michal

