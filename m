Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbaDFMxI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 08:53:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbaDFMxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 08:53:05 -0400
Date: Sun, 6 Apr 2014 14:52:48 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH -tip ] [BUGFIX] perf/probe: Fix to handle errors in
 line_range searching
Message-ID: <20140406125248.GI1164@krava.brq.redhat.com>
References: <CAM9d7cgtuh5BBi34WaZWxfJnNjnazZD+Aas37SsEad1pZxe_kg@mail.gmail.com>
 <20140402054831.19080.27006.stgit@ltc230.yrl.intra.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140402054831.19080.27006.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 02:48:31PM +0900, Masami Hiramatsu wrote:
> As Namhyung reported(https://lkml.org/lkml/2014/4/1/89),
> current perf-probe -L option doesn't handle errors in line-range
> searching correctly. It causes a SEGV if an error occured in the
> line-range searching.
> 
>   ----
>   $ perf probe -x ./perf -v -L map__load
>   Open Debuginfo file: /home/namhyung/project/linux/tools/perf/perf
>   fname: util/map.c, lineno:153
>   New line range: 153 to 2147483647
>   path: (null)
>   Segmentation fault (core dumped)
>   ----
> 
> This is because line_range_inline_cb() ignores errors
> from find_line_range_by_line() which means that lr->path is
> already freed on the error path in find_line_range_by_line().
> As a result, get_real_path() accesses the lr->path and it
> causes a NULL pointer exception.
> 
> This fixes line_range_inline_cb() to handle the error correctly,
> and report it to the caller.
> 
> Anyway, this just fixes a possible SEGV bug, Namhyung's patch
> is also required.

will take both.. Namhyung, ack to Masami's change?

thanks,
jirka
