Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaDOFoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 01:44:55 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:45739 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaDOFoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 01:44:54 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Richard Yao <ryao@gentoo.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf machine: Search for modules in %s/lib/modules/%s
References: <1397148779-9169-1-git-send-email-ryao@gentoo.org>
Date: Tue, 15 Apr 2014 14:44:52 +0900
In-Reply-To: <1397148779-9169-1-git-send-email-ryao@gentoo.org> (Richard Yao's
	message of "Thu, 10 Apr 2014 12:52:59 -0400")
Message-ID: <871twztacr.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Thu, 10 Apr 2014 12:52:59 -0400, Richard Yao wrote:
> Modules installed outside of the kernel's build system should go into
> "%s/lib/modules/%s/extra", but at present, perf will only look at them
> when they are in "%s/lib/modules/%s/kernel". Lets encourage good
> citizenship by relaxing this requirement to "%s/lib/modules/%s". This
> way open source modules that are out-of-tree have no incentive to start
> populating a directory reserved for in-kernle modules and I can stop hex
> editing my system's perf binary when profiling OSS out-of-tree modules.

But it'll make the perf traverses all the source and build directories
too, right?  I don't think it's a right thing to do.

Maybe we can also change stat() in map_groups__set_modules_path_dir() to
lstat() so that it cannot go to unwanted directories in that case.  Or
else, just checking "kernel" and "extra" directories will work.

Thanks,
Namhyung
