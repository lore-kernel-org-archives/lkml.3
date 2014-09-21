Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaIUSZS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 14:25:18 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51312 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaIUSZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 14:25:16 -0400
Message-ID: <541F1802.6000806@gmail.com>
Date: Sun, 21 Sep 2014 12:25:06 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, Milian Wolff <mail@milianw.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET 0/5] perf tools: Add call-graph config options
References: <1411229886-24390-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1411229886-24390-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/20/14, 10:18 AM, Namhyung Kim wrote:
> Hello,
>
> This is patchset to add new callchain related config options so that
> users don't need to pass their preference to the cmdline everytime.
>
> Following config options will be added, and users can set appropriate
> values to ~/.perfconfig file.  Note that the dump-size option is
> meaningful only if record-mode = dwarf.
>
>    $ cat ~/.perfconfig
>    [call-graph]
>      record-mode = dwarf
>      dump-size = 4096
>      print-type = graph
>      order = callee
>      threshold = 0.5
>      print-limit = 128
>      sort-key = function
>
>    $ perf record -vg sleep 1
>    callchain: type DWARF
>    callchain: stack dump size 4096
>    mmap size 528384B
>    [ perf record: Woken up 1 times to write data ]
>    [ perf record: Captured and wrote 0.054 MB perf.data (~2378 samples) ]
>    Looking at the vmlinux_path (7 entries long)
>    Using /lib/modules/3.16.3-1-ARCH/build/vmlinux for symbols
>
>
> You can also get this from 'perf/callchain-config-v1' branch on my tree
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
>

Looks ok to me. Reviewed-by: David Ahern <dsahern@gmail.com>

