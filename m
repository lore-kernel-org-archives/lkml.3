Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab3KMFzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 00:55:35 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38668 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab3KMFz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 00:55:26 -0500
Date: Wed, 13 Nov 2013 11:25:18 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mikey@neuling.org
Subject: Re: [PATCH v2] sched: Check sched_domain before computing group
 power.
Message-ID: <20131113055518.GJ2559@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <tip-db2pe0vxwunv37plc7onnugj@git.kernel.org>
 <20131112105547.GA27310@linux.vnet.ibm.com>
 <20131112115736.GO5056@laptop.programming.kicks-ass.net>
 <20131112164126.GF2559@linux.vnet.ibm.com>
 <20131112170302.GC16796@laptop.programming.kicks-ass.net>
 <20131112171507.GG2559@linux.vnet.ibm.com>
 <20131112175554.GD21461@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131112175554.GD21461@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111305-0320-0000-0000-000001B4BBC1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2013-11-12 18:55:54]:

> On Tue, Nov 12, 2013 at 10:45:07PM +0530, Srikar Dronamraju wrote:
> > > 
> > > Hurm.. can you provide the actual topology of the machine that triggers
> > > this? My brain hurts trying to thing through the weird cases of this
> > > code.
> > > 
> > 
> > Hope this helps. Please do let me know if you were looking for pdf output.
> 
> PDFs go into /dev/null..
> 
> the below misses the interesting bits; being the node distance table.
> Also a complete sched_debug domain print is useful.
> 

available: 4 nodes (0-3)
node 0 cpus: 0 1 2 3 4 5 6 7 32 33 34 35 36 37 38 39
node 0 size: 64191 MB
node 0 free: 63194 MB
node 1 cpus: 8 9 10 11 12 13 14 15 40 41 42 43 44 45 46 47
node 1 size: 64481 MB
node 1 free: 63515 MB
node 2 cpus: 16 17 18 19 20 21 22 23 48 49 50 51 52 53 54 55
node 2 size: 64481 MB
node 2 free: 63536 MB
node 3 cpus: 24 25 26 27 28 29 30 31 56 57 58 59 60 61 62 63
node 3 size: 63968 MB
node 3 free: 62981 MB
node distances:
node   0   1   2   3 
  0:  10  11  11  12 
  1:  11  10  12  11 
  2:  11  12  10  11 
  3:  12  11  11  10 




x86: Booting SMP configuration:
.... node  #0, CPUs:        #1  #2  #3  #4  #5  #6  #7
.... node  #1, CPUs:    #8  #9 #10 #11 #12 #13 #14 #15
.... node  #2, CPUs:   #16 #17 #18 #19 #20 #21 #22 #23
.... node  #3, CPUs:   #24 #25 #26 #27 #28 #29 #30 #31
.... node  #0, CPUs:   #32 #33 #34 #35 #36 #37 #38 #39
.... node  #1, CPUs:   #40 #41 #42 #43 #44 #45 #46 #47
.... node  #2, CPUs:   #48 #49 #50 #51 #52 #53 #54 #55
.... node  #3, CPUs:   #56 #57 #58 #59 #60 #61 #62 #63
x86: Booted up 4 nodes, 64 CPUs
smpboot: Total of 64 processors activated (308393.92 BogoMIPS)
CPU0 attaching sched-domain:
 domain 0: span 0,32 level SIBLING
  groups: 0 (cpu_power = 588) 32 (cpu_power = 588)
  domain 1: span 0-7,32-39 level MC
   groups: 0,32 (cpu_power = 1176) 1,33 (cpu_power = 1178) 2,34 (cpu_power = 1178) 3,35 (cpu_power = 1178) 4,36 (cpu_power = 1178) 5,37 (cpu_power = 1178) 6,38 (cpu_power = 1178) 7,39 (cpu_power = 1176)
   domain 2: span 0-23,32-55 level NUMA
    groups: 0-7,32-39 (cpu_power = 9420) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU1 attaching sched-domain:
 domain 0: span 1,33 level SIBLING
  groups: 1 (cpu_power = 589) 33 (cpu_power = 589)
  domain 1: span 0-7,32-39 level MC
   groups: 1,33 (cpu_power = 1178) 2,34 (cpu_power = 1178) 3,35 (cpu_power = 1178) 4,36 (cpu_power = 1178) 5,37 (cpu_power = 1178) 6,38 (cpu_power = 1178) 7,39 (cpu_power = 1176) 0,32 (cpu_power = 1176)
   domain 2: span 0-23,32-55 level NUMA
    groups: 0-7,32-39 (cpu_power = 9420) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU2 attaching sched-domain:
 domain 0: span 2,34 level SIBLING
  groups: 2 (cpu_power = 589) 34 (cpu_power = 589)
  domain 1: span 0-7,32-39 level MC
   groups: 2,34 (cpu_power = 1178) 3,35 (cpu_power = 1178) 4,36 (cpu_power = 1178) 5,37 (cpu_power = 1178) 6,38 (cpu_power = 1178) 7,39 (cpu_power = 1176) 0,32 (cpu_power = 1176) 1,33 (cpu_power = 1178)
   domain 2: span 0-23,32-55 level NUMA
    groups: 0-7,32-39 (cpu_power = 9420) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU3 attaching sched-domain:
 domain 0: span 3,35 level SIBLING
  groups: 3 (cpu_power = 589) 35 (cpu_power = 589)
  domain 1: span 0-7,32-39 level MC
   groups: 3,35 (cpu_power = 1178) 4,36 (cpu_power = 1178) 5,37 (cpu_power = 1178) 6,38 (cpu_power = 1178) 7,39 (cpu_power = 1176) 0,32 (cpu_power = 1176) 1,33 (cpu_power = 1178) 2,34 (cpu_power = 1178)
   domain 2: span 0-23,32-55 level NUMA
    groups: 0-7,32-39 (cpu_power = 9420) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU4 attaching sched-domain:
 domain 0: span 4,36 level SIBLING
  groups: 4 (cpu_power = 589) 36 (cpu_power = 589)
  domain 1: span 0-7,32-39 level MC
   groups: 4,36 (cpu_power = 1178) 5,37 (cpu_power = 1178) 6,38 (cpu_power = 1178) 7,39 (cpu_power = 1176) 0,32 (cpu_power = 1176) 1,33 (cpu_power = 1178) 2,34 (cpu_power = 1178) 3,35 (cpu_power = 1178)
   domain 2: span 0-23,32-55 level NUMA
    groups: 0-7,32-39 (cpu_power = 9420) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU5 attaching sched-domain:
 domain 0: span 5,37 level SIBLING
  groups: 5 (cpu_power = 589) 37 (cpu_power = 589)
  domain 1: span 0-7,32-39 level MC
   groups: 5,37 (cpu_power = 1178) 6,38 (cpu_power = 1178) 7,39 (cpu_power = 1176) 0,32 (cpu_power = 1176) 1,33 (cpu_power = 1178) 2,34 (cpu_power = 1178) 3,35 (cpu_power = 1178) 4,36 (cpu_power = 1178)
   domain 2: span 0-23,32-55 level NUMA
    groups: 0-7,32-39 (cpu_power = 9420) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU6 attaching sched-domain:
 domain 0: span 6,38 level SIBLING
  groups: 6 (cpu_power = 589) 38 (cpu_power = 589)
  domain 1: span 0-7,32-39 level MC
   groups: 6,38 (cpu_power = 1178) 7,39 (cpu_power = 1176) 0,32 (cpu_power = 1176) 1,33 (cpu_power = 1178) 2,34 (cpu_power = 1178) 3,35 (cpu_power = 1178) 4,36 (cpu_power = 1178) 5,37 (cpu_power = 1178)
   domain 2: span 0-23,32-55 level NUMA
    groups: 0-7,32-39 (cpu_power = 9420) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU7 attaching sched-domain:
 domain 0: span 7,39 level SIBLING
  groups: 7 (cpu_power = 588) 39 (cpu_power = 588)
  domain 1: span 0-7,32-39 level MC
   groups: 7,39 (cpu_power = 1176) 0,32 (cpu_power = 1176) 1,33 (cpu_power = 1178) 2,34 (cpu_power = 1178) 3,35 (cpu_power = 1178) 4,36 (cpu_power = 1178) 5,37 (cpu_power = 1178) 6,38 (cpu_power = 1178)
   domain 2: span 0-23,32-55 level NUMA
    groups: 0-7,32-39 (cpu_power = 9420) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU8 attaching sched-domain:
 domain 0: span 8,40 level SIBLING
  groups: 8 (cpu_power = 588) 40 (cpu_power = 588)
  domain 1: span 8-15,40-47 level MC
   groups: 8,40 (cpu_power = 1176) 9,41 (cpu_power = 1176) 10,42 (cpu_power = 1176) 11,43 (cpu_power = 1176) 12,44 (cpu_power = 1176) 13,45 (cpu_power = 1176) 14,46 (cpu_power = 1176) 15,47 (cpu_power = 1176)
   domain 2: span 0-15,24-47,56-63 level NUMA
    groups: 8-15,40-47 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 8-31,40-63 (cpu_power = 28224) 0-23,32-55 (cpu_power = 28236)
CPU9 attaching sched-domain:
 domain 0: span 9,41 level SIBLING
  groups: 9 (cpu_power = 588) 41 (cpu_power = 588)
  domain 1: span 8-15,40-47 level MC
   groups: 9,41 (cpu_power = 1176) 10,42 (cpu_power = 1176) 11,43 (cpu_power = 1176) 12,44 (cpu_power = 1176) 13,45 (cpu_power = 1176) 14,46 (cpu_power = 1176) 15,47 (cpu_power = 1176) 8,40 (cpu_power = 1176)
   domain 2: span 0-15,24-47,56-63 level NUMA
    groups: 8-15,40-47 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU10 attaching sched-domain:
 domain 0: span 10,42 level SIBLING
  groups: 10 (cpu_power = 588) 42 (cpu_power = 588)
  domain 1: span 8-15,40-47 level MC
   groups: 10,42 (cpu_power = 1176) 11,43 (cpu_power = 1176) 12,44 (cpu_power = 1176) 13,45 (cpu_power = 1176) 14,46 (cpu_power = 1176) 15,47 (cpu_power = 1176) 8,40 (cpu_power = 1176) 9,41 (cpu_power = 1176)
   domain 2: span 0-15,24-47,56-63 level NUMA
    groups: 8-15,40-47 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU11 attaching sched-domain:
 domain 0: span 11,43 level SIBLING
  groups: 11 (cpu_power = 588) 43 (cpu_power = 588)
  domain 1: span 8-15,40-47 level MC
   groups: 11,43 (cpu_power = 1176) 12,44 (cpu_power = 1176) 13,45 (cpu_power = 1176) 14,46 (cpu_power = 1176) 15,47 (cpu_power = 1176) 8,40 (cpu_power = 1176) 9,41 (cpu_power = 1176) 10,42 (cpu_power = 1176)
   domain 2: span 0-15,24-47,56-63 level NUMA
    groups: 8-15,40-47 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU12 attaching sched-domain:
 domain 0: span 12,44 level SIBLING
  groups: 12 (cpu_power = 588) 44 (cpu_power = 588)
  domain 1: span 8-15,40-47 level MC
   groups: 12,44 (cpu_power = 1176) 13,45 (cpu_power = 1176) 14,46 (cpu_power = 1176) 15,47 (cpu_power = 1176) 8,40 (cpu_power = 1176) 9,41 (cpu_power = 1176) 10,42 (cpu_power = 1176) 11,43 (cpu_power = 1176)
   domain 2: span 0-15,24-47,56-63 level NUMA
    groups: 8-15,40-47 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU13 attaching sched-domain:
 domain 0: span 13,45 level SIBLING
  groups: 13 (cpu_power = 588) 45 (cpu_power = 588)
  domain 1: span 8-15,40-47 level MC
   groups: 13,45 (cpu_power = 1176) 14,46 (cpu_power = 1176) 15,47 (cpu_power = 1176) 8,40 (cpu_power = 1176) 9,41 (cpu_power = 1176) 10,42 (cpu_power = 1176) 11,43 (cpu_power = 1176) 12,44 (cpu_power = 1176)
   domain 2: span 0-15,24-47,56-63 level NUMA
    groups: 8-15,40-47 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU14 attaching sched-domain:
 domain 0: span 14,46 level SIBLING
  groups: 14 (cpu_power = 588) 46 (cpu_power = 588)
  domain 1: span 8-15,40-47 level MC
   groups: 14,46 (cpu_power = 1176) 15,47 (cpu_power = 1176) 8,40 (cpu_power = 1176) 9,41 (cpu_power = 1176) 10,42 (cpu_power = 1176) 11,43 (cpu_power = 1176) 12,44 (cpu_power = 1176) 13,45 (cpu_power = 1176)
   domain 2: span 0-15,24-47,56-63 level NUMA
    groups: 8-15,40-47 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU15 attaching sched-domain:
 domain 0: span 15,47 level SIBLING
  groups: 15 (cpu_power = 588) 47 (cpu_power = 588)
  domain 1: span 8-15,40-47 level MC
   groups: 15,47 (cpu_power = 1176) 8,40 (cpu_power = 1176) 9,41 (cpu_power = 1176) 10,42 (cpu_power = 1176) 11,43 (cpu_power = 1176) 12,44 (cpu_power = 1176) 13,45 (cpu_power = 1176) 14,46 (cpu_power = 1176)
   domain 2: span 0-15,24-47,56-63 level NUMA
    groups: 8-15,40-47 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU16 attaching sched-domain:
 domain 0: span 16,48 level SIBLING
  groups: 16 (cpu_power = 588) 48 (cpu_power = 588)
  domain 1: span 16-23,48-55 level MC
   groups: 16,48 (cpu_power = 1176) 17,49 (cpu_power = 1176) 18,50 (cpu_power = 1176) 19,51 (cpu_power = 1176) 20,52 (cpu_power = 1176) 21,53 (cpu_power = 1176) 22,54 (cpu_power = 1176) 23,55 (cpu_power = 1176)
   domain 2: span 0-7,16-39,48-63 level NUMA
    groups: 16-23,48-55 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU17 attaching sched-domain:
 domain 0: span 17,49 level SIBLING
  groups: 17 (cpu_power = 588) 49 (cpu_power = 588)
  domain 1: span 16-23,48-55 level MC
   groups: 17,49 (cpu_power = 1176) 18,50 (cpu_power = 1176) 19,51 (cpu_power = 1176) 20,52 (cpu_power = 1176) 21,53 (cpu_power = 1176) 22,54 (cpu_power = 1176) 23,55 (cpu_power = 1176) 16,48 (cpu_power = 1176)
   domain 2: span 0-7,16-39,48-63 level NUMA
    groups: 16-23,48-55 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU18 attaching sched-domain:
 domain 0: span 18,50 level SIBLING
  groups: 18 (cpu_power = 588) 50 (cpu_power = 588)
  domain 1: span 16-23,48-55 level MC
   groups: 18,50 (cpu_power = 1176) 19,51 (cpu_power = 1176) 20,52 (cpu_power = 1176) 21,53 (cpu_power = 1176) 22,54 (cpu_power = 1176) 23,55 (cpu_power = 1176) 16,48 (cpu_power = 1176) 17,49 (cpu_power = 1176)
   domain 2: span 0-7,16-39,48-63 level NUMA
    groups: 16-23,48-55 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU19 attaching sched-domain:
 domain 0: span 19,51 level SIBLING
  groups: 19 (cpu_power = 588) 51 (cpu_power = 588)
  domain 1: span 16-23,48-55 level MC
   groups: 19,51 (cpu_power = 1176) 20,52 (cpu_power = 1176) 21,53 (cpu_power = 1176) 22,54 (cpu_power = 1176) 23,55 (cpu_power = 1176) 16,48 (cpu_power = 1176) 17,49 (cpu_power = 1176) 18,50 (cpu_power = 1176)
   domain 2: span 0-7,16-39,48-63 level NUMA
    groups: 16-23,48-55 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU20 attaching sched-domain:
 domain 0: span 20,52 level SIBLING
  groups: 20 (cpu_power = 588) 52 (cpu_power = 588)
  domain 1: span 16-23,48-55 level MC
   groups: 20,52 (cpu_power = 1176) 21,53 (cpu_power = 1176) 22,54 (cpu_power = 1176) 23,55 (cpu_power = 1176) 16,48 (cpu_power = 1176) 17,49 (cpu_power = 1176) 18,50 (cpu_power = 1176) 19,51 (cpu_power = 1176)
   domain 2: span 0-7,16-39,48-63 level NUMA
    groups: 16-23,48-55 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU21 attaching sched-domain:
 domain 0: span 21,53 level SIBLING
  groups: 21 (cpu_power = 588) 53 (cpu_power = 588)
  domain 1: span 16-23,48-55 level MC
   groups: 21,53 (cpu_power = 1176) 22,54 (cpu_power = 1176) 23,55 (cpu_power = 1176) 16,48 (cpu_power = 1176) 17,49 (cpu_power = 1176) 18,50 (cpu_power = 1176) 19,51 (cpu_power = 1176) 20,52 (cpu_power = 1176)
   domain 2: span 0-7,16-39,48-63 level NUMA
    groups: 16-23,48-55 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU22 attaching sched-domain:
 domain 0: span 22,54 level SIBLING
  groups: 22 (cpu_power = 588) 54 (cpu_power = 588)
  domain 1: span 16-23,48-55 level MC
   groups: 22,54 (cpu_power = 1176) 23,55 (cpu_power = 1176) 16,48 (cpu_power = 1176) 17,49 (cpu_power = 1176) 18,50 (cpu_power = 1176) 19,51 (cpu_power = 1176) 20,52 (cpu_power = 1176) 21,53 (cpu_power = 1176)
   domain 2: span 0-7,16-39,48-63 level NUMA
    groups: 16-23,48-55 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU23 attaching sched-domain:
 domain 0: span 23,55 level SIBLING
  groups: 23 (cpu_power = 588) 55 (cpu_power = 588)
  domain 1: span 16-23,48-55 level MC
   groups: 23,55 (cpu_power = 1176) 16,48 (cpu_power = 1176) 17,49 (cpu_power = 1176) 18,50 (cpu_power = 1176) 19,51 (cpu_power = 1176) 20,52 (cpu_power = 1176) 21,53 (cpu_power = 1176) 22,54 (cpu_power = 1176)
   domain 2: span 0-7,16-39,48-63 level NUMA
    groups: 16-23,48-55 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU24 attaching sched-domain:
 domain 0: span 24,56 level SIBLING
  groups: 24 (cpu_power = 588) 56 (cpu_power = 588)
  domain 1: span 24-31,56-63 level MC
   groups: 24,56 (cpu_power = 1176) 25,57 (cpu_power = 1176) 26,58 (cpu_power = 1176) 27,59 (cpu_power = 1176) 28,60 (cpu_power = 1176) 29,61 (cpu_power = 1176) 30,62 (cpu_power = 1176) 31,63 (cpu_power = 1176)
   domain 2: span 8-31,40-63 level NUMA
    groups: 24-31,56-63 (cpu_power = 9408) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 8-31,40-63 (cpu_power = 28224) 0-23,32-55 (cpu_power = 28236)
CPU25 attaching sched-domain:
 domain 0: span 25,57 level SIBLING
  groups: 25 (cpu_power = 588) 57 (cpu_power = 588)
  domain 1: span 24-31,56-63 level MC
   groups: 25,57 (cpu_power = 1176) 26,58 (cpu_power = 1176) 27,59 (cpu_power = 1176) 28,60 (cpu_power = 1176) 29,61 (cpu_power = 1176) 30,62 (cpu_power = 1176) 31,63 (cpu_power = 1176) 24,56 (cpu_power = 1176)
   domain 2: span 8-31,40-63 level NUMA
    groups: 24-31,56-63 (cpu_power = 9408) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 8-31,40-63 (cpu_power = 28224) 0-23,32-55 (cpu_power = 28236)
CPU26 attaching sched-domain:
 domain 0: span 26,58 level SIBLING
  groups: 26 (cpu_power = 588) 58 (cpu_power = 588)
  domain 1: span 24-31,56-63 level MC
   groups: 26,58 (cpu_power = 1176) 27,59 (cpu_power = 1176) 28,60 (cpu_power = 1176) 29,61 (cpu_power = 1176) 30,62 (cpu_power = 1176) 31,63 (cpu_power = 1176) 24,56 (cpu_power = 1176) 25,57 (cpu_power = 1176)
   domain 2: span 8-31,40-63 level NUMA
    groups: 24-31,56-63 (cpu_power = 9408) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 8-31,40-63 (cpu_power = 28224) 0-23,32-55 (cpu_power = 28236)
CPU27 attaching sched-domain:
 domain 0: span 27,59 level SIBLING
  groups: 27 (cpu_power = 588) 59 (cpu_power = 588)
  domain 1: span 24-31,56-63 level MC
   groups: 27,59 (cpu_power = 1176) 28,60 (cpu_power = 1176) 29,61 (cpu_power = 1176) 30,62 (cpu_power = 1176) 31,63 (cpu_power = 1176) 24,56 (cpu_power = 1176) 25,57 (cpu_power = 1176) 26,58 (cpu_power = 1176)
   domain 2: span 8-31,40-63 level NUMA
    groups: 24-31,56-63 (cpu_power = 9408) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 8-31,40-63 (cpu_power = 28224) 0-23,32-55 (cpu_power = 28236)
CPU28 attaching sched-domain:
 domain 0: span 28,60 level SIBLING
  groups: 28 (cpu_power = 588) 60 (cpu_power = 588)
  domain 1: span 24-31,56-63 level MC
   groups: 28,60 (cpu_power = 1176) 29,61 (cpu_power = 1176) 30,62 (cpu_power = 1176) 31,63 (cpu_power = 1176) 24,56 (cpu_power = 1176) 25,57 (cpu_power = 1176) 26,58 (cpu_power = 1176) 27,59 (cpu_power = 1176)
   domain 2: span 8-31,40-63 level NUMA
    groups: 24-31,56-63 (cpu_power = 9408) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 8-31,40-63 (cpu_power = 28224) 0-23,32-55 (cpu_power = 28236)
CPU29 attaching sched-domain:
 domain 0: span 29,61 level SIBLING
  groups: 29 (cpu_power = 588) 61 (cpu_power = 588)
  domain 1: span 24-31,56-63 level MC
   groups: 29,61 (cpu_power = 1176) 30,62 (cpu_power = 1176) 31,63 (cpu_power = 1176) 24,56 (cpu_power = 1176) 25,57 (cpu_power = 1176) 26,58 (cpu_power = 1176) 27,59 (cpu_power = 1176) 28,60 (cpu_power = 1176)
   domain 2: span 8-31,40-63 level NUMA
    groups: 24-31,56-63 (cpu_power = 9408) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 8-31,40-63 (cpu_power = 28224) 0-23,32-55 (cpu_power = 28236)
CPU30 attaching sched-domain:
 domain 0: span 30,62 level SIBLING
  groups: 30 (cpu_power = 588) 62 (cpu_power = 588)
  domain 1: span 24-31,56-63 level MC
   groups: 30,62 (cpu_power = 1176) 31,63 (cpu_power = 1176) 24,56 (cpu_power = 1176) 25,57 (cpu_power = 1176) 26,58 (cpu_power = 1176) 27,59 (cpu_power = 1176) 28,60 (cpu_power = 1176) 29,61 (cpu_power = 1176)
   domain 2: span 8-31,40-63 level NUMA
    groups: 24-31,56-63 (cpu_power = 9408) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 8-31,40-63 (cpu_power = 28224) 0-23,32-55 (cpu_power = 28236)
CPU31 attaching sched-domain:
 domain 0: span 31,63 level SIBLING
  groups: 31 (cpu_power = 588) 63 (cpu_power = 588)
  domain 1: span 24-31,56-63 level MC
   groups: 31,63 (cpu_power = 1176) 24,56 (cpu_power = 1176) 25,57 (cpu_power = 1176) 26,58 (cpu_power = 1176) 27,59 (cpu_power = 1176) 28,60 (cpu_power = 1176) 29,61 (cpu_power = 1176) 30,62 (cpu_power = 1176)
   domain 2: span 8-31,40-63 level NUMA
    groups: 24-31,56-63 (cpu_power = 9408) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 8-31,40-63 (cpu_power = 28224) 0-23,32-55 (cpu_power = 28236)
CPU32 attaching sched-domain:
 domain 0: span 0,32 level SIBLING
  groups: 32 (cpu_power = 588) 0 (cpu_power = 588)
  domain 1: span 0-7,32-39 level MC
   groups: 0,32 (cpu_power = 1176) 1,33 (cpu_power = 1178) 2,34 (cpu_power = 1178) 3,35 (cpu_power = 1178) 4,36 (cpu_power = 1178) 5,37 (cpu_power = 1178) 6,38 (cpu_power = 1178) 7,39 (cpu_power = 1176)
   domain 2: span 0-23,32-55 level NUMA
    groups: 0-7,32-39 (cpu_power = 9420) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU33 attaching sched-domain:
 domain 0: span 1,33 level SIBLING
  groups: 33 (cpu_power = 589) 1 (cpu_power = 589)
  domain 1: span 0-7,32-39 level MC
   groups: 1,33 (cpu_power = 1178) 2,34 (cpu_power = 1178) 3,35 (cpu_power = 1178) 4,36 (cpu_power = 1178) 5,37 (cpu_power = 1178) 6,38 (cpu_power = 1178) 7,39 (cpu_power = 1176) 0,32 (cpu_power = 1176)
   domain 2: span 0-23,32-55 level NUMA
    groups: 0-7,32-39 (cpu_power = 9420) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU34 attaching sched-domain:
 domain 0: span 2,34 level SIBLING
  groups: 34 (cpu_power = 589) 2 (cpu_power = 589)
  domain 1: span 0-7,32-39 level MC
   groups: 2,34 (cpu_power = 1178) 3,35 (cpu_power = 1178) 4,36 (cpu_power = 1178) 5,37 (cpu_power = 1178) 6,38 (cpu_power = 1178) 7,39 (cpu_power = 1176) 0,32 (cpu_power = 1176) 1,33 (cpu_power = 1178)
   domain 2: span 0-23,32-55 level NUMA
    groups: 0-7,32-39 (cpu_power = 9420) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU35 attaching sched-domain:
 domain 0: span 3,35 level SIBLING
  groups: 35 (cpu_power = 589) 3 (cpu_power = 589)
  domain 1: span 0-7,32-39 level MC
   groups: 3,35 (cpu_power = 1178) 4,36 (cpu_power = 1178) 5,37 (cpu_power = 1178) 6,38 (cpu_power = 1178) 7,39 (cpu_power = 1176) 0,32 (cpu_power = 1176) 1,33 (cpu_power = 1178) 2,34 (cpu_power = 1178)
   domain 2: span 0-23,32-55 level NUMA
    groups: 0-7,32-39 (cpu_power = 9420) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU36 attaching sched-domain:
 domain 0: span 4,36 level SIBLING
  groups: 36 (cpu_power = 589) 4 (cpu_power = 589)
  domain 1: span 0-7,32-39 level MC
   groups: 4,36 (cpu_power = 1178) 5,37 (cpu_power = 1178) 6,38 (cpu_power = 1178) 7,39 (cpu_power = 1176) 0,32 (cpu_power = 1176) 1,33 (cpu_power = 1178) 2,34 (cpu_power = 1178) 3,35 (cpu_power = 1178)
   domain 2: span 0-23,32-55 level NUMA
    groups: 0-7,32-39 (cpu_power = 9420) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU37 attaching sched-domain:
 domain 0: span 5,37 level SIBLING
  groups: 37 (cpu_power = 589) 5 (cpu_power = 589)
  domain 1: span 0-7,32-39 level MC
   groups: 5,37 (cpu_power = 1178) 6,38 (cpu_power = 1178) 7,39 (cpu_power = 1176) 0,32 (cpu_power = 1176) 1,33 (cpu_power = 1178) 2,34 (cpu_power = 1178) 3,35 (cpu_power = 1178) 4,36 (cpu_power = 1178)
   domain 2: span 0-23,32-55 level NUMA
    groups: 0-7,32-39 (cpu_power = 9420) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU38 attaching sched-domain:
 domain 0: span 6,38 level SIBLING
  groups: 38 (cpu_power = 589) 6 (cpu_power = 589)
  domain 1: span 0-7,32-39 level MC
   groups: 6,38 (cpu_power = 1178) 7,39 (cpu_power = 1176) 0,32 (cpu_power = 1176) 1,33 (cpu_power = 1178) 2,34 (cpu_power = 1178) 3,35 (cpu_power = 1178) 4,36 (cpu_power = 1178) 5,37 (cpu_power = 1178)
   domain 2: span 0-23,32-55 level NUMA
    groups: 0-7,32-39 (cpu_power = 9420) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU39 attaching sched-domain:
 domain 0: span 7,39 level SIBLING
  groups: 39 (cpu_power = 588) 7 (cpu_power = 588)
  domain 1: span 0-7,32-39 level MC
   groups: 7,39 (cpu_power = 1176) 0,32 (cpu_power = 1176) 1,33 (cpu_power = 1178) 2,34 (cpu_power = 1178) 3,35 (cpu_power = 1178) 4,36 (cpu_power = 1178) 5,37 (cpu_power = 1178) 6,38 (cpu_power = 1178)
   domain 2: span 0-23,32-55 level NUMA
    groups: 0-7,32-39 (cpu_power = 9420) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU40 attaching sched-domain:
 domain 0: span 8,40 level SIBLING
  groups: 40 (cpu_power = 588) 8 (cpu_power = 588)
  domain 1: span 8-15,40-47 level MC
   groups: 8,40 (cpu_power = 1176) 9,41 (cpu_power = 1176) 10,42 (cpu_power = 1176) 11,43 (cpu_power = 1176) 12,44 (cpu_power = 1176) 13,45 (cpu_power = 1176) 14,46 (cpu_power = 1176) 15,47 (cpu_power = 1176)
   domain 2: span 0-15,24-47,56-63 level NUMA
    groups: 8-15,40-47 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU41 attaching sched-domain:
 domain 0: span 9,41 level SIBLING
  groups: 41 (cpu_power = 588) 9 (cpu_power = 588)
  domain 1: span 8-15,40-47 level MC
   groups: 9,41 (cpu_power = 1176) 10,42 (cpu_power = 1176) 11,43 (cpu_power = 1176) 12,44 (cpu_power = 1176) 13,45 (cpu_power = 1176) 14,46 (cpu_power = 1176) 15,47 (cpu_power = 1176) 8,40 (cpu_power = 1176)
   domain 2: span 0-15,24-47,56-63 level NUMA
    groups: 8-15,40-47 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU42 attaching sched-domain:
 domain 0: span 10,42 level SIBLING
  groups: 42 (cpu_power = 588) 10 (cpu_power = 588)
  domain 1: span 8-15,40-47 level MC
   groups: 10,42 (cpu_power = 1176) 11,43 (cpu_power = 1176) 12,44 (cpu_power = 1176) 13,45 (cpu_power = 1176) 14,46 (cpu_power = 1176) 15,47 (cpu_power = 1176) 8,40 (cpu_power = 1176) 9,41 (cpu_power = 1176)
   domain 2: span 0-15,24-47,56-63 level NUMA
    groups: 8-15,40-47 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU43 attaching sched-domain:
 domain 0: span 11,43 level SIBLING
  groups: 43 (cpu_power = 588) 11 (cpu_power = 588)
  domain 1: span 8-15,40-47 level MC
   groups: 11,43 (cpu_power = 1176) 12,44 (cpu_power = 1176) 13,45 (cpu_power = 1176) 14,46 (cpu_power = 1176) 15,47 (cpu_power = 1176) 8,40 (cpu_power = 1176) 9,41 (cpu_power = 1176) 10,42 (cpu_power = 1176)
   domain 2: span 0-15,24-47,56-63 level NUMA
    groups: 8-15,40-47 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU44 attaching sched-domain:
 domain 0: span 12,44 level SIBLING
  groups: 44 (cpu_power = 588) 12 (cpu_power = 588)
  domain 1: span 8-15,40-47 level MC
   groups: 12,44 (cpu_power = 1176) 13,45 (cpu_power = 1176) 14,46 (cpu_power = 1176) 15,47 (cpu_power = 1176) 8,40 (cpu_power = 1176) 9,41 (cpu_power = 1176) 10,42 (cpu_power = 1176) 11,43 (cpu_power = 1176)
   domain 2: span 0-15,24-47,56-63 level NUMA
    groups: 8-15,40-47 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU45 attaching sched-domain:
 domain 0: span 13,45 level SIBLING
  groups: 45 (cpu_power = 588) 13 (cpu_power = 588)
  domain 1: span 8-15,40-47 level MC
   groups: 13,45 (cpu_power = 1176) 14,46 (cpu_power = 1176) 15,47 (cpu_power = 1176) 8,40 (cpu_power = 1176) 9,41 (cpu_power = 1176) 10,42 (cpu_power = 1176) 11,43 (cpu_power = 1176) 12,44 (cpu_power = 1176)
   domain 2: span 0-15,24-47,56-63 level NUMA
    groups: 8-15,40-47 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU46 attaching sched-domain:
 domain 0: span 14,46 level SIBLING
  groups: 46 (cpu_power = 588) 14 (cpu_power = 588)
  domain 1: span 8-15,40-47 level MC
   groups: 14,46 (cpu_power = 1176) 15,47 (cpu_power = 1176) 8,40 (cpu_power = 1176) 9,41 (cpu_power = 1176) 10,42 (cpu_power = 1176) 11,43 (cpu_power = 1176) 12,44 (cpu_power = 1176) 13,45 (cpu_power = 1176)
   domain 2: span 0-15,24-47,56-63 level NUMA
    groups: 8-15,40-47 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU47 attaching sched-domain:
 domain 0: span 15,47 level SIBLING
  groups: 47 (cpu_power = 588) 15 (cpu_power = 588)
  domain 1: span 8-15,40-47 level MC
   groups: 15,47 (cpu_power = 1176) 8,40 (cpu_power = 1176) 9,41 (cpu_power = 1176) 10,42 (cpu_power = 1176) 11,43 (cpu_power = 1176) 12,44 (cpu_power = 1176) 13,45 (cpu_power = 1176) 14,46 (cpu_power = 1176)
   domain 2: span 0-15,24-47,56-63 level NUMA
    groups: 8-15,40-47 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU48 attaching sched-domain:
 domain 0: span 16,48 level SIBLING
  groups: 48 (cpu_power = 588) 16 (cpu_power = 588)
  domain 1: span 16-23,48-55 level MC
   groups: 16,48 (cpu_power = 1176) 17,49 (cpu_power = 1176) 18,50 (cpu_power = 1176) 19,51 (cpu_power = 1176) 20,52 (cpu_power = 1176) 21,53 (cpu_power = 1176) 22,54 (cpu_power = 1176) 23,55 (cpu_power = 1176)
   domain 2: span 0-7,16-39,48-63 level NUMA
    groups: 16-23,48-55 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU49 attaching sched-domain:
 domain 0: span 17,49 level SIBLING
  groups: 49 (cpu_power = 588) 17 (cpu_power = 588)
  domain 1: span 16-23,48-55 level MC
   groups: 17,49 (cpu_power = 1176) 18,50 (cpu_power = 1176) 19,51 (cpu_power = 1176) 20,52 (cpu_power = 1176) 21,53 (cpu_power = 1176) 22,54 (cpu_power = 1176) 23,55 (cpu_power = 1176) 16,48 (cpu_power = 1176)
   domain 2: span 0-7,16-39,48-63 level NUMA
    groups: 16-23,48-55 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU50 attaching sched-domain:
 domain 0: span 18,50 level SIBLING
  groups: 50 (cpu_power = 588) 18 (cpu_power = 588)
  domain 1: span 16-23,48-55 level MC
   groups: 18,50 (cpu_power = 1176) 19,51 (cpu_power = 1176) 20,52 (cpu_power = 1176) 21,53 (cpu_power = 1176) 22,54 (cpu_power = 1176) 23,55 (cpu_power = 1176) 16,48 (cpu_power = 1176) 17,49 (cpu_power = 1176)
   domain 2: span 0-7,16-39,48-63 level NUMA
    groups: 16-23,48-55 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU51 attaching sched-domain:
 domain 0: span 19,51 level SIBLING
  groups: 51 (cpu_power = 588) 19 (cpu_power = 588)
  domain 1: span 16-23,48-55 level MC
   groups: 19,51 (cpu_power = 1176) 20,52 (cpu_power = 1176) 21,53 (cpu_power = 1176) 22,54 (cpu_power = 1176) 23,55 (cpu_power = 1176) 16,48 (cpu_power = 1176) 17,49 (cpu_power = 1176) 18,50 (cpu_power = 1176)
   domain 2: span 0-7,16-39,48-63 level NUMA
    groups: 16-23,48-55 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU52 attaching sched-domain:
 domain 0: span 20,52 level SIBLING
  groups: 52 (cpu_power = 588) 20 (cpu_power = 588)
  domain 1: span 16-23,48-55 level MC
   groups: 20,52 (cpu_power = 1176) 21,53 (cpu_power = 1176) 22,54 (cpu_power = 1176) 23,55 (cpu_power = 1176) 16,48 (cpu_power = 1176) 17,49 (cpu_power = 1176) 18,50 (cpu_power = 1176) 19,51 (cpu_power = 1176)
   domain 2: span 0-7,16-39,48-63 level NUMA
    groups: 16-23,48-55 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU53 attaching sched-domain:
 domain 0: span 21,53 level SIBLING
  groups: 53 (cpu_power = 588) 21 (cpu_power = 588)
  domain 1: span 16-23,48-55 level MC
   groups: 21,53 (cpu_power = 1176) 22,54 (cpu_power = 1176) 23,55 (cpu_power = 1176) 16,48 (cpu_power = 1176) 17,49 (cpu_power = 1176) 18,50 (cpu_power = 1176) 19,51 (cpu_power = 1176) 20,52 (cpu_power = 1176)
   domain 2: span 0-7,16-39,48-63 level NUMA
    groups: 16-23,48-55 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU54 attaching sched-domain:
 domain 0: span 22,54 level SIBLING
  groups: 54 (cpu_power = 588) 22 (cpu_power = 588)
  domain 1: span 16-23,48-55 level MC
   groups: 22,54 (cpu_power = 1176) 23,55 (cpu_power = 1176) 16,48 (cpu_power = 1176) 17,49 (cpu_power = 1176) 18,50 (cpu_power = 1176) 19,51 (cpu_power = 1176) 20,52 (cpu_power = 1176) 21,53 (cpu_power = 1176)
   domain 2: span 0-7,16-39,48-63 level NUMA
    groups: 16-23,48-55 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU55 attaching sched-domain:
 domain 0: span 23,55 level SIBLING
  groups: 55 (cpu_power = 588) 23 (cpu_power = 588)
  domain 1: span 16-23,48-55 level MC
   groups: 23,55 (cpu_power = 1176) 16,48 (cpu_power = 1176) 17,49 (cpu_power = 1176) 18,50 (cpu_power = 1176) 19,51 (cpu_power = 1176) 20,52 (cpu_power = 1176) 21,53 (cpu_power = 1176) 22,54 (cpu_power = 1176)
   domain 2: span 0-7,16-39,48-63 level NUMA
    groups: 16-23,48-55 (cpu_power = 9408) 24-31,56-63 (cpu_power = 9408) 0-7,32-39 (cpu_power = 9420)
    domain 3: span 0-63 level NUMA
     groups: 0-23,32-55 (cpu_power = 28236) 8-31,40-63 (cpu_power = 28224)
CPU56 attaching sched-domain:
 domain 0: span 24,56 level SIBLING
  groups: 56 (cpu_power = 588) 24 (cpu_power = 588)
  domain 1: span 24-31,56-63 level MC
   groups: 24,56 (cpu_power = 1176) 25,57 (cpu_power = 1176) 26,58 (cpu_power = 1176) 27,59 (cpu_power = 1176) 28,60 (cpu_power = 1176) 29,61 (cpu_power = 1176) 30,62 (cpu_power = 1176) 31,63 (cpu_power = 1176)
   domain 2: span 8-31,40-63 level NUMA
    groups: 24-31,56-63 (cpu_power = 9408) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 8-31,40-63 (cpu_power = 28224) 0-23,32-55 (cpu_power = 28236)
CPU57 attaching sched-domain:
 domain 0: span 25,57 level SIBLING
  groups: 57 (cpu_power = 588) 25 (cpu_power = 588)
  domain 1: span 24-31,56-63 level MC
   groups: 25,57 (cpu_power = 1176) 26,58 (cpu_power = 1176) 27,59 (cpu_power = 1176) 28,60 (cpu_power = 1176) 29,61 (cpu_power = 1176) 30,62 (cpu_power = 1176) 31,63 (cpu_power = 1176) 24,56 (cpu_power = 1176)
   domain 2: span 8-31,40-63 level NUMA
    groups: 24-31,56-63 (cpu_power = 9408) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 8-31,40-63 (cpu_power = 28224) 0-23,32-55 (cpu_power = 28236)
CPU58 attaching sched-domain:
 domain 0: span 26,58 level SIBLING
  groups: 58 (cpu_power = 588) 26 (cpu_power = 588)
  domain 1: span 24-31,56-63 level MC
   groups: 26,58 (cpu_power = 1176) 27,59 (cpu_power = 1176) 28,60 (cpu_power = 1176) 29,61 (cpu_power = 1176) 30,62 (cpu_power = 1176) 31,63 (cpu_power = 1176) 24,56 (cpu_power = 1176) 25,57 (cpu_power = 1176)
   domain 2: span 8-31,40-63 level NUMA
    groups: 24-31,56-63 (cpu_power = 9408) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 8-31,40-63 (cpu_power = 28224) 0-23,32-55 (cpu_power = 28236)
CPU59 attaching sched-domain:
 domain 0: span 27,59 level SIBLING
  groups: 59 (cpu_power = 588) 27 (cpu_power = 588)
  domain 1: span 24-31,56-63 level MC
   groups: 27,59 (cpu_power = 1176) 28,60 (cpu_power = 1176) 29,61 (cpu_power = 1176) 30,62 (cpu_power = 1176) 31,63 (cpu_power = 1176) 24,56 (cpu_power = 1176) 25,57 (cpu_power = 1176) 26,58 (cpu_power = 1176)
   domain 2: span 8-31,40-63 level NUMA
    groups: 24-31,56-63 (cpu_power = 9408) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 8-31,40-63 (cpu_power = 28224) 0-23,32-55 (cpu_power = 28236)
CPU60 attaching sched-domain:
 domain 0: span 28,60 level SIBLING
  groups: 60 (cpu_power = 588) 28 (cpu_power = 588)
  domain 1: span 24-31,56-63 level MC
   groups: 28,60 (cpu_power = 1176) 29,61 (cpu_power = 1176) 30,62 (cpu_power = 1176) 31,63 (cpu_power = 1176) 24,56 (cpu_power = 1176) 25,57 (cpu_power = 1176) 26,58 (cpu_power = 1176) 27,59 (cpu_power = 1176)
   domain 2: span 8-31,40-63 level NUMA
    groups: 24-31,56-63 (cpu_power = 9408) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 8-31,40-63 (cpu_power = 28224) 0-23,32-55 (cpu_power = 28236)
CPU61 attaching sched-domain:
 domain 0: span 29,61 level SIBLING
  groups: 61 (cpu_power = 588) 29 (cpu_power = 588)
  domain 1: span 24-31,56-63 level MC
   groups: 29,61 (cpu_power = 1176) 30,62 (cpu_power = 1176) 31,63 (cpu_power = 1176) 24,56 (cpu_power = 1176) 25,57 (cpu_power = 1176) 26,58 (cpu_power = 1176) 27,59 (cpu_power = 1176) 28,60 (cpu_power = 1176)
   domain 2: span 8-31,40-63 level NUMA
    groups: 24-31,56-63 (cpu_power = 9408) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 8-31,40-63 (cpu_power = 28224) 0-23,32-55 (cpu_power = 28236)
CPU62 attaching sched-domain:
 domain 0: span 30,62 level SIBLING
  groups: 62 (cpu_power = 588) 30 (cpu_power = 588)
  domain 1: span 24-31,56-63 level MC
   groups: 30,62 (cpu_power = 1176) 31,63 (cpu_power = 1176) 24,56 (cpu_power = 1176) 25,57 (cpu_power = 1176) 26,58 (cpu_power = 1176) 27,59 (cpu_power = 1176) 28,60 (cpu_power = 1176) 29,61 (cpu_power = 1176)
   domain 2: span 8-31,40-63 level NUMA
    groups: 24-31,56-63 (cpu_power = 9408) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 8-31,40-63 (cpu_power = 28224) 0-23,32-55 (cpu_power = 28236)
CPU63 attaching sched-domain:
 domain 0: span 31,63 level SIBLING
  groups: 63 (cpu_power = 588) 31 (cpu_power = 588)
  domain 1: span 24-31,56-63 level MC
   groups: 31,63 (cpu_power = 1176) 24,56 (cpu_power = 1176) 25,57 (cpu_power = 1176) 26,58 (cpu_power = 1176) 27,59 (cpu_power = 1176) 28,60 (cpu_power = 1176) 29,61 (cpu_power = 1176) 30,62 (cpu_power = 1176)
   domain 2: span 8-31,40-63 level NUMA
    groups: 24-31,56-63 (cpu_power = 9408) 8-15,40-47 (cpu_power = 9408) 16-23,48-55 (cpu_power = 9408)
    domain 3: span 0-63 level NUMA
     groups: 8-31,40-63 (cpu_power = 28224) 0-23,32-55 (cpu_power = 28236)
-- 
Thanks and Regards
Srikar Dronamraju

