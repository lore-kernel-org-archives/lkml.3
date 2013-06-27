Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab3F0F3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 01:29:23 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:47696 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab3F0F3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 01:29:22 -0400
X-AuditID: 9c93017e-b7cd1ae000002371-b7-51cbcdb166a0
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: perf tools: Introduce new -P/--parent-deep report option
References: <20130626145853.GA2309@ghostprotocols.net>
Date: Thu, 27 Jun 2013 14:29:21 +0900
In-Reply-To: <20130626145853.GA2309@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Wed, 26 Jun 2013 11:58:53 -0300")
Message-ID: <87a9mc15qm.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Wed, 26 Jun 2013 11:58:53 -0300, Arnaldo Carvalho de Melo wrote:
> Hi Jiri,
>
> 	About the patch below, can't this be solved by using a regex
> instead of a simple substring search instead of adding a new command
> line option?

???

IIUC he reused parent_regex for this.

And I think we can have the same effect by using -G and -p option
together without this new option.

Thanks,
Namhyung

>
> - Arnaldo
>
> commit 5b42ff035ec784c5c42c4a6bb9e7fada882f097e
> Author: Jiri Olsa <jolsa@redhat.com>
> Date:   Tue Jun 18 18:31:50 2013 +0200
>
>     perf tools: Introduce new -P/--parent-deep report option
>     
>     Introducing new -P/--parent-deep report option. It does the
>     same as '-p' but it force the deep search of the callchain
>     and looks for the deepest possible match.
>     
>     The -p option searches for the first match of the parent
>     pattern in the callchain.
>     
>       $ perf report -i perf.data.delete -p perf_session__delete -s parent
>     
>       +  99.51%  [other]
>       +   0.46%  perf_session__delete_dead_threads
>       +   0.03%  perf_session__delete
>       +   0.00%  perf_session__delete_threads
>     
>     so we got multiple 'different' matches instancies, while
>     they all belong under perf_session__delete function:
>     
>       $ perf report -i perf.data.delete -P perf_session__delete -s parent
>     
>       +  99.51%  [other]
>       +   0.49%  perf_session__delete
>     
>     NOTE the 'p' vs 'P' difference in above commands above.
