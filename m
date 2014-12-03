Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbaLCQNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:13:22 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:19742 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103AbaLCQNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:13:20 -0500
Message-ID: <547F369A.3000106@sonymobile.com>
Date: Wed, 3 Dec 2014 08:13:14 -0800
From: Tim Bird <tim.bird@sonymobile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Michael Ellerman <mpe@ellerman.id.au>
CC: Shuah Khan <shuahkh@osg.samsung.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH v5] selftest: size: Add size test for Linux kernel
References: <547E854E.5060101@sonymobile.com>	<1417578191.16722.11.camel@concordia> <20141203140136.12997331@free-electrons.com>
In-Reply-To: <20141203140136.12997331@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/03/2014 05:01 AM, Thomas Petazzoni wrote:
> Michael, Tim,
> 
> On Wed, 03 Dec 2014 14:43:11 +1100, Michael Ellerman wrote:
> 
>>> diff --git a/tools/testing/selftests/size/Makefile b/tools/testing/selftests/size/Makefile
>>> new file mode 100644
>>> index 0000000..47f8e9c
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/size/Makefile
>>> @@ -0,0 +1,15 @@
>>> +#ifndef CC
>>> +	CC = $(CROSS_COMPILE)gcc
>>> +#endif
>>
>> I think the following is preferable:
>>
>>   CC := $(CROSS_COMPILE)$(CC)
> 
> It is even more necessary that #ifndef and #endif don't exist in make.
> They are just comments, and therefore, ignored. Seems like Tim does too
> much C :-)

OK - that's hilarious.  Saying 'Oops!' would be too casual for my degree of
embarrassment. :-)

Makefiles do have similar constructs.  Those should have been
ifeq ($(CC),)
	...
endif

This obviously got through via a failiure in testing - which is somewhat ironic.

Look for a v6 soon.  (Geez, when is the merge window coming.  I thought this trivial
program would get in pretty easily, but no... that's never the way.  Of course
it helps if the submitter is not an idiot.)
 -- Tim
