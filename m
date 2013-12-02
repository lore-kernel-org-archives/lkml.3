Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab3LBHUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 02:20:35 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64373 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab3LBHUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 02:20:33 -0500
X-AuditID: 9c93016f-b7ce9ae000002b4b-e4-529c34c03d25
From: Namhyung Kim <namhyung@kernel.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 03/17] tracing/kprobes: Factor out struct trace_probe
References: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
	<1385533203-10014-4-git-send-email-namhyung@kernel.org>
	<20131129092521.GA9585@linux.vnet.ibm.com>
Date: Mon, 02 Dec 2013 16:20:32 +0900
In-Reply-To: <20131129092521.GA9585@linux.vnet.ibm.com> (Srikar Dronamraju's
	message of "Fri, 29 Nov 2013 14:55:21 +0530")
Message-ID: <87a9gjpvlr.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srikar,

On Fri, 29 Nov 2013 14:55:21 +0530, Srikar Dronamraju wrote:
> * Namhyung Kim <namhyung@kernel.org> [2013-11-27 15:19:49]:
>>  /**
>>   * Kprobe event core functions
>>   */
>> -struct trace_probe {
>> +struct trace_kprobe {
>>  	struct list_head	list;
>>  	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
>>  	unsigned long 		nhit;
>> -	unsigned int		flags;	/* For TP_FLAG_* */
>>  	const char		*symbol;	/* symbol name */
>> -	struct ftrace_event_class	class;
>> -	struct ftrace_event_call	call;
>> -	struct list_head	files;
>> -	ssize_t			size;		/* trace entry size */
>> -	unsigned int		nr_args;
>> -	struct probe_arg	args[];
>> +	struct trace_probe	p;
>
> Can I suggest to use tp instead of p to denote trace_probe?

Sure.  I'll change it.

>
>>  };
>> 
>> 
>
> <..snipped..>
>
>> -static int register_probe_event(struct trace_probe *tp);
>> -static int unregister_probe_event(struct trace_probe *tp);
>> +static int register_kprobe_event(struct trace_kprobe *tk);
>> +static int unregister_kprobe_event(struct trace_kprobe *tk);
>> 
>>  static DEFINE_MUTEX(probe_lock);
>>  static LIST_HEAD(probe_list);
>> @@ -107,14 +91,14 @@ static int kretprobe_dispatcher(struct kretprobe_instance *ri,
>>  /*
>>   * Allocate new trace_probe and initialize it (including kprobes).
>>   */
>> -static struct trace_probe *alloc_trace_probe(const char *group,
>> +static struct trace_kprobe *alloc_trace_kprobe(const char *group,
>>  					     const char *event,
>>  					     void *addr,
>>  					     const char *symbol,
>>  					     unsigned long offs,
>>  					     int nargs, bool is_return)
>>  {
>> -	struct trace_probe *tp;
>> +	struct trace_kprobe *tp;
>
> Nit: Here and couple of places below: Given that tk was used to
> represent trace_kprobe, can we use tk everywhere. Using tp to represent
> trace_probe and trace_kprobe is a bit confusing.

Right.  I did it because changing it to 'tk' leads to many oneline hunks
here and there so I worried it might disturb reviewers.

But yeah, I also dislike it.  I'll change it to have consistent names.

>
>>  	int ret = -ENOMEM;
>> 
>
> The rest looks fine.

Thanks for your review!
Namhyung
