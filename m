Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab3JHNdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:33:33 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:46092 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3JHNdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:33:32 -0400
Date: Tue, 8 Oct 2013 10:33:25 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/3] perf stat: Don't require a workload when using
 system wide or CPU options
Message-ID: <20131008133325.GF4018@ghostprotocols.net>
References: <1380400080-9211-1-git-send-email-dsahern@gmail.com>
 <1380400080-9211-3-git-send-email-dsahern@gmail.com>
 <87li2eofvd.fsf@sejong.aot.lge.com>
 <52497F3C.9070908@gmail.com>
 <20131008123928.GA4018@ghostprotocols.net>
 <525407D3.8060805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525407D3.8060805@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 08, 2013 at 07:25:39AM -0600, David Ahern escreveu:
> On 10/8/13 6:39 AM, Arnaldo Carvalho de Melo wrote:
> >While trying it noticed this, that should also be fixed
> >eventually:

> >[root@zoo ~]# perf stat -c C 0
> >C: No such file or directory
 
> you are missing '-' before the C:  perf stat -C 0. The -C = cpus. -c
> for stat is scale.

Nah, I mean:

[acme@zoo linux]$ perf stat non-existent-proggie
non-existent-proggie: No such file or directory

 Performance counter stats for 'non-existent-proggie':

     <not counted> task-clock              
     <not counted> context-switches        
     <not counted> cpu-migrations          
     <not counted> page-faults             
     <not counted> cycles                  
     <not counted> stalled-cycles-frontend 
   <not supported> stalled-cycles-backend  
     <not counted> instructions            
     <not counted> branches                
     <not counted> branch-misses           

       0.001823577 seconds time elapsed

[acme@zoo linux]$

Why should we report all those counters for something that wasn't found
in PATH?

We either report just the first line, with the errno, or that and the
last, with how long it took to try to execute it, but that probably
shouldn't be printed, as it is supposed to be how long the workload ran,
right?

- Arnaldo
