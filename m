Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab3LKB0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:26:41 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39532 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab3LKB0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:26:37 -0500
Message-ID: <52A7BF46.8080707@hitachi.com>
Date: Wed, 11 Dec 2013 10:26:30 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 10/17] tracing/probes: Move 'symbol' fetch method to kprobes
References: <1386570005-3368-1-git-send-email-namhyung@kernel.org> <1386570005-3368-11-git-send-email-namhyung@kernel.org> <52A6E914.9050200@hitachi.com> <87r49ki4dj.fsf@sejong.aot.lge.com>
In-Reply-To: <87r49ki4dj.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/11 10:05), Namhyung Kim wrote:
> Hi Masami,
> 
> On Tue, 10 Dec 2013 19:12:36 +0900, Masami Hiramatsu wrote:
>> (2013/12/09 15:19), Namhyung Kim wrote:
>>
>>> diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
>>> index 23b2d83ee5fb..d327a1c21f4b 100644
>>> --- a/kernel/trace/trace_probe.h
>>> +++ b/kernel/trace/trace_probe.h
>>> @@ -239,6 +239,30 @@ ASSIGN_FETCH_FUNC(bitfield, ftype),			\
>>>  extern __weak const struct fetch_type kprobes_fetch_type_table[];
>>>  extern __weak const struct fetch_type uprobes_fetch_type_table[];
>>>  
>>> +#ifdef CONFIG_KPROBE_EVENT
>>> +struct symbol_cache;
>>> +unsigned long update_symbol_cache(struct symbol_cache *sc);
>>> +void free_symbol_cache(struct symbol_cache *sc);
>>> +struct symbol_cache *alloc_symbol_cache(const char *sym, long offset);
>>> +#else
>>> +struct symbol_cache {
>>> +};
>>> +static unsigned long __used update_symbol_cache(struct symbol_cache *sc)
>>> +{
>>> +	return 0;
>>> +}
>>> +
>>> +static void __used free_symbol_cache(struct symbol_cache *sc)
>>> +{
>>> +}
>>> +
>>> +static struct symbol_cache * __used
>>> +alloc_symbol_cache(const char *sym, long offset)
>>> +{
>>> +	return NULL;
>>> +}
>>> +#endif /* CONFIG_KPROBE_EVENT */
>>
>> Hmm, defining non-inline function in the header looks odd.
>> Maybe you'd better do this (or define __weak instances)
>> in trace_probe.c.
> 
> Or just make them static inline?

Exactly, yes. ;)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


