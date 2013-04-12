Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab3DLNoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 09:44:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18473 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab3DLNoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 09:44:17 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=P6hlpVgoKeYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=ayLHJbDuenQA:10 a=EGXMQeyfTzD_Iz5F8w4A:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365774255.9609.82.camel@gandalf.local.home>
Subject: Re: [PATCH RT v2] x86/mce: Defer mce wakeups to threads for
 PREEMPT_RT
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, John Kacur <jkacur@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 12 Apr 2013 09:44:15 -0400
In-Reply-To: <20130412133846.GD2368@pd.tnic>
References: <1365705214.9609.58.camel@gandalf.local.home>
	 <20130412133846.GD2368@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-12 at 15:38 +0200, Borislav Petkov wrote:

> > +static void __mce_notify_work(void)
> > +{
> > +	/* Not more than two messages every minute */
> > +	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
> > +
> > +	/* wake processes polling /dev/mcelog */
> > +	wake_up_interruptible(&mce_chrdev_wait);
> > +
> > +	/*
> > +	 * There is no risk of missing notifications because
> > +	 * work_pending is always cleared before the function is
> > +	 * executed.
> > +	 */
> 
> You must be using some tree != mainline because this comment is gone
> upstream and that whole second hunk below which moves it here doesn't
> apply.
> 

I forgot to state that I based this off of 3.6-rt, and will be
backporting it to 3.0-rt as that's the kernel that the bug was reported
on. But the problem still exists in mainline as well (for -rt).

-- Steve


