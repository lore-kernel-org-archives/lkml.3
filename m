Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbaGALdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 07:33:21 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:37294 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaGALdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 07:33:18 -0400
Message-ID: <53B29C73.9090509@linaro.org>
Date: Tue, 01 Jul 2014 20:33:07 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>
Subject: Re: [RFA][PATCH 25/27] arm64, ftrace: Remove check of obsolete variable
 function_trace_stop
References: <20140626165221.736847419@goodmis.org> <20140626165853.482575534@goodmis.org> <20140627124421.GP26276@arm.com>
In-Reply-To: <20140627124421.GP26276@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2014 09:44 PM, Will Deacon wrote:
> Hi Steve,
>
> On Thu, Jun 26, 2014 at 05:52:46PM +0100, Steven Rostedt wrote:
>> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
>>
>> Nothing sets function_trace_stop to disable function tracing anymore.
>> Remove the check for it in the arch code.
>>
>> arm64 was broken anyway, as it had an ifdef testing
>>   CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST which is only set if
>> the arch supports the code (which it obviously did not), and
>> it was testing a non existent ftrace_trace_stop instead of
>> function_trace_stop.
>
> Yeah, the current code is total crap. Well spotted.

Thank you for fixing my bug :)
I also exercised ftrace with sysfs interface, and it just works well.

-Takahiro AKASHI

>
>> Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>> ---
>>   arch/arm64/kernel/entry-ftrace.S | 5 -----
>>   1 file changed, 5 deletions(-)
>
>    Acked-by: Will Deacon <will.deacon@arm.com>
>
> I'm happy for you to take this via the ftrace tree, along with the rest of
> the series.
>
> I successfully ran the ftrace self tests with this applied (on top of
> "ftrace: Remove check for HAVE_FUNCTION_TRACE_MCOUNT_TEST"), but note
> that I don't have a platform with working suspend/resume right now.
>
> Cheers,
>
> Will
>
>> diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
>> index b051871f2965..1b1e330e6849 100644
>> --- a/arch/arm64/kernel/entry-ftrace.S
>> +++ b/arch/arm64/kernel/entry-ftrace.S
>> @@ -96,11 +96,6 @@
>>    *     - ftrace_graph_caller to set up an exit hook
>>    */
>>   ENTRY(_mcount)
>> -#ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
>> -	ldr	x0, =ftrace_trace_stop
>> -	ldr	x0, [x0]		// if ftrace_trace_stop
>> -	ret				//   return;
>> -#endif
>>   	mcount_enter
>>
>>   	ldr	x0, =ftrace_trace_function
>> --
>> 2.0.0
>>
>>
>>
