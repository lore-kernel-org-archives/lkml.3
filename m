Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaKEP4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:56:24 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:40783 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755265AbaKEP4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:56:22 -0500
Message-ID: <545A48A3.5050300@hurleysoftware.com>
Date: Wed, 05 Nov 2014 10:56:19 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ftrace: Document filter and option limitations
References: <1415123165-3020-1-git-send-email-peter@hurleysoftware.com> <20141105102312.59348651@gandalf.local.home>
In-Reply-To: <20141105102312.59348651@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 10:23 AM, Steven Rostedt wrote:
> On Tue,  4 Nov 2014 12:46:05 -0500
> Peter Hurley <peter@hurleysoftware.com> wrote:
> 
>> When using the function or function_graph tracers from the command
>> line, certain command line options have limitations.
>>
>> Document that only kernel built-in functions can be filtered via
>> ftrace_filter= or ftrace_graph_filter=. Document that tracer-specific
>> options cannot be set on the command line via trace_options.
>> Document that ftrace cannot do late binding for function
>> filters.
>>
>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
>> ---
>>  Documentation/kernel-parameters.txt | 6 ++++++
>>  Documentation/trace/ftrace.txt      | 7 +++++--
>>  2 files changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 4c81a86..d098ead 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -1121,6 +1121,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>  			list of functions. This list can be changed at run
>>  			time by the set_ftrace_filter file in the debugfs
>>  			tracing directory.
>> +			Only kernel built-in functions can be filtered.
>>  
>>  	ftrace_notrace=[function-list]
>>  			[FTRACE] Do not trace the functions specified in
>> @@ -1134,6 +1135,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>  			function-list is a comma separated list of functions
>>  			that can be changed at run time by the
>>  			set_graph_function file in the debugfs tracing directory.
>> +			Only kernel built-in functions can be filtered.
>>  
>>  	ftrace_graph_notrace=[function-list]
>>  			[FTRACE] Do not trace from the functions specified in
>> @@ -3521,6 +3523,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>  
>>  			      trace_options=stacktrace
>>  
>> +			Tracer-specific options are ignored when set this way.
>> +			For example, the 'func_stack_trace' option cannot be
>> +			set here.
>> +
>>  			See also Documentation/trace/ftrace.txt "trace options"
>>  			section.
>>  
>> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
>> index 4da4261..d540273 100644
>> --- a/Documentation/trace/ftrace.txt
>> +++ b/Documentation/trace/ftrace.txt
>> @@ -188,7 +188,8 @@ of ftrace. Here is a list of some of the key files:
>>  	in with practically no overhead in performance.  This also
>>  	has a side effect of enabling or disabling specific functions
>>  	to be traced. Echoing names of functions into this file
>> -	will limit the trace to only those functions.
>> +	will limit the trace to only those functions. Only already-
>> +	loaded functions can be filtered.
> 
> I would add a little more. Something that states that modules with the
> same function names that are loaded at a later time will not be
> filtered with theses names.

I could add that trying to write function names from non-existent or
not loaded modules returns EINVAL.

> Hmm, actually, I think this could be rather trivial to implement
> something that will filter modules that are added.
> 
> I think that may be a better solution. I'm assuming you would like to
> have functions filtered via the command line to filter on modules as
> well. Correct?

I think late binding would be a nice feature to add even if not
possible from the kernel command line. I definitely could have used that
a year ago or so when I was debugging firewire subsystem races on module load.

The command line stuff came up because I was trying to trace drm mode-setting,
but once I knew why filtering wasn't working, it was trivial to just build in drm.
So I'm not sure it's really worth it to make the command line options do the
same thing, but I think documenting it is important to save people time looking
into why it doesn't work.

Regards,
Peter Hurley


