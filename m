Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab3GBHE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 03:04:58 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:22509 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab3GBHE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 03:04:57 -0400
Message-ID: <51D27B88.1020002@huawei.com>
Date: Tue, 2 Jul 2013 15:04:40 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] tracing/uprobes: Support ftrace_event_file base multibuffer
References: <51CE920C.5020001@huawei.com> <20130701202722.GA413@redhat.com> <20130701211003.GA2147@redhat.com>
In-Reply-To: <20130701211003.GA2147@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/2 5:10, Oleg Nesterov wrote:
> On 07/01, Oleg Nesterov wrote:
>>
>> On 06/29, zhangwei(Jovi) wrote:
>>>
>>> [v3->v4]:
>>
>> I am wondering how much you will hate me if I suggest to make v5 ;)
>>
>> But look, imho probe_event_enable() looks a bit more confusing than
>> it needs.
> 
> And I am a bit worried this patch removes the is_trace_uprobe_enabled()
> check from probe_event_enable()...
> 
> Yes I think it was never needed, afaics TRACE_REG_*_UNREGISTER can't
> come without successfull _REGISTER. And the bogus uprobe_unregister()
> is harmless in this particular case.
> 
> So I think this is fine, but perhaps the changelog should mention this
> "offtopic" change.
> 
> Oleg.
> 
I think it would be better to leave that checking in there now, we can remove
that checking in a separated patch if needed.

(I need to make sure the code will not go to there because each ftrace_event_file
already have enable/disable flag, also need to look at perf enable/disable case).

jovi


