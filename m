Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234Ab3ECPbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:31:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12419 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433Ab3ECPbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:31:04 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=0PU5dpyy9WsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=WXPJDuwjcIAA:10 a=e1Hpgnye-29UXAIrDqEA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367595062.7373.18.camel@gandalf.local.home>
Subject: Re: Suspend resume problem (WAS Re: [ANNOUNCE] 3.8.10-rt6)
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Clark Williams <williams@redhat.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 03 May 2013 11:31:02 -0400
In-Reply-To: <51838A84.90500@linutronix.de>
References: <20130429201202.GB7979@linutronix.de>
	  <20130429161925.2a6ea78a@riff.lan> <20130430170948.GB4688@linutronix.de>
	 <1367345295.30667.68.camel@gandalf.local.home>
	 <51838A84.90500@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-03 at 11:59 +0200, Sebastian Andrzej Siewior wrote:
>  
> > As the NMI dump only happens because of the time jump, which as you
> > said, is -rt only, I wouldn't say that the NMI deadlock is a mainline
> > bug.
> 
> The reason for the NMI was a bug in the -RT tree but if something else
> triggers that NMI we have a good chance to deadlock.

But only if the NMI does a printk(). The only reason NMIs do printks is
when a bug is detected. But usually oops_in_progress() is called and
also zap_locks() is suppose to help prevent these problems. But that
doesn't always work.

> 
> What about a try_lock() and leave after 50 usecs of trying and not
> getting it in the in_nmi() case?

I wouldn't try too hard to fix printks for NMIs. There's many things
that can go wrong with NMIs doing a printk while another printk is
active.

-- Steve


