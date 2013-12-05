Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab3LEOdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:33:22 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:48213 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab3LEOdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:33:21 -0500
Message-ID: <52A08EB0.6010409@gmail.com>
Date: Thu, 05 Dec 2013 07:33:20 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 4/4] perf trace: Add option to specify machine type
References: <1386211302-31303-1-git-send-email-dsahern@gmail.com> <1386211302-31303-5-git-send-email-dsahern@gmail.com> <20131205135039.GB10333@ghostprotocols.net>
In-Reply-To: <20131205135039.GB10333@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/5/13, 6:50 AM, Arnaldo Carvalho de Melo wrote:
> Em Wed, Dec 04, 2013 at 07:41:42PM -0700, David Ahern escreveu:
>> Perhaps there is a better way to do this; I could not think of one and
>> I don't see any field in the tracepoint that can be leveraged. So ...
>>
>> perf-trace autodetects the machine type (e.g., i386, x86_64, etc) via
>> libaudit.
>
> And that means that using perf.data files from another machine, say,
> ARM, will produce completely bogus results :-\

Indeed all offline analysis of trace data is wrong because it uses the 
arch of the machine running perf. I am not hitting that problem, but 
analysis on box.

>
> We need a way to store this info in the perf.data header, i.e. use the
> same algorithm that libaudit uses in audit_detect_machine() (and set the
> open_id as well, btw) at 'perf record' time and store it somewhere.
>
> What we have now that could be used?
>
> Lets see:
>
> [acme@zoo linux]$ perf report | grep 'arch'
> # arch : x86_64
> [acme@zoo linux]$
>
> Would that be enough? Stephane?

That fixes one part -- using the arch in the file to translate system 
calls in the file.

But it is a per process problem: Some are 32-bit; others are 64-bit. I 
was hoping there was some option at the syscall entry level to tag the 
bitness. And then there is the problem of needing a solution that works 
from RHEL6 forward. This patch at least allows me to have sensible data 
until something more clever is thought of.

David

