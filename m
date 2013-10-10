Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab3JJGZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:25:01 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:51222 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3JJGY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:24:59 -0400
X-AuditID: 9c93016f-b7c63ae00000696f-ed-5256483aa8f4
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 48/52] tools/perf/build: Exclude MAKEFLAGS from nested invocation
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
	<1381227082-22039-49-git-send-email-mingo@kernel.org>
Date: Thu, 10 Oct 2013 15:24:58 +0900
In-Reply-To: <1381227082-22039-49-git-send-email-mingo@kernel.org> (Ingo
	Molnar's message of "Tue, 8 Oct 2013 12:11:18 +0200")
Message-ID: <87k3hliqx1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Oct 2013 12:11:18 +0200, Ingo Molnar wrote:
> In case the user specifies MAKEFLAGS as an environment variable,
> or uses 'make -jN' explicitly, the options can conflict and result in:
>
>     BUILD: Doing 'make -j8' parallel build
>     make[1]: warning: -jN forced in submake: disabling jobserver mode.
>     GEN common-cmds.h
>     make[1]: *** write jobserver: Bad file descriptor.  Stop.
>
> Make sure we invoke the main makefile in a pristine state.
>
> Users who want to do something non-standard can use the:
>
>   make -f Makefile.perf
>
> method to invoke the makefile.

Hmm... it'd be great if there's a way to detect -jN option and convert
it to the JOBS.

Thanks,
Namhyung
