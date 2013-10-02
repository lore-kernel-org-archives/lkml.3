Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab3JBNCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 09:02:44 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:34024 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab3JBNCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 09:02:43 -0400
Message-ID: <524C1964.8090205@gmail.com>
Date: Wed, 02 Oct 2013 07:02:28 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [QUERY] Why does perf-trace need me to be root?
References: <CALkWK0mmUZe-Wv2H2Z3y9FN0_kYv9gKaaXkMQ0UD-J9Q+=wFzQ@mail.gmail.com>
In-Reply-To: <CALkWK0mmUZe-Wv2H2Z3y9FN0_kYv9gKaaXkMQ0UD-J9Q+=wFzQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/13 3:20 AM, Ramkumar Ramachandra wrote:
> Hi,
>
> All the other perf tooling can be used as a normal user. At one point,
> I had to touch /proc/sys/kernel/perf_event_paranoid to get me numbers
> on a PMU event without a symbolic name, but that's about it.
> perf-trace seems to be the exception though:
>
>    artagnon|perf-core=:~/src/linux/tools/perf$ perf trace -a -e open
>    Couldn't read the raw_syscalls tracepoints information!
>
> The responsible codepath is:
>
>    if (perf_evlist__add_newtp(evlist, "raw_syscalls", "sys_enter",
> trace__sys_enter) ||
>       perf_evlist__add_newtp(evlist, "raw_syscalls", "sys_exit",
> trace__sys_exit)) {
>
> I don't understand much of what's going on, but what can be done to
> improve the situation for users?

If you trust your users make the debugfs mount point rx by group,world.

David

