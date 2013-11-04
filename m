Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab3KDNeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 08:34:23 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:49529 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3KDNeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 08:34:22 -0500
Date: Mon, 4 Nov 2013 14:34:16 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: Re: [RFC/PATCHSET 00/14] perf report: Add support to accumulate hist
 periods (v2)
Message-ID: <20131104133415.GD9299@localhost.localdomain>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
 <20131031080932.GA8479@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031080932.GA8479@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 09:09:32AM +0100, Ingo Molnar wrote:
> 
> 
> * Namhyung Kim <namhyung@kernel.org> wrote:
> 
> > When the -g cumulative option is given, it'll be shown like this:
> > 
> >   $ perf report -g cumulative --stdio
> > 
> >   # Overhead  Overhead (Acc)  Command      Shared Object                   Symbol
> >   # ........  ..............  .......  .................  .......................
> >   #
> >        0.00%          88.29%      abc  libc-2.17.so       [.] __libc_start_main  
> >        0.00%          88.29%      abc  abc                [.] main               
> >        0.00%          88.29%      abc  abc                [.] c                  
> >        0.00%          88.29%      abc  abc                [.] b                  
> >       88.29%          88.29%      abc  abc                [.] a                  
> >        0.00%          11.61%      abc  ld-2.17.so         [k] _dl_sysdep_start   
> >        0.00%           9.43%      abc  ld-2.17.so         [.] dl_main            
> >        9.43%           9.43%      abc  ld-2.17.so         [.] _dl_relocate_object
> >        2.27%           2.27%      abc  [kernel.kallsyms]  [k] page_fault         
> >        0.00%           2.18%      abc  ld-2.17.so         [k] _dl_start_user     
> >        0.00%           0.10%      abc  ld-2.17.so         [.] _start             
> > 
> > As you can see __libc_start_main -> main -> c -> b -> a callchain 
> > show up in the output.
> 
> This looks really useful!
> 
> A couple of details:
> 
> 1)
> 
> This is pretty close to SysProf output, right? So why not use the 
> well-known SysProf naming and call the first column 'self' and the 
> second column 'total'? I think those names are pretty intuitive and 
> it would help people who come from SysProf over to perf.
> 
> 2)
> 
> Is it possible to configure the default 'report -g' style, so that 
> people who'd like to use it all the time don't have to type '-g 
> cumulative' all the time?
> 
> 3)
> 
> I'd even argue that we enable this reporting feature by default, if 
> a data file includes call-chain data: the first column will still 
> show the well-known percentage that perf report produces today, the 
> second column will be a new feature in essence.
> 
> The only open question would be, by which column should we sort: 
> 'sysprof style' sorts by 'total', 'perf style' sorts by 'self'. 
> Agreed?

Defaulting that behaviour may make sense but we can expect some visible overhead
out of it though. Adding one hist per callchain entry has probably some
measurable impact.

How about we wait to see that option mature upstream a bit first then we can
decide about making it the default once we have measured and maybe optimized
the resulting overhead?

Thanks.
