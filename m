Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967327Ab3HICvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:51:24 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:64022 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758237Ab3HICvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 22:51:23 -0400
Message-ID: <5204592A.1040307@gmail.com>
Date: Thu, 08 Aug 2013 22:51:22 -0400
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 08/19] perf symbol: Save vmlinux or kallsyms path loaded
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com> <1375930261-77273-9-git-send-email-dsahern@gmail.com> <20130808150825.GC6102@ghostprotocols.net>
In-Reply-To: <20130808150825.GC6102@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/13 11:08 AM, Arnaldo Carvalho de Melo wrote:
> Em Wed, Aug 07, 2013 at 10:50:50PM -0400, David Ahern escreveu:
>> Save vmlinux or kallsyms path loaded using embedded default lookup (ie.,
>> not a user specified path). Upcoming perf sched timehist command requires
>> kernel symbols for properly computing idle times and prints a warning
>> if the kernel symbols are not loaded.
>
> With this we will not know if the user passed something to set those
> variables or if internally we did it, doesn't this break any existing
> code assumption?

I believe this only affects code paths that go to default locations.

I am not aware of any code that looks at the path once the syms are 
loaded. AFAIK the timehist command is the first.

David
