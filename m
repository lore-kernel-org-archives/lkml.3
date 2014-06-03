Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbaFCDVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 23:21:45 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39760 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbaFCDVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 23:21:44 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf record: Fix poll return value propagation
References: <1401732126-19465-1-git-send-email-jolsa@kernel.org>
Date: Tue, 03 Jun 2014 12:21:43 +0900
In-Reply-To: <1401732126-19465-1-git-send-email-jolsa@kernel.org> (Jiri Olsa's
	message of "Mon, 2 Jun 2014 20:02:06 +0200")
Message-ID: <87ppiqd6ew.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Jun 2014 20:02:06 +0200, Jiri Olsa wrote:
> If the perf record command is interrupted in record__mmap_read_all
> function, the 'done' is set and err has the latest poll return
> value, which is most likely positive number (= number of pollfds
> ready to read).
>
> This 'positive err' is then propagated to the exit code, resulting
> in not finishing the perf.data header properly, causing following
> error in report:
>
>   # perf record -F 50000 -a
>
>   ---
>   make the system real busy, so there's more chance
>   to interrupt perf in event writing code
>   ---
>
>   ^C[ perf record: Woken up 16 times to write data ]
>   [ perf record: Captured and wrote 30.292 MB perf.data (~1323468 samples) ]
>
>   # perf report --stdio > /dev/null
>   WARNING: The perf.data file's data size field is 0 which is unexpected.
>   Was the 'perf record' command properly terminated?
>
> Fixing this by checking for positive poll return value
> and setting err to 0.

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
