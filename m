Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab3DBPVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:21:31 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:35810 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab3DBPVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:21:30 -0400
Message-ID: <515AF776.3090105@gmail.com>
Date: Tue, 02 Apr 2013 09:21:26 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 20/23] perf: consolidate CONFIG_LIBELF checks in Makefile
References: <1364874877-5618-1-git-send-email-dsahern@gmail.com>  <1364874877-5618-21-git-send-email-dsahern@gmail.com> <1364895445.21627.98.camel@x61.thuisdomein>
In-Reply-To: <1364895445.21627.98.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/2/13 3:37 AM, Paul Bolle wrote:
> On Mon, 2013-04-01 at 21:54 -0600, David Ahern wrote:
>> --- a/tools/perf/Makefile
>> +++ b/tools/perf/Makefile
>> [...]
>> @@ -602,6 +590,16 @@ ifdef CONFIG_LIBELF
>>       endif
>>
>>   else
>> +    ifdef CONFIG_DWARF
>> +        $(error CONFIG_DWARF depends on LIBELF)
>> +    endif
>> +    ifdef CONFIG_DEMANGLE
>> +        $(error CONFIG_DEMANGLE depends on LIBELF)
>> +    endif
>> +    ifdef CONFIG_LIBUNWIND
>> +        $(error CONFIG_LIBUNWIND depends on LIBELF)
>> +    endif
>> +
>>       EXTLIBS := $(filter-out -lelf,$(EXTLIBS))
>>
>>       # Remove ELF/DWARF dependent codes
>
> A quick scan of your series suggests you check here for dependencies
> that are already enforced by the kconfig tools. Why is this needed?

Just a side effect of the evolutionary path from where the perf build is 
today to the kconfig route. Certainly the above (and similar ones) are 
not needed in the end.

David

