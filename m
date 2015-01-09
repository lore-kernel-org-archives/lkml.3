Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681AbbAIPEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:04:44 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:64320 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340AbbAIPEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:04:42 -0500
Message-ID: <54AFEE06.1070000@gmail.com>
Date: Fri, 09 Jan 2015 08:04:38 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] perf probe can't insert return kprobe
References: <20150109145539.GC14750@krava.brq.redhat.com>
In-Reply-To: <20150109145539.GC14750@krava.brq.redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/9/15 7:55 AM, Jiri Olsa wrote:
> hi,
> I couldn't use following perf command to insert return probe:
>
>    # perf probe -a fork_exit=do_fork%return
>    Added new event:
>    Failed to write event: Invalid argument
>      Error: Failed to add events.
>
>
> I'm pretty sure I used this command before, so seems like
> it's broken. I can still use debugfs tracing interface to
> do that:
>    # echo 'r:do_fork_entry do_fork' > kprobe_events
>
> I used Arnaldo's latest perf/core and FC20 kernel:
>
>    # uname -a
>    Linux krava 3.17.7-200.fc20.x86_64 #1 SMP Wed Dec 17 03:35:33 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
>    # ./perf version
>    perf version 3.18.g6a7d78
>

If you want to bisect it the perf-probe command works for me on FC20, 
3.17.7-200.fc20.x86_64 with perf from 3.12 (my local modified version is 
based on 3.12).

David

