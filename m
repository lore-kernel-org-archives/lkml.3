Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaJWVrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 17:47:35 -0400
Received: from mail.kernel.org ([198.145.19.201]:52235 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbaJWVre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 17:47:34 -0400
Date: Thu, 23 Oct 2014 18:47:29 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Wang Nan <wangnan0@huawei.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Waiman Long <Waiman.Long@hp.com>,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] perf tools: ensure return negitive value when write
 header error
Message-ID: <20141023214729.GQ14687@kernel.org>
References: <1413428909-80017-1-git-send-email-wangnan0@huawei.com>
 <87siigeghv.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87siigeghv.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 22, 2014 at 04:00:12PM +0900, Namhyung Kim escreveu:
> On Thu, 16 Oct 2014 11:08:29 +0800, Wang Nan wrote:
> > When 'perf record' write headers, it calls write_xxx in
> > tools/perf/util/header.c, and check return value. It rolls back all
> > working only when return value is negative.
> >
> > This patch ensures write_cpudesc() and write_total_mem() return negative number
> > when error. Without this patch, headers reported by 'perf report' header is
> > error in some platform. Following output is caputured on ARM, which doesn't
> > contain "Processor" field in /proc/cpuinfo. See "cpudesc", "total memory" and
> > "cmdline" field.
> >
> >    bash-4.2# perf record ls
> >    ...
> >    [ perf record: Woken up 1 times to write data ]
> >    [ perf record: Captured and wrote 0.001 MB perf.data (~36 samples) ]
> >    bash-4.2# perf report --stdio --header
> >    Error:
> >    The perf.data file has no samples!
> >    # ========
> >    # captured on: Fri Sep 12 10:09:10 2014
> >    # hostname : arma15el
> >    # os release : 3.17.0+
> >    # perf version : 3.10.53
> >    # arch : armv7l
> >    # nrcpus online : 4
> >    # nrcpus avail : 1
> >    # cpudesc : (null)
> >    # total memory : 0 kB
> >    # cmdline :
> >    # event : name = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 1, precise_ip = 0
> >    # pmu mappings: not available
> >    # ========
> >    #
> >
> > Signed-off-by: Wang Nan <wangnan0@huawei.com>
> 
> I guess the total_memory, cmdline and pmu mappings are somehow affected
> by the broken cpudesc.  Do they have their own problem on ARM?
> 
> Anyway I think it's good to check the result properly, so
> 
> Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks, applied

- Arnaldo
