Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaLCSZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:25:57 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:6461 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751623AbaLCSZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:25:55 -0500
Message-ID: <547F55AD.1040303@sonymobile.com>
Date: Wed, 3 Dec 2014 10:25:49 -0800
From: Tim Bird <tim.bird@sonymobile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Michael Ellerman <mpe@ellerman.id.au>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH v5] selftest: size: Add size test for Linux kernel
References: <547E854E.5060101@sonymobile.com>	<1417578191.16722.11.camel@concordia>	<547F3A57.7000106@sonymobile.com> <CAMuHMdVk9QLDRYDs3q7=51=qTMNRY+MQVhkqGE25XqYOkLbCxg@mail.gmail.com>
In-Reply-To: <CAMuHMdVk9QLDRYDs3q7=51=qTMNRY+MQVhkqGE25XqYOkLbCxg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/03/2014 10:00 AM, Geert Uytterhoeven wrote:
> On Wed, Dec 3, 2014 at 5:29 PM, Tim Bird <tim.bird@sonymobile.com> wrote:
>>>> diff --git a/tools/testing/selftests/size/Makefile b/tools/testing/selftests/size/Makefile
>>>> new file mode 100644
>>>> index 0000000..47f8e9c
>>>> --- /dev/null
>>>> +++ b/tools/testing/selftests/size/Makefile
>>>> @@ -0,0 +1,15 @@
>>>> +#ifndef CC
>>>> +    CC = $(CROSS_COMPILE)gcc
>>>> +#endif
>>>
>>> I think the following is preferable:
>>>
>>>   CC := $(CROSS_COMPILE)$(CC)
>>>
>>>
>>> It allows optionally setting a custom CC, as well as optionally CROSS_COMPILE.
>>
>> I'm not sure I follow this.
>>
>> If CC is unset, you get only the CROSS_COMPILE prefix.
>> If CC is set to e.g. 'gcc', then you get a nicely formatted toolchain string.
>> But if CC already has the prefix applied, then this will result in
>>   having it duplicated, which surely won't work correctly.
>>
>> In the long run, I would hope that a higher level Makefile or environment setting
>> will be setting the toolchain string appropriately (as well as handling build flags)
>> which is why I wanted to use an ifndef (which Thomas correctly pointed out is just
>> wrong).
>>
>> Actually, after getting this tiny program accepted, my next task was working on a
>> proper fix for handling cross compilation in a more generic (not case-by-case) way.
>>
>> CROSS_COMPILE prefix usage looks a bit uncoordinated in the tools directory, but most
>> tests seem to be favoring $(CROSS_COMPILE)gcc.
>>
>>  $ cd tools ; mgrep CROSS
> 
> [...]
> 
>> I agree it's desirable not to hardcode gcc, but we seem to be doing it all over
>> the place already.
> 
> Seems like it's time to start integrating the tests with the regular Kbuild
> system, which handles cross-compilation fine...

Where possible, yes.  It would be nice to leverage CROSS_COMPILE and CFLAGS, or
a portion thereof, from the Kbuild system (as well a KBUILD_OUTPUT and friends).
It's on my to-do list, after getting my little C program accepted...
 -- Tim
