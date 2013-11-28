Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583Ab3K1G5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 01:57:15 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48732 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3K1G5N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 01:57:13 -0500
X-AuditID: 9c930179-b7b6eae000007f2a-3e-5296e9486747
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 02/17] tracing/probes: Fix basic print type functions
References: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
	<1385533203-10014-3-git-send-email-namhyung@kernel.org>
	<5295DE36.4070508@hitachi.com> <1385563168.1685.36.camel@leonhard>
	<5296C389.7060600@hitachi.com>
Date: Thu, 28 Nov 2013 15:57:12 +0900
In-Reply-To: <5296C389.7060600@hitachi.com> (Masami Hiramatsu's message of
	"Thu, 28 Nov 2013 13:16:09 +0900")
Message-ID: <87iovdqaif.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Thu, 28 Nov 2013 13:16:09 +0900, Masami Hiramatsu wrote:
> (2013/11/27 23:39), Namhyung Kim wrote:
>> Hi Masami,
>> 
>> 2013-11-27 (수), 20:57 +0900, Masami Hiramatsu:
>>> (2013/11/27 15:19), Namhyung Kim wrote:
>>>>  
>>>> -DEFINE_BASIC_PRINT_TYPE_FUNC(u8, "%x", unsigned int)
>>>> -DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned int)
>>>> -DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%lx", unsigned long)
>>>> -DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%llx", unsigned long long)
>>>> -DEFINE_BASIC_PRINT_TYPE_FUNC(s8, "%d", int)
>>>> -DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", int)
>>>> -DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%ld", long)
>>>> -DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%lld", long long)
>>>> +DEFINE_BASIC_PRINT_TYPE_FUNC(u8 , "%#x")
>>>> +DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%#x")
>>>> +DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%#x")
>>>> +DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%#Lx")
>>>
>>> As I said I'd like to ask you to change it in %x.
>>>
>>> I just checked in Fedora18, but %#x is not supported on this glibc-2.17.
>>> Since this format is exported via debugfs (format file), I think %x is
>>> better.
>> 
>> Hmm.. but in most cases it's used for printf() not scanf(), right?  In
>> that case adding 0x prefix will help human readers a lot.
>> 
>> How about mandating the prefix with "0x%x"?  This way it can be used
>> both for printf() and scanf() IMHO.
>
> Agreed, you can just use "0x%x" in above case instead of "%#x". :)

Okay, will change.


> For other traceevents, from the human readability point of view,
> I think we should move all the event format should use 0x%x instead
> of %x, because sometimes it confuse users (e.g. 100 => 0x64, without 0x,
> it is just "64").

Agreed.  I'll take a look at them later.

Thanks,
Namhyung
