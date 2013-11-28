Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744Ab3K1EQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 23:16:17 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:46144 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab3K1EQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 23:16:16 -0500
Message-ID: <5296C389.7060600@hitachi.com>
Date: Thu, 28 Nov 2013 13:16:09 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: Re: [PATCH 02/17] tracing/probes: Fix basic print type functions
References: <1385533203-10014-1-git-send-email-namhyung@kernel.org>  <1385533203-10014-3-git-send-email-namhyung@kernel.org>  <5295DE36.4070508@hitachi.com> <1385563168.1685.36.camel@leonhard>
In-Reply-To: <1385563168.1685.36.camel@leonhard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/27 23:39), Namhyung Kim wrote:
> Hi Masami,
> 
> 2013-11-27 (수), 20:57 +0900, Masami Hiramatsu:
>> (2013/11/27 15:19), Namhyung Kim wrote:
>>>  
>>> -DEFINE_BASIC_PRINT_TYPE_FUNC(u8, "%x", unsigned int)
>>> -DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned int)
>>> -DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%lx", unsigned long)
>>> -DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%llx", unsigned long long)
>>> -DEFINE_BASIC_PRINT_TYPE_FUNC(s8, "%d", int)
>>> -DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", int)
>>> -DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%ld", long)
>>> -DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%lld", long long)
>>> +DEFINE_BASIC_PRINT_TYPE_FUNC(u8 , "%#x")
>>> +DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%#x")
>>> +DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%#x")
>>> +DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%#Lx")
>>
>> As I said I'd like to ask you to change it in %x.
>>
>> I just checked in Fedora18, but %#x is not supported on this glibc-2.17.
>> Since this format is exported via debugfs (format file), I think %x is
>> better.
> 
> Hmm.. but in most cases it's used for printf() not scanf(), right?  In
> that case adding 0x prefix will help human readers a lot.
> 
> How about mandating the prefix with "0x%x"?  This way it can be used
> both for printf() and scanf() IMHO.

Agreed, you can just use "0x%x" in above case instead of "%#x". :)
For other traceevents, from the human readability point of view,
I think we should move all the event format should use 0x%x instead
of %x, because sometimes it confuse users (e.g. 100 => 0x64, without 0x,
it is just "64").

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


