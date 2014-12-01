Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaLAQ6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:58:24 -0500
Received: from lists.s-osg.org ([54.187.51.154]:38746 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbaLAQ6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:58:22 -0500
Message-ID: <547C9E2D.3090207@osg.samsung.com>
Date: Mon, 01 Dec 2014 09:58:21 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Christopher Covington <cov@codeaurora.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Andrew Morton <akpm@osdl.org>, gorcunov@openvz.org,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 3/3] selftests/kcmp: Always try to build the test
References: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au> <1414040834-30209-3-git-send-email-mpe@ellerman.id.au> <5448FD72.9040301@codeaurora.org> <54490832.7040906@osg.samsung.com>
In-Reply-To: <54490832.7040906@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2014 07:52 AM, Shuah Khan wrote:
> On 10/23/2014 07:06 AM, Christopher Covington wrote:
>> Hi Michael,
>>
>> On 10/23/2014 01:07 AM, Michael Ellerman wrote:
>>> Don't prevent the test building on non-x86. Just try and build it and
>>> let the chips fall where they may.
>>
>> As a user of kcmp via CRIU on arm and arm64, thanks!
>>
>>> diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
>>> index 4f00c0524501..cda9cc4004c9 100644
>>> --- a/tools/testing/selftests/kcmp/Makefile
>>> +++ b/tools/testing/selftests/kcmp/Makefile
>>> @@ -1,21 +1,7 @@
>>> -uname_M := $(shell uname -m 2>/dev/null || echo not)
>>> -ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
>>> -ifeq ($(ARCH),i386)
>>> -        ARCH := x86
>>> -	CFLAGS := -DCONFIG_X86_32 -D__i386__
>>> -endif
>>> -ifeq ($(ARCH),x86_64)
>>> -	ARCH := x86
>>> -	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
>>> -endif
>>>  CFLAGS += -I../../../../usr/include/
>>>  
>>>  all:
>>> -ifeq ($(ARCH),x86)
>>>  	gcc $(CFLAGS) kcmp_test.c -o kcmp_test
>>
>> Not that this needs to be addressed in this patch, but this looks broken for
>> cross compilation. It looks like some of the other selftests use:
>>
>> CC = $(CROSS_COMPILE)gcc
>>
> 
> It makes sense to fix the cross-compile problem now, since
> this patch is extending the support to other archs.
> 
> thanks,
> -- Shuah
> 
> 

Please address the cross-compile problems in your next patch version.

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
