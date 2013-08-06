Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab3HFLy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 07:54:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756310Ab3HFLyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 07:54:55 -0400
Date: Tue, 6 Aug 2013 13:54:40 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] perf tools: Enhance and correct srcline behavior
Message-ID: <20130806115440.GA1068@krava.brq.redhat.com>
References: <1375325744-26613-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375325744-26613-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 11:55:35AM +0900, Namhyung Kim wrote:
> Hello,
> 
> This patchset tries to fix and enhance current srcline behavior.
> 
> Firstly it doesn't actually sort by srcline info but by ip.  I suspect
> it was because of a performance reason to run external addr2line
> utility.  It showed the srcline info after hist entries were
> collapsed.  Thanks to Roberto, we now have internal implementation of
> addr2line using libbfd so can sort/compare by srcline of entries.
> 
> Second problem for me was it sometimes printed "??:0" and sometimes
> printed a raw ip value for unknown srcline info.  I changed to print
> the former consistently.
> 
> While at it, I found some bugs/leaks in srcline handling.  Patch 1-3
> are fixes for those and can be merged separately.
> 
> You can get this series on my 'perf/srcline-v1' branch in my tree at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
> 
> Any comments are welcome, thanks.
> Namhyung
> 
> 
> Namhyung Kim (8):
>   perf sort: Fix a memory leak on srcline
>   perf annotate: Reuse path from the result of addr2line
>   perf hists: Free srcline when freeing hist_entry
>   perf tools: Factor out get/free_srcline()
>   perf tools: Do not try to call addr2line for non-binary files
>   perf tools: Pass dso instead of dso_name to get_srcline()
>   perf tools: Save failed result of get_srcline()
>   perf tools: Fix srcline sort key behavior
> 
> Roberto Vitillo (1):
>   perf tools: Implement addr2line directly using libbfd
> 

nice..

Reviewed-by: Jiri Olsa <jolsa@redhat.com>
