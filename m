Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab3HON0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 09:26:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14296 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070Ab3HON0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 09:26:49 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=1X_fbBvAaXUA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=u2N__WHdo-IA:10 a=oV8Yik5rzFehdB6E-UMA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Thu, 15 Aug 2013 09:26:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, mhocko@suse.cz
Subject: Re: [PATCH 3/4] printk: Defer printing to irq work when we printed
 too much
Message-ID: <20130815092647.55b0614a@gandalf.local.home>
In-Reply-To: <20130815075251.GB2147@quack.suse.cz>
References: <1376486908-26063-1-git-send-email-jack@suse.cz>
	<1376486908-26063-4-git-send-email-jack@suse.cz>
	<20130814213818.34b3a11e@gandalf.local.home>
	<20130815075251.GB2147@quack.suse.cz>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Aug 2013 09:52:51 +0200
Jan Kara <jack@suse.cz> wrote:

 
> > > +/*
> > > + * How much characters can we print in one call of printk before offloading
> > > + * printing work
> > > + */
> > > +#define MAX_PRINTK_CHARS 1000
> > 
> > This really needs to be configurable. 1000 may be good for you, but may
> > not be good for others. Heck, we should be able to disable this
> > offloading too.
> > 
> > This should probably be added to the printk /proc/sys/kernel/... files.
> > 
> > If it is set to zero, then disable any offloading.
>   OK, I can easily do this. I'm somewhat skeptical people would want to
> tune this but maybe they would.
> 

Most people wouldn't. But as this is a new heuristic, if things are not
behaving as people expect, then it would be good to be able to modify
that heuristic to see if that was the issue. Including, disabling it.

-- Steve
