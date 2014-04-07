Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbaDGFou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 01:44:50 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42759 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaDGFos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 01:44:48 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Apr 2014 01:44:48 EDT
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH -tip ] [BUGFIX] perf/probe: Fix to handle errors in line_range searching
References: <CAM9d7cgtuh5BBi34WaZWxfJnNjnazZD+Aas37SsEad1pZxe_kg@mail.gmail.com>
	<20140402054831.19080.27006.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140406125248.GI1164@krava.brq.redhat.com>
Date: Mon, 07 Apr 2014 14:29:46 +0900
In-Reply-To: <20140406125248.GI1164@krava.brq.redhat.com> (Jiri Olsa's message
	of "Sun, 6 Apr 2014 14:52:48 +0200")
Message-ID: <87ioqlyaet.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Apr 2014 14:52:48 +0200, Jiri Olsa wrote:
> On Wed, Apr 02, 2014 at 02:48:31PM +0900, Masami Hiramatsu wrote:
>> As Namhyung reported(https://lkml.org/lkml/2014/4/1/89),
>> current perf-probe -L option doesn't handle errors in line-range
>> searching correctly. It causes a SEGV if an error occured in the
>> line-range searching.
>> 
>>   ----
>>   $ perf probe -x ./perf -v -L map__load
>>   Open Debuginfo file: /home/namhyung/project/linux/tools/perf/perf
>>   fname: util/map.c, lineno:153
>>   New line range: 153 to 2147483647
>>   path: (null)
>>   Segmentation fault (core dumped)
>>   ----
>> 
>> This is because line_range_inline_cb() ignores errors
>> from find_line_range_by_line() which means that lr->path is
>> already freed on the error path in find_line_range_by_line().
>> As a result, get_real_path() accesses the lr->path and it
>> causes a NULL pointer exception.
>> 
>> This fixes line_range_inline_cb() to handle the error correctly,
>> and report it to the caller.
>> 
>> Anyway, this just fixes a possible SEGV bug, Namhyung's patch
>> is also required.
>
> will take both.. Namhyung, ack to Masami's change?

Yes,

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
