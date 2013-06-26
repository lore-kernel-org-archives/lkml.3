Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab3FZFYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 01:24:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab3FZFYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 01:24:09 -0400
Date: Wed, 26 Jun 2013 01:23:52 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130626052352.GB31416@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrey Vagin <avagin@openvz.org>
References: <20130622013731.GA22918@redhat.com>
 <20130622173129.GA29375@redhat.com>
 <20130622215905.GA28238@redhat.com>
 <20130623143634.GA2000@redhat.com>
 <20130623150603.GA32313@redhat.com>
 <20130623160452.GA11740@redhat.com>
 <20130624155758.GA5993@redhat.com>
 <20130624173510.GA1321@redhat.com>
 <20130625153520.GA7784@redhat.com>
 <1372177414.18733.211.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372177414.18733.211.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 12:23:34PM -0400, Steven Rostedt wrote:

 > Now, what we can try to do as well, is to add a trigger to disable
 > tracing, which should (I need to check the code) stop tracing on printk.
 > To do so:
 > 
 > # echo printk:traceoff > /sys/kernel/debug/tracing/set_ftrace_filter
 > 
 > This will add a trigger to the printk function that when called, will
 > disable tracing. If it is hit before you get your trace, you can just
 > re-enable tracing with:
 > 
 > # echo 1 > /sys/kernel/debug/tracing/tracing_on
 > 
 > Hmm, no it needs a fix to make this work. I applied a patch below that
 > should do this correctly (and will put this into my 3.11 queue).
 > 
 > If you run the test again with this change and with the above filter, it
 > should stop the trace before overwriting the first dump, as it should
 > ignore the printk output.

I think something isn't right with this patch.
After 10 hours, I hit the bug again, but...

(01:21:28:root@binary:tracing)# cat trace
# tracer: preemptirqsoff
#
(01:21:30:root@binary:tracing)# 

	Dave

