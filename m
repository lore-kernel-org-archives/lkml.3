Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbaCEVeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:34:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbaCEVeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:34:04 -0500
Date: Wed, 5 Mar 2014 13:34:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 05/48] percpu: Add preemption checks to __this_cpu ops
Message-Id: <20140305133401.31a3d5f45edf2a97d5a5b5c0@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.10.1403042125060.3742@nuc>
References: <20140214201841.826179349@linux.com>
	<20140214201904.443470635@linux.com>
	<20140304142727.3e6d260c752c2e2ebd49260e@linux-foundation.org>
	<alpine.DEB.2.10.1403042125060.3742@nuc>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2014 21:27:14 -0600 (CST) Christoph Lameter <cl@linux.com> wrote:

> > > +notrace void __this_cpu_preempt_check(const char *op)
> > > +{
> > > +	char text[40];
> > > +
> > > +	snprintf(text, sizeof(text), "__this_cpu_%s()", op);
> > > +	check_preemption_disabled(text);
> > > +}
> >
> > I'd like to see a comment here telling scared readers why this can
> > never overflow text[].
> 
> Ok. I can also add VM_BUG_ON(strlen(op) >= sizeof(text)) ?

I misread the code - snprintf() will dtrt and we'll just end up with
truncated debug text.  Not worth worrying about.
