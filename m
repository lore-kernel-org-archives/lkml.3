Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab3KER2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:28:23 -0500
Received: from mail-gg0-f170.google.com ([209.85.161.170]:34413 "EHLO
	mail-gg0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab3KER2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:28:20 -0500
Date: Tue, 5 Nov 2013 14:28:12 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] perf timechart improvements
Message-ID: <20131105172812.GA7329@ghostprotocols.net>
References: <1383323151-19810-1-git-send-email-stfomichev@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383323151-19810-1-git-send-email-stfomichev@yandex-team.ru>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 01, 2013 at 08:25:44PM +0400, Stanislav Fomichev escreveu:
> This patch series adds more features to the perf timechart command:
> * -n option that adds possibility to limit number of tasks on SVG
> * -T option that adds possibility to show only tasks related info
> * -T and -P options now work with `perf timechart record` command to keep
>   perf.data small
> * -g option that adds possibility to record and add callchain to the SVG so
>   it's now possible to understand why some task went to sleep or what code
>   path woke it up
> * add titles to the SVG blocks so it's possible to see how long task is
>   running/sleeping/blocked
> 
> v2:
> * fix errors pointed out by Namhyung Kim <namhyung@kernel.org>

Namhyung, are you ok now? Acked-by?

- Arnaldo
 
> Stanislav Fomichev (7):
>   perf timechart: always try to print at least 15 tasks
>   perf timechart: add option to limit number of tasks
>   perf timechart: use proc_num to implement --power-only
>   perf timechart: add support for displaying only tasks related data
>   perf timechart: group figures and add title with details
>   perf timechart: add support for -P and -T in timechart recording
>   perf timechart: add backtrace support
> 
>  tools/perf/Documentation/perf-timechart.txt |  25 ++-
>  tools/perf/builtin-timechart.c              | 307 ++++++++++++++++++++++------
>  tools/perf/util/svghelper.c                 |  77 ++++++-
>  tools/perf/util/svghelper.h                 |  11 +-
>  4 files changed, 348 insertions(+), 72 deletions(-)
> 
> -- 
> 1.8.3.2
