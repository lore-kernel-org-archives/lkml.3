Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaAFLZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:25:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56397 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbaAFLZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:25:05 -0500
Date: Mon, 6 Jan 2014 12:24:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: enable close-on-exec flag on perf file
 descriptor
Message-ID: <20140106112436.GF31570@twins.programming.kicks-ass.net>
References: <cover.1388952061.git.ydroneaud@opteya.com>
 <8c03f54e1598b1727c19706f3af03f98685d9fe6.1388952061.git.ydroneaud@opteya.com>
 <20140106092929.GA31570@twins.programming.kicks-ass.net>
 <1389005485-12778-1-git-send-email-ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389005485-12778-1-git-send-email-ydroneaud@opteya.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 11:51:25AM +0100, Yann Droneaud wrote:
> In a previous patch [1][2], flag PERF_FLAG_FD_CLOEXEC was
> added to perf_event_open(2) syscall to allows userspace
> to enable close-on-exec behavor atomically when creating
> the file descriptor.
> 
> This patch makes perf tools use the new flag.
> 
> Beware that perf tools compiled with the new flag won't work
> on older kernel which do not support flag PERF_FLAG_FD_CLOEXEC.
> 
> [1] http://lkml.kernel.org/r/8c03f54e1598b1727c19706f3af03f98685d9fe6.1388952061.git.ydroneaud@opteya.com
> [2] https://patchwork.kernel.org/patch/3434971/
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> Link: http://lkml.kernel.org/r/cover.1388952061.git.ydroneaud@opteya.com

acme, ACK? I was thinking I'd keep these two patches together so the
entire things lands in tip in one go?
