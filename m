Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778AbbAIPGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:06:06 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:63028 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbbAIPGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:06:04 -0500
Message-ID: <54AFEE58.8060609@gmail.com>
Date: Fri, 09 Jan 2015 08:06:00 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] perf probe can't insert return kprobe
References: <20150109145539.GC14750@krava.brq.redhat.com> <20150109150314.GS2517@redhat.com>
In-Reply-To: <20150109150314.GS2517@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/9/15 8:03 AM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jan 09, 2015 at 03:55:39PM +0100, Jiri Olsa escreveu:
>> hi,
>> I couldn't use following perf command to insert return probe:
>>
>>    # perf probe -a fork_exit=do_fork%return
>>    Added new event:
>>    Failed to write event: Invalid argument
>>      Error: Failed to add events.
>
> Wonder if we have any way of forcing 'perf probe' to show what it will
> feed the kernel, perhaps -v?

# strace -e write perf probe -a fork_exit=do_fork%return
write(1, "Added new event:\n", 17Added new event:
)      = 17
write(3, "r:probe/fork_exit do_fork+0", 27) = 27

Would be nice to add the output to perf -v though.

David
