Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab3GASyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 14:54:01 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:44487 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab3GASyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 14:54:00 -0400
Message-ID: <51D1D043.5030509@gmail.com>
Date: Mon, 01 Jul 2013 12:53:55 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 12/15] perf tools: allow non-matching sample types
References: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com> <1372319707-13892-13-git-send-email-adrian.hunter@intel.com> <51CC6AAF.4030404@gmail.com> <51D14CB6.206@intel.com>
In-Reply-To: <51D14CB6.206@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/1/13 3:32 AM, Adrian Hunter wrote:
> Snip
>
>>
>> While this works for a combined S/W and tracepoint events session, I do not
>> like promoting sample types to the minimum compatible level for all events
>> in the session. perf needs to allow each event to have its own sample_type
>> and not force a minimal compatibility.
>
> Why?  The impact is small. The kernel API is completely unchanged.

I'd like to see libperf become a stable, usable library - usable by more 
than the perf binary and its builtin commands. I have already done this 
once for a daemon, and it was a PITA to get the specific use functional 
without memory leaks/growth in the libperf part.

With respect to this specific patch it means appropriate flexibility in 
the data collected for events. ie., each event can have its own 
sample_type. For example if the tracepoint already contains task 
information TID is not needed - and IP may not be wanted either. The 
code processing the samples should not require all events to have some 
minimum data format - that just wastes buffer space.

David

