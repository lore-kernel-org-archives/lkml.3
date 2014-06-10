Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaFJFBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 01:01:09 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:51012 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaFJFBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 01:01:07 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv4 00/13] perf tools: Speedup DWARF unwind
References: <1401892622-30848-1-git-send-email-jolsa@kernel.org>
Date: Tue, 10 Jun 2014 14:01:05 +0900
In-Reply-To: <1401892622-30848-1-git-send-email-jolsa@kernel.org> (Jiri Olsa's
	message of "Wed, 4 Jun 2014 16:36:49 +0200")
Message-ID: <87wqcpbbou.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Wed,  4 Jun 2014 16:36:49 +0200, Jiri Olsa wrote:
> hi,
> trying to speedup DWARF unwind report code by factoring
> related code:
>   - caching sample's registers access
>   - keep dso data file descriptor open for the
>     life of the dso object
>   - replace dso cache code by mapping dso data file
>     directly for the life of the dso object
>
> The speedup is mainly for libunwind unwind. The libdw will benefit
> mainly from cached registers access, because it handles dso data
> accesses by itself.. and anyway it's still faster ;-).
>
> On ~11GB perf data file with dwarf unwind data I've got
> around 30% speed up.
>
> I've also got possitive test feedback from Jean Pihet:
>   https://wiki.linaro.org/LEG/Engineering/TOOLS/perf-callstack-unwinding#Speed_improvement

For the series,

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
