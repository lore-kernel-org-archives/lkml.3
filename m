Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037AbaKDFDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 00:03:09 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51997 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaKDFDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 00:03:04 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        srikar@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brendan Gregg <brendan.gregg@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH perf/core 0/6] perf-probe: Bugfix and add new options for cache
References: <20141031185128.27889.32747.stgit@localhost.localdomain>
	<20141031121301.GI1313@kernel.org> <545770E6.2010506@hitachi.com>
	<20141103161900.GA18464@kernel.org>
Date: Tue, 04 Nov 2014 14:02:55 +0900
In-Reply-To: <20141103161900.GA18464@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Mon, 3 Nov 2014 14:19:00 -0200")
Message-ID: <87y4rr5zi8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and Masami,

On Mon, 3 Nov 2014 14:19:00 -0200, Arnaldo Carvalho de Melo wrote:
> [root@zoo ~]# perf buildid-cache --hell
>   Error: unknown option `hell'
>
>  usage: perf buildid-cache [<options>]
>
>     -a, --add <file list>
>                           file(s) to add
>     -k, --kcore <file>    kcore file to add
>     -r, --remove <file list>
>                           file(s) to remove
>     -M, --missing <file>  to find missing build ids in the cache
>     -f, --force           don't complain, do it
>     -u, --update <file list>
>                           file(s) to update
>     -v, --verbose         be more verbose
>
> [root@zoo ~]#
>
> Already has support for yet another of content: kcore files, its just a matter of adding
> one more:
>
>    perf buildid-cache --probe 

But it deals with binaries, and what we need is probe points.  So maybe
it's worth add a new command like:

     perf probe-cache [add|del|enable|disable] [<options>] [<path>|<build-id>] <spec>...
  or perf probe-cache list [<options>]


This way we can handle both of kprobes and uprobes (so SDTs).  What do
you think?

Thanks,
Namhyung
