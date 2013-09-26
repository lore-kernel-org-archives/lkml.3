Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab3IZQLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 12:11:34 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:46117 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab3IZQLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 12:11:33 -0400
Date: Thu, 26 Sep 2013 13:11:27 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] tools/perf: remove non-existent entries in MANIFEST
Message-ID: <20130926161127.GF26159@ghostprotocols.net>
References: <1380205304-32224-1-git-send-email-artagnon@gmail.com>
 <52444F53.504@gmail.com>
 <CALkWK0k=c9ov-FWaR8ocD-XjUOEQWCLhv-4OjWFkJYmfMRV=QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0k=c9ov-FWaR8ocD-XjUOEQWCLhv-4OjWFkJYmfMRV=QQ@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 26, 2013 at 09:18:48PM +0530, Ramkumar Ramachandra escreveu:
> David Ahern wrote:
> > Did you create a tarfile after this change, unpack it somewhere out of three
> > and then verify perf builds?
> 
> Yeah, it builds fine. In fact, the archive generated from the current
> upstream is broken.

Could you please describe how it is broken?

[acme@zoo linux]$ git branch | grep '*'
* perf/urgent
[acme@zoo linux]$ git describe
v3.12-rc1-51-gc1bf214
[acme@zoo linux]$ make perf-tar-src-pkg
  TAR
[acme@zoo linux]$ mv perf-3.12.0-rc1.tar /tmp
[acme@zoo linux]$ cd /tmp
[acme@zoo tmp]$ tar xf perf-3.12.0-rc1.tar 
[acme@zoo tmp]$ cd perf-3.12.0-rc1
[acme@zoo perf-3.12.0-rc1]$ make -j4 -C tools/perf
    CHK -fstack-protector-all
    CHK -Wstack-protector
    CHK -Wvolatile-register-var
<SNIP>
    CC util/parse-events-flex.o
    AR libperf.a
    LINK perf
make: Leaving directory `/tmp/perf-3.12.0-rc1/tools/perf'
[acme@zoo perf-3.12.0-rc1]$
[acme@zoo perf-3.12.0-rc1]$ file tools/perf/perf
tools/perf/perf: ELF 64-bit LSB executable, x86-64, version 1 (SYSV),
dynamically linked (uses shared libs), for GNU/Linux 2.6.32,
BuildID[sha1]=0x4ccfe4a3c71572532c54a478fec49ad1b38f1f3a, not stripped
[acme@zoo perf-3.12.0-rc1]$ 
[acme@zoo perf-3.12.0-rc1]$ tools/perf/perf --help | head -6

 usage: perf [--version] [--help] COMMAND [ARGS]

 The most commonly used perf commands are:
   annotate        Read perf.data (created by perf record) and display
annotated code
   archive         Create archive with object files with build-ids found
in perf.data file
[acme@zoo perf-3.12.0-rc1]$ tools/perf/perf stat usleep 1

 Performance counter stats for 'usleep 1':

          1.034116 task-clock                #    0.495 CPUs utilized          
                 2 context-switches          #    0.002 M/sec                  
                 1 cpu-migrations            #    0.967 K/sec                  
               140 page-faults               #    0.135 M/sec                  
         1,024,416 cycles                    #    0.991 GHz                    
           730,998 stalled-cycles-frontend   #   71.36% frontend cycles
idle   
   <not supported> stalled-cycles-backend  
           553,592 instructions              #    0.54  insns per cycle        
                                             #    1.32  stalled cycles
                                             #    per insn
           105,979 branches                  #  102.483 M/sec                  
             8,030 branch-misses             #    7.58% of all branches        

       0.002088462 seconds time elapsed

[acme@zoo perf-3.12.0-rc1]$

- Arnaldo
