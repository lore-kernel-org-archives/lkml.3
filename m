Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab3FYOsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:48:14 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:56066 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab3FYOsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:48:13 -0400
MIME-Version: 1.0
In-Reply-To: <1372167296.18733.195.camel@gandalf.local.home>
References: <51C951BF.1090509@huawei.com>
	<51C96C89.6080207@hitachi.com>
	<51C97305.3090406@huawei.com>
	<1372167296.18733.195.camel@gandalf.local.home>
Date: Tue, 25 Jun 2013 22:48:12 +0800
Message-ID: <CACV3sbJ177tYFS5KvVz7ah07PuWNkxEKo5x6AWOAavooGHo0Sg@mail.gmail.com>
Subject: Re: [PATCH 1/2] tracing/kprobes: move free_trace_probe into unregister_trace_probe
From: Jovi Zhang <bookjovi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 9:34 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2013-06-25 at 18:37 +0800, zhangwei(Jovi) wrote:
>> On 2013/6/25 18:10, Masami Hiramatsu wrote:
>> > (2013/06/25 17:15), zhangwei(Jovi) wrote:
>> >> There have no good reason to call free_trace_probe
>> >> every time when unregister_trace_probe return 0.
>> >>
>> >> Move free_trace_probe into unregister_trace_probe,
>> >> make code simpler.
>> >
>> > Sorry, nack. For the symmetrical coding reason, I don't like
>> > involving "free" and "alloc" into "unregister"/"register"
>> > functions. I think those should be just another actions.
>> >
>> > Thank you,
>>
>> That's fine, I just saw there have a little inconsistent between
>> trace_kprobe.c and trace_uprobe.c.
>>
>
> Is there a place that trace_kprobe.c frees the tp structure in
> unregister?
>

I won't argue put the free operation into unregister function in
trace_kprobe.c, as I said, one minor problem is the code
pattern between trace_kprobe.c and trace_uprobe.c is so
similar on unregister, but with little inconsistent, maybe
we can unify those code in trace_probe.c someday.

Anyway, this is not big functionality issue,  free to leave in there
if authors don't argue.

jovi
