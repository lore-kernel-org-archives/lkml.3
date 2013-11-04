Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab3KDN1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 08:27:51 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:61404 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab3KDN1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 08:27:49 -0500
Date: Mon, 4 Nov 2013 14:27:38 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: Re: [RFC/PATCHSET 00/14] perf report: Add support to accumulate hist
 periods (v2)
Message-ID: <20131104132737.GC9299@localhost.localdomain>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
 <20131031080932.GA8479@gmail.com>
 <87vc0c4ny2.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vc0c4ny2.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 03:48:37PM +0900, Namhyung Kim wrote:
> Hi Ingo,
> 
> On Thu, 31 Oct 2013 09:09:32 +0100, Ingo Molnar wrote:
> > * Namhyung Kim <namhyung@kernel.org> wrote:
> >
> >> When the -g cumulative option is given, it'll be shown like this:
> >> 
> >>   $ perf report -g cumulative --stdio
> >> 
> >>   # Overhead  Overhead (Acc)  Command      Shared Object                   Symbol
> >>   # ........  ..............  .......  .................  .......................
> >>   #
> >>        0.00%          88.29%      abc  libc-2.17.so       [.] __libc_start_main  
> >>        0.00%          88.29%      abc  abc                [.] main               
> >>        0.00%          88.29%      abc  abc                [.] c                  
> >>        0.00%          88.29%      abc  abc                [.] b                  
> >>       88.29%          88.29%      abc  abc                [.] a                  
> >>        0.00%          11.61%      abc  ld-2.17.so         [k] _dl_sysdep_start   
> >>        0.00%           9.43%      abc  ld-2.17.so         [.] dl_main            
> >>        9.43%           9.43%      abc  ld-2.17.so         [.] _dl_relocate_object
> >>        2.27%           2.27%      abc  [kernel.kallsyms]  [k] page_fault         
> >>        0.00%           2.18%      abc  ld-2.17.so         [k] _dl_start_user     
> >>        0.00%           0.10%      abc  ld-2.17.so         [.] _start             
> >> 
> >> As you can see __libc_start_main -> main -> c -> b -> a callchain 
> >> show up in the output.
> >
> > This looks really useful!
> 
> Thanks! :)
> 
> >
> > A couple of details:
> >
> > 1)
> >
> > This is pretty close to SysProf output, right? So why not use the 
> > well-known SysProf naming and call the first column 'self' and the 
> > second column 'total'? I think those names are pretty intuitive and 
> > it would help people who come from SysProf over to perf.
> 
> Okay, I can do it. (Although sysprof seems to call it 'cumulative'
> rather than 'total' - but I think the 'total' is better since it's
> simpler and shorter.)

OTOH cumulative probably express better what it is about. Or branch cumulative
may be.

Total is confusing because we don't know against what it is.
