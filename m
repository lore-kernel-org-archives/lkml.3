Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbaITMQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 08:16:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbaITMQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 08:16:16 -0400
Date: Sat, 20 Sep 2014 14:14:38 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        William Cohen <wcohen@redhat.com>
Subject: Re: [PATCH 0/2] perf tool: improve error handling in
 perf_flag_probe()
Message-ID: <20140920121438.GB15481@krava.brq.redhat.com>
References: <cover.1410595700.git.ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1410595700.git.ydroneaud@opteya.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 10:46:22AM +0200, Yann Droneaud wrote:
> Hi,
> 
> Following the EBUSY errors reported by Jiri Olsa [1], I've tryed to
> improve a bit the way perf_flag_probe() handle errors.
> 
> In case EBUSY is returned by perf_event_open(), testing the function
> again without PERF_FLAG_FD_CLOEXEC is meaningless: EBUSY is not
> related to close-on-exec flag, so there's nothing to confirm.
> 
> For other errors, not yet handled by perf_flag_probe(), it's
> pointless to report a second error message for the same error code:
> the second check should not print an error if the error is the same
> as the one return for the first check.
> 
> [1] http://lkml.kernel.org/r/1406908014-8312-1-git-send-email-jolsa@kernel.org
> 
> Yann Droneaud (2):
>   perf tools: shortcut PERF_FLAG_FD_CLOEXEC probing in case of EBUSY
>     error
>   perf tools: report PERF_FLAG_FD_CLOEXEC probing error once

seems good to me, for the patchset:
Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka
