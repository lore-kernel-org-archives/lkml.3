Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaLCOOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:14:22 -0500
Received: from lists.s-osg.org ([54.187.51.154]:39083 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbaLCOOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:14:21 -0500
Message-ID: <547F1ABA.5040601@osg.samsung.com>
Date: Wed, 03 Dec 2014 07:14:18 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, davem@davemloft.net, keescook@chromium.org,
        tranmanphong@gmail.com, dh.herrmann@gmail.com, hughd@google.com,
        bobby.prani@gmail.com, ebiederm@xmission.com, serge.hallyn@ubuntu.com
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH v2 02/19] kbuild: kselftest_install - add a new make target
 to install selftests
References: <cover.1415735831.git.shuahkh@osg.samsung.com> <a2344d4df903d673afe1631118f40917f773cc9a.1415735831.git.shuahkh@osg.samsung.com> <547C8D81.1030605@suse.cz> <547C99B6.7070903@osg.samsung.com> <547EFD6F.2010204@suse.cz>
In-Reply-To: <547EFD6F.2010204@suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 05:09 AM, Michal Marek wrote:
> On 2014-12-01 17:39, Shuah Khan wrote:
>> On 12/01/2014 08:47 AM, Michal Marek wrote:
>>> On 2014-11-11 21:27, Shuah Khan wrote:
>>>> diff --git a/Makefile b/Makefile
>>>> index 05d67af..ccbd2e1 100644
>>>> --- a/Makefile
>>>> +++ b/Makefile
>>>> @@ -1071,12 +1071,26 @@ headers_check: headers_install
>>>>  	$(Q)$(MAKE) $(hdr-inst)=arch/$(hdr-arch)/include/uapi/asm $(hdr-dst) HDRCHECK=1
>>>>  
>>>>  # ---------------------------------------------------------------------------
>>>> -# Kernel selftest
>>>> +# Kernel selftest targets
>>>> +
>>>> +PHONY += __kselftest_configure
>>>> +INSTALL_KSFT_PATH=$(INSTALL_MOD_PATH)/lib/kselftest/$(KERNELRELEASE)
>>>> +export INSTALL_KSFT_PATH
>>>> +KSELFTEST=$(INSTALL_KSFT_PATH)/kselftest.sh
>>>> +export KSELFTEST
>>>
>>> Can this be moved to tools/testing/selftests/Makefile? It's only used in
>>> this part of the tree.
>>
>> I looked into doing that. KERNELRELEASE will have to be exported for
>> tools/testing/selftests/Makefile to use it? Does that sound okay?
> 
> In fact, KERNELRELEASE is already exported. So go ahead.

Good.

> 
> 
>> Also, it might be easier to get this series in, if you can Ack the main
>> Makefile patch (when we are ready i.e), so I can take it through
>> kselftest tree.
> 
> Sure. The Makefile change will only consist of redirecting the
> kselftest_install target to tools/testing/selftests, right?
> 

Correct. I plan to keep the selftests specific work under the
selftests related Makefiles.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
