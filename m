Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab3LKBFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:05:33 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45021 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3LKBFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:05:30 -0500
X-AuditID: 9c930179-b7ce4ae000000e86-49-52a7ba589c16
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 10/17] tracing/probes: Move 'symbol' fetch method to kprobes
References: <1386570005-3368-1-git-send-email-namhyung@kernel.org>
	<1386570005-3368-11-git-send-email-namhyung@kernel.org>
	<52A6E914.9050200@hitachi.com>
Date: Wed, 11 Dec 2013 10:05:28 +0900
In-Reply-To: <52A6E914.9050200@hitachi.com> (Masami Hiramatsu's message of
	"Tue, 10 Dec 2013 19:12:36 +0900")
Message-ID: <87r49ki4dj.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Tue, 10 Dec 2013 19:12:36 +0900, Masami Hiramatsu wrote:
> (2013/12/09 15:19), Namhyung Kim wrote:
>
>> diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
>> index 23b2d83ee5fb..d327a1c21f4b 100644
>> --- a/kernel/trace/trace_probe.h
>> +++ b/kernel/trace/trace_probe.h
>> @@ -239,6 +239,30 @@ ASSIGN_FETCH_FUNC(bitfield, ftype),			\
>>  extern __weak const struct fetch_type kprobes_fetch_type_table[];
>>  extern __weak const struct fetch_type uprobes_fetch_type_table[];
>>  
>> +#ifdef CONFIG_KPROBE_EVENT
>> +struct symbol_cache;
>> +unsigned long update_symbol_cache(struct symbol_cache *sc);
>> +void free_symbol_cache(struct symbol_cache *sc);
>> +struct symbol_cache *alloc_symbol_cache(const char *sym, long offset);
>> +#else
>> +struct symbol_cache {
>> +};
>> +static unsigned long __used update_symbol_cache(struct symbol_cache *sc)
>> +{
>> +	return 0;
>> +}
>> +
>> +static void __used free_symbol_cache(struct symbol_cache *sc)
>> +{
>> +}
>> +
>> +static struct symbol_cache * __used
>> +alloc_symbol_cache(const char *sym, long offset)
>> +{
>> +	return NULL;
>> +}
>> +#endif /* CONFIG_KPROBE_EVENT */
>
> Hmm, defining non-inline function in the header looks odd.
> Maybe you'd better do this (or define __weak instances)
> in trace_probe.c.

Or just make them static inline?

Thanks,
Namhyung
