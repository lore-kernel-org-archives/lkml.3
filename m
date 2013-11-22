Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab3KVIKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 03:10:12 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:45715 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab3KVIKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 03:10:08 -0500
Message-ID: <528F115A.8020602@hitachi.com>
Date: Fri, 22 Nov 2013 17:10:02 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: Re: [PATCH 2/2] tracing/probes: Fix basic print type functions
References: <1384749649-31447-1-git-send-email-namhyung@kernel.org> <1384749649-31447-2-git-send-email-namhyung@kernel.org> <20131120152245.GB24734@redhat.com> <87k3g1t1hw.fsf@sejong.aot.lge.com>
In-Reply-To: <87k3g1t1hw.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/22 15:05), Namhyung Kim wrote:
> Hi Oleg,
> 
> On Wed, 20 Nov 2013 16:22:45 +0100, Oleg Nesterov wrote:
>> On 11/18, Namhyung Kim wrote:
>>>
>>> -DEFINE_BASIC_PRINT_TYPE_FUNC(u8, "%x", unsigned int)
>>> -DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned int)
>>> -DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%lx", unsigned long)
>>> +DEFINE_BASIC_PRINT_TYPE_FUNC(u8 , "%x", unsigned char)
>>> +DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned short)
>>> +DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%x", unsigned int)
>>> +DEFINE_BASIC_PRINT_TYPE_FUNC(s8,  "%d", signed char)
>>> +DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", short)
>>> +DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%d", int)
>>> +#if BITS_PER_LONG == 32
>>>  DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%llx", unsigned long long)
>>> -DEFINE_BASIC_PRINT_TYPE_FUNC(s8, "%d", int)
>>> -DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", int)
>>> -DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%ld", long)
>>>  DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%lld", long long)
>>> +#else /* BITS_PER_LONG == 64 */
>>> +DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%lx", unsigned long)
>>> +DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%ld", long)
>>> +#endif
>>
>> I must have missed something... Not only I do not understand why
>> do we need "#if BITS_PER_LONG", I can't understand why
>> DEFINE_BASIC_PRINT_TYPE_FUNC() needs "cast" argument.
>>
>> IOW, how about the patch below instead?
> 
> Looks good to me.
> 
> Masami, did you have any issue regarding the casts?

Hm, unless compiler doesn't complain about it,I'm OK for that.
And as far as I tested on x86/x86-64/arm(32), this has no problem. :)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


