Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab3FZTwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:52:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9509 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab3FZTwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:52:17 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=XqNnylozy48A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pkicDPhlfI0A:10 a=PPorpS72le2Tx5LNLKMA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372276335.18733.271.camel@gandalf.local.home>
Subject: Re: frequent softlockups with 3.10rc6.
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Date: Wed, 26 Jun 2013 15:52:15 -0400
In-Reply-To: <20130626052352.GB31416@redhat.com>
References: <20130622013731.GA22918@redhat.com>
	 <20130622173129.GA29375@redhat.com> <20130622215905.GA28238@redhat.com>
	 <20130623143634.GA2000@redhat.com> <20130623150603.GA32313@redhat.com>
	 <20130623160452.GA11740@redhat.com> <20130624155758.GA5993@redhat.com>
	 <20130624173510.GA1321@redhat.com> <20130625153520.GA7784@redhat.com>
	 <1372177414.18733.211.camel@gandalf.local.home>
	 <20130626052352.GB31416@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 01:23 -0400, Dave Jones wrote:
> On Tue, Jun 25, 2013 at 12:23:34PM -0400, Steven Rostedt wrote:
> 
>  > Now, what we can try to do as well, is to add a trigger to disable
>  > tracing, which should (I need to check the code) stop tracing on printk.
>  > To do so:
>  > 
>  > # echo printk:traceoff > /sys/kernel/debug/tracing/set_ftrace_filter
>  > 
>  > This will add a trigger to the printk function that when called, will
>  > disable tracing. If it is hit before you get your trace, you can just
>  > re-enable tracing with:
>  > 
>  > # echo 1 > /sys/kernel/debug/tracing/tracing_on
>  > 
>  > Hmm, no it needs a fix to make this work. I applied a patch below that
>  > should do this correctly (and will put this into my 3.11 queue).
>  > 
>  > If you run the test again with this change and with the above filter, it
>  > should stop the trace before overwriting the first dump, as it should
>  > ignore the printk output.
> 
> I think something isn't right with this patch.
> After 10 hours, I hit the bug again, but...
> 
> (01:21:28:root@binary:tracing)# cat trace
> # tracer: preemptirqsoff
> #
> (01:21:30:root@binary:tracing)# 
> 

Did you apply the patch I added to my last email. It should have prevent
that form happening :-/

-- Steve


