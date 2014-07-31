Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaGaO1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 10:27:18 -0400
Received: from mail.kernel.org ([198.145.19.201]:50119 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbaGaO1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 10:27:17 -0400
Date: Thu, 31 Jul 2014 11:27:11 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: perf tools: Question about kmem and kernel symbol resolution
Message-ID: <20140731142711.GX7831@kernel.org>
References: <CAM9d7ci1grg4NSMJahr-zjo+v8CkumbnwREhjkc+o6y9kYuaGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9d7ci1grg4NSMJahr-zjo+v8CkumbnwREhjkc+o6y9kYuaGw@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 31, 2014 at 05:35:32PM +0900, Namhyung Kim escreveu:
> I'm looking kernel symbol mismatch issue, and found something in perf
> kmem code.  The commit e727ca73f85d ("perf kmem: Resolve kernel
> symbols again") added perf_session__create_kernel_maps() but I don't
> know why.  Why did it miss the MMAP event?
 
> I think if we create a kernel maps at report time, it might not match
> to samples in a perf.data if it's recorded on a different kernel.
> This is the main reason of the mismatch problem I'm currently chasing
> IMHO.  What am I missing?

>From a quick look, nothing, i.e. we can not call
perf_session__create_kernel_maps() at that point, as it will create the
kernel maps from the running kernel and use it with events from the
kernel that was in place when the perf.data file being processed was
created.

Perhaps that problem was fixed somewhere else and we should just revert
that patch?

Have you tried just reverting it and checking that the results are the
expected ones? I.e. that there is the kernel MMAP event in perf.data
file and that it gets properly processed?

- Arnaldo
