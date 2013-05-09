Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab3EINyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 09:54:32 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:33960 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab3EINyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 09:54:31 -0400
Message-ID: <518BAA92.2030101@gmail.com>
Date: Thu, 09 May 2013 07:54:26 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, fweisbec@gmail.com,
        peterz@infradead.org, jolsa@redhat.com, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH 10/13] perf kvm: add live mode
References: <1368073909-8825-1-git-send-email-dsahern@gmail.com> <1368073909-8825-11-git-send-email-dsahern@gmail.com> <20130509085137.GA8813@gmail.com>
In-Reply-To: <20130509085137.GA8813@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/13 2:51 AM, Ingo Molnar wrote:
> 1)
>
> Regarding the basic syntax - is the 'perf stat kvm' command already used
> up? If not then it might make sense to alias 'perf kvm stat live' to 'perf
> kvm stat', making it really easy to use:
>
>    perf kvm stat
>    perf kvm stat -p <pid>
>
> etc. I'd expect most 'perf kvm stat' users to utilize this syntax - so it
> makes sense to make 'live' the default and main command.

The default is for 'perf kvm stat' to call cmd_stat (i.e, perf kvm stat 
== perf stat with perf_guest flag set to 1).

>
> 2)
>
> Another suggestion: it would be nice to allow a "--repeat <n>" option as
> well, for a limited number of iterations - similar to what the 'top' tool
> allows:
>
>    top -b -d <delay> -n <iterations>
>
> --repeat 0 means infinite repeats, --repeat 1 means a single step.

Missed that option in perf-top. Let me take a look at it.

> 3)
>
> It might make sense to create 'perf kvm stat top' which is a small
> variation to 'perf kvm stat live': it outputs a perf stat output per
> second, but also outputs a clear-screen sequence before the output.
>
> To keep it simple you could do this with plain console text output, not
> libslang, the C code to generate a clear screen sequence can be generated
> via this shell oneliner:
>
>    echo 'prinf("'$(clear)'");' > clearscreen.c
>
> This way people could see constantly updating top-alike KVM statistics.

Ok, once the basic live command is pulled into Arnaldo's tree I can look 
at variations like these last 2 suggestions.

David
