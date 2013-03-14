Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab3CNIlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:41:21 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:62858 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3CNIlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:41:19 -0400
X-AuditID: 9c930197-b7cc2ae000000eb7-d6-51418d2c1679
From: Namhyung Kim <namhyung@kernel.org>
To: chenggang <chenggang.qin@gmail.com>
Cc: linux-kernel@vger.kernel.org, chenggang <chenggang.qcg@taobao.com>,
        David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH]Perf: Fix Makefile to remove all "*.o" files while "make clean"
References: <1363240565-25687-1-git-send-email-chenggang.qin@gmail.com>
Date: Thu, 14 Mar 2013 17:41:16 +0900
In-Reply-To: <1363240565-25687-1-git-send-email-chenggang.qin@gmail.com>
	(chenggang's message of "Thu, 14 Mar 2013 13:56:05 +0800")
Message-ID: <87wqtajrv7.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi chenggang,

On Thu, 14 Mar 2013 13:56:05 +0800, chenggang wrote:
> From: chenggang <chenggang.qcg@taobao.com>
>
> While we run "make clean" in perf's directory, and run the command:
> "fine ./ -name *.o"
> we will get:
> ------------------------------------
> ./arch/x86/util/unwind.o
> ./arch/x86/util/header.o
> ./arch/x86/util/dwarf-regs.o
> ./util/scripting-engines/trace-event-python.o
> ./util/scripting-engines/trace-event-perl.o
> ./util/probe-finder.o
> ./util/dwarf-aux.o
> ./util/unwind.o
> ./lib/rbtree.o
> ./ui/browser.o
> ./ui/browsers/map.o
> ./ui/browsers/annotate.o
> ./ui/browsers/scripts.o
> ./ui/browsers/hists.o
> ./ui/tui/setup.o
> ./ui/tui/util.o
> ./ui/tui/helpline.o
> ./ui/tui/progress.o
> ./ui/gtk/browser.o
> ./ui/gtk/setup.o
> ./ui/gtk/util.o
> ./ui/gtk/helpline.o
> ./ui/gtk/annotate.o
> ./ui/gtk/progress.o
> ./ui/gtk/hists.o
> ./scripts/perl/Perf-Trace-Util/Context.o
> ./scripts/python/Perf-Trace-Util/Context.o
> ------------------------------------
> These ".o" files are not cleaned.
>
> This patch fixed this problem.

Hmm... They should be in $LIB_OBJS which already included in the recipe.
I guess it's missed because we skip the feature tests for "clean" (and
"tags" too) target now.  Sigh.

Thanks,
Namhyung
