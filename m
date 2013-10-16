Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab3JPCsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 22:48:11 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42260 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab3JPCsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 22:48:10 -0400
X-AuditID: 9c930197-b7b88ae0000032c4-46-525dfe6744a6
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/3] perf tools: Add data object to handle perf data file
References: <1381847254-28809-1-git-send-email-jolsa@redhat.com>
	<1381847254-28809-2-git-send-email-jolsa@redhat.com>
Date: Wed, 16 Oct 2013 11:48:07 +0900
In-Reply-To: <1381847254-28809-2-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Tue, 15 Oct 2013 16:27:32 +0200")
Message-ID: <87a9ia9biw.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Tue, 15 Oct 2013 16:27:32 +0200, Jiri Olsa wrote:
> This patch is adding 'struct perf_data_file' object as
> a placeholder for all attributes regarding perf.data
> file handling. Changing perf_session__new to take it
> as an argument.
>
> The rest of the functionality will be added later to keep
> this change simple enough, because all the places using
> perf_session are changed now.

All three look good.

Btw, are you planning to support multiple per-cpu file record?  As you
know I suggested perf.data.dir approach in my perf-ftrace patchset (I'll
resend a new version soonish) something like below.  What do you think?

  perf.data.dir/
    |-- perf-cpu0.data
    |-- perf-cpu1.data
    |-- perf-cpu2.data
    `-- perf-cpu3.data

Maybe we could split sample data and other data (e.g. COMM, MMAP or some
user data?) to another file(s).

Thanks,
Namhyung
