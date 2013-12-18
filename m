Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab3LRRrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:47:24 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:44333 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab3LRRrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:47:22 -0500
Date: Wed, 18 Dec 2013 14:47:15 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [RFC/PATCHSET 00/18] perf report: Add support to accumulate hist
 periods (v3)
Message-ID: <20131218174715.GF4819@ghostprotocols.net>
References: <1387344086-12744-1-git-send-email-namhyung@kernel.org>
 <20131218094622.GA19240@gmail.com>
 <1387377469.1717.12.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387377469.1717.12.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 18, 2013 at 11:37:49PM +0900, Namhyung Kim escreveu:
> 2013-12-18 (수), 10:46 +0100, Ingo Molnar:
> > * Namhyung Kim <namhyung@kernel.org> wrote:

> > > I changed the option as a separate --cumulate and added a new
> > > "Total" column (and renamed the default "Overhead" column into
> > > "Self").  The output will be sorted by total (cumulative) overhead
> > > for now.  The reason I changed to the --cumulate is that I still
> > > think it's much different from other --callchain options and I
> > > plan to add support for showing (remaining) callchains to
> > > cumulative entries too.  The --callchain option will take care of
> > > it even with --cumulate option.

> > So I still think this is a fantastic feature, and while this variant 
> > of the user interface is an improvement over the previous version, we 
> > are not there yet ;-)
> 
> Right.  But I want to finish the core part of this patchset first.  And
> then I will work on the UI part since it'll be a quite large work by
> itself, I guess.

I got the first few ones, that are not really related to this, to reduce
the patchkit size, will go thru the others next.
 
> > So the natural way to get this would something like:
> > 
> > 	perf report --total
> > 
> > Or, if '--total' does not feel good, maybe we should change 'Total' to 
> > 'Siblings' or 'Children', and propagate that naming through the UI:
> 
> Childrend looks better to me.

--children, ack

> >    $ perf report --children --stdio
> >  
> >    #     Self  Children  Command      Shared Object                   Symbol
> >    # ........  ........  .......  .................  .......................
> >    #
> >         0.00%    88.29%      abc  libc-2.17.so       [.] __libc_start_main  
> >         0.00%    88.29%      abc  abc                [.] main               
> >         0.00%    88.29%      abc  abc                [.] c                  
> >         0.00%    88.29%      abc  abc                [.] b                  
> >        88.29%    88.29%      abc  abc                [.] a                  
> >         0.00%    11.61%      abc  ld-2.17.so         [.] _dl_sysdep_start   
> > 
> > Which shows the sum of overhead of all child functions as well, not 
> > just ourselves.
> > 
> > Anything but 'cumulative'. That word, beyond being a strange, hard to 
> > remember Latin word, also does not tell the user (or the developer) 
> > anything about _what_ is being accumulated. It could cover anything.
> > 
> > I also think this option should be enabled by default - lets see how 
> > much people complain about that.
> > 
> > Okay?
> 
> Okay.  I'll make it default in the next spin.
> 
> Thanks,
> Namhyung
> 
