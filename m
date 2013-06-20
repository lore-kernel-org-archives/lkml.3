Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030419Ab3FTWUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 18:20:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10525 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043Ab3FTWUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 18:20:50 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=CP4Tl-rxqdAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=9d5NqswhC6UA:10 a=8DIfM-bG0CoPEQikIXgA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371766847.18733.109.camel@gandalf.local.home>
Subject: Re: [PATCH 0/3] tracing/perf: perf_trace_buf/perf_xxx hacks.
From: Steven Rostedt <rostedt@goodmis.org>
To: David Ahern <dsahern@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Jun 2013 18:20:47 -0400
In-Reply-To: <1371754391.18733.107.camel@gandalf.local.home>
References: <20130618192147.GA19443@redhat.com>
	 <20130619121039.GA19225@twins.programming.kicks-ass.net>
	 <20130619152844.GA9176@redhat.com> <20130619175139.GA20454@redhat.com>
	 <51C1FD7F.9090606@gmail.com> <20130619195822.GA16489@redhat.com>
	 <1371752633.18733.96.camel@gandalf.local.home> <51C34B70.60808@gmail.com>
	 <1371754078.18733.106.camel@gandalf.local.home>
	 <1371754391.18733.107.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 14:53 -0400, Steven Rostedt wrote:

> Oh wait, I just noticed Oleg's:
> 
> # perf record -e sched:sched_switch -p1 &
> 
> I missed that.
> 
> bah, time to re-run it.
> 


New update, after running with the above command:

[root@ixf ~]# cat perf-bench-sched.before.2 | tail -20
     Total time: 11.833 [sec]

      11.833804 usecs/op
          84503 ops/sec

 Performance counter stats for process id '1' (100 runs):

     <not counted> task-clock              
     <not counted> context-switches        
     <not counted> cpu-migrations          
     <not counted> page-faults             
     <not counted> cycles                  
   <not supported> stalled-cycles-frontend 
   <not supported> stalled-cycles-backend  
     <not counted> instructions            
     <not counted> branches                
     <not counted> branch-misses           

      11.955755673 seconds time elapsed
( +-  0.05% )

[root@ixf ~]# cat perf-bench-sched.after-2 | tail -20
     Total time: 11.490 [sec]

      11.490764 usecs/op
          87026 ops/sec

 Performance counter stats for process id '1' (100 runs):

     <not counted> task-clock              
     <not counted> context-switches        
     <not counted> cpu-migrations          
     <not counted> page-faults             
     <not counted> cycles                  
   <not supported> stalled-cycles-frontend 
   <not supported> stalled-cycles-backend  
     <not counted> instructions            
     <not counted> branches                
     <not counted> branch-misses           

      11.511847099 seconds time elapsed
( +-  0.05% )


OK, this does give us a slight improvement. Approximately 4%.

-- Steve


