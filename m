Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab3KVUJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 15:09:48 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:53919 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab3KVUJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 15:09:46 -0500
Message-ID: <528FBA0D.1040904@gmail.com>
Date: Fri, 22 Nov 2013 13:09:49 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/8] perf symbol: Save vmlinux or kallsyms path loaded
References: <1384806771-2945-1-git-send-email-dsahern@gmail.com> <1384806771-2945-4-git-send-email-dsahern@gmail.com> <20131122184458.GE11305@ghostprotocols.net> <528FACF0.5090604@gmail.com> <20131122194047.GF11305@ghostprotocols.net>
In-Reply-To: <20131122194047.GF11305@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/13, 12:40 PM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Nov 22, 2013 at 12:13:52PM -0700, David Ahern escreveu:
>> On 11/22/13, 11:44 AM, Arnaldo Carvalho de Melo wrote:
>>> Em Mon, Nov 18, 2013 at 01:32:46PM -0700, David Ahern escreveu:
>>>> Save vmlinux or kallsyms path loaded using embedded default lookup (ie.,
>>>> not a user specified path). Upcoming perf sched timehist command requires
>>>> kernel symbols for properly computing idle times and prints a warning
>>>> if the kernel symbols are not loaded.
>
>>> What would happen if strdup failed here?
>
>> perf continues on happily. On the timehist command will question
>> computation of idle times which require kernel symbols.
>
>>> Why don't we undo anything done so far in this function and return an
>>> error?
>
>> In the notion of best effort of continuing. It's not a show stopper
>> that strdup failed; it's just not the filename it used for symbols.
>
> So if later on one would need to print that info, it would just show
> "unknown"?

no. you get a warning message that idle values might be wrong.

David

