Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab3GBXCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 19:02:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31482 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab3GBXCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 19:02:16 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=GaZmXyA2r7EA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=rR01McGDyKUA:10 a=SLhm9TOZdI-xopj2L0sA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372806135.22688.71.camel@gandalf.local.home>
Subject: Re: Re: [PATCH] tracing/kprobe: Recover old array if fails to
 enable kprobe
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>
Date: Tue, 02 Jul 2013 19:02:15 -0400
In-Reply-To: <51CFE255.6050003@hitachi.com>
References: <51CD25A6.2030907@hitachi.com>
	 <20130628130452.1132.85665.stgit@mhiramat-M0-7522>
	 <20130628142744.GA19278@redhat.com>
	 <1372430586.18733.332.camel@gandalf.local.home>
	 <20130628184325.GA21822@redhat.com> <51CFE255.6050003@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-06-30 at 16:46 +0900, Masami Hiramatsu wrote:
> (2013/06/29 3:43), Oleg Nesterov wrote:
> > On 06/28, Steven Rostedt wrote:
> >>
> >> On Fri, 2013-06-28 at 16:27 +0200, Oleg Nesterov wrote:
> >>>
> >>> Ah, but this conflicts with the other changes I sent. They have
> >>> your acks, and iiuc Steven is going to apply them.
> >>
> >> I'll see if I can solve any conflicts. I need to get my -rt versions out
> >> and start on the new 3.6 stable today. Then after that, I plan on going
> >> though and getting all the tracing patches settled.
> > 
> > Thanks!
> > 
> >>> Besides, this fix is not complete afaics, we should also clear
> >>> TP_FLAG_TRACE/PROFILE if __enable_trace_probe() fails.
> > 
> > Yes.
> > 
> > And I forgot to mention, until we fix the races we discuss in another
> > thread, this WARN_ON() doesn't look right. So perhaps it would be
> > really better to delay this change a bit.
> 
> Agreed, this fix is not a critical one. The racing problem of
> dynamic events is what we have to solve at first.
> 

Do you want to reapply this on top of my current for-next branch? Or can
this wait?

Thanks,

-- Steve


