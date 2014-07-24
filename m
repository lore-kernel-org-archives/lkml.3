Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995AbaGXNLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:11:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758645AbaGXNLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:11:33 -0400
Date: Thu, 24 Jul 2014 15:11:20 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET 0/6] perf tools: Honor column width setting
Message-ID: <20140724131120.GD7652@krava.brq.redhat.com>
References: <1404883694-5342-1-git-send-email-namhyung@kernel.org>
 <20140721090755.GA8865@krava.redhat.com>
 <87r41cjzez.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r41cjzez.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 04:40:36PM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Mon, 21 Jul 2014 11:07:55 +0200, Jiri Olsa wrote:
> > On Wed, Jul 09, 2014 at 02:28:08PM +0900, Namhyung Kim wrote:
> >> Hello,
> >> 
> >> This patchset is to control perf report/top output column width by
> >> -w/--column-widths option so that it can fit into the terminal size.
> >> The -w option is there for perf report but it ignored by recent output
> >> field changed due to some reason.  This patchset fixes it and supports
> >> perf top also.
> >> 
> >> This is sometimes useful if your terminal is small and there's some
> >> C++ applications which have amazingly long symbol names.  Without this
> >> patchset user might not see those symbols on TUI, since it maps
> >> left/right arrow keys to other functions.
> >> 
> >> The -w option sets column width starting from the first column
> >> (overhead or optional overhead_children column unless -F option is
> >> given).  It doesn't make sense to limit those overhead columns so it's
> >> not a hard-limit for them.  But it *is* a hard-limit for other columns
> >> such as comm, dso, symbol, and so on.  One can use 0 not to
> >> limit/force a width for those columns.
> >
> > hi,
> > I've got broken TUI output for "perf report --group" 
> >
> > Samples: 17  of event 'anon group { cycles, instructions }', Event count (approx.): 9145256
> >  56.44% 31.59%  ls  libc-2.17.so       [.] __strcoll_l
> >  39.94% 0.00%  ls  ld-2.17.so         [.] _dl_new_object
> >  3.48% 0.00%  ls  [kernel.kallsyms]  [k] setup_arg_pages
> >  0.14% 0.33%  ls  [kernel.kallsyms]  [k] native_write_msr_safe
> >  0.00% 30.17%  ls  [kernel.kallsyms]  [k] security_inode_permission
> >  0.00% 29.78%  ls  ls                 [.] indent
> >  0.00% 8.12%  ls  [kernel.kallsyms]  [k] __slab_alloc
> >
> > I have 'show-headers' set to false in ~/.perfconfig and the output
> > got fixed after displaying headers by pressing 'H'
> 
> Argh, you're right.  It should be fixed with this patch:

yep, that fixed that for me

thanks,
jirka
