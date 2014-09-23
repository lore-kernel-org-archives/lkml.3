Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbaIWM3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:29:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbaIWM3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:29:04 -0400
Date: Tue, 23 Sep 2014 14:28:43 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jean Pihet <jean.pihet@linaro.org>, Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH 2/2] perf callchain: Use global caching provided by
 libunwind
Message-ID: <20140923122843.GF2979@krava.brq.redhat.com>
References: <1411453828-14832-1-git-send-email-namhyung@kernel.org>
 <1411453828-14832-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411453828-14832-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 03:30:28PM +0900, Namhyung Kim wrote:
> The libunwind provides two caching policy which are global and
> per-thread.  As perf unwinds callchains in a single thread, it'd
> sufficient to use global caching.
> 
> This speeds up my perf report from 14s to 7s on a ~260MB data file.
> Although the output contains a slight difference (~0.01% in terms of
> number of lines printed) on callchains which were not resolved.

hum, the speedup is nice, but what was the diff output.. any example?
The new version does not print some lines or different ones?

thanks,
jirka
