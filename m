Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbaB1QM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:12:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44108 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbaB1QM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:12:56 -0500
Message-ID: <5310B54F.3000709@zytor.com>
Date: Fri, 28 Feb 2014 08:11:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCHv2] x86 trace: Fix page fault tracing bug
References: <1393601620-13117-1-git-send-email-jolsa@redhat.com> <20140228154708.GI9987@twins.programming.kicks-ass.net> <20140228160526.GD1133@krava.brq.redhat.com>
In-Reply-To: <20140228160526.GD1133@krava.brq.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2014 08:05 AM, Jiri Olsa wrote:
> On Fri, Feb 28, 2014 at 04:47:08PM +0100, Peter Zijlstra wrote:
>> On Fri, Feb 28, 2014 at 04:33:40PM +0100, Jiri Olsa wrote:
>>
>> While I like the idea of just pushing up the CR2 read; the below does
>> the read too late still, exception_enter() also has a tracepoint in.
> 
> please check v2, thanks

Is there any way something could come in even earlier (perhaps via
__fentry__)?

If so, do we need to hoist the reading of %cr2 all the way into assembly
or something else?

	-hpa

