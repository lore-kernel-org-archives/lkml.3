Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161020AbaDWURE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 16:17:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932248AbaDWURA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 16:17:00 -0400
Date: Wed, 23 Apr 2014 22:16:42 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH 0/3] perf tools: Speedup DWARF unwind
Message-ID: <20140423201642.GA1123@krava.redhat.com>
References: <1397756352-26694-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397756352-26694-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 07:39:09PM +0200, Jiri Olsa wrote:
> hi,
> trying to speedup DWARF unwind report code by factoring
> related code:
>   - caching sample's registers access
>   - keep dso data file descriptor open for the
>     life of the dso object
>   - replace dso cache code by mapping dso data file
>     directly for the life of the dso object
> 
> The speedup is mainly for libunwind unwind. The libdw will benefit
> mainly from cached registers access, because it handles dso data
> accesses by itself.. and anyway it's still faster ;-).
> 
> Also reachable in here:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   perf/core_unwind_speedup

rebased to latest tip perf/core, review appreciated ;-)

jirka
