Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab3GPBKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 21:10:34 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:48804 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab3GPBKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 21:10:33 -0400
Date: Tue, 16 Jul 2013 03:10:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nohz: Warn if the machine can not perform nohz_full
Message-ID: <20130716011028.GE13562@somewhere>
References: <20130715170859.GA25570@redhat.com>
 <20130715171800.GD6442@somewhere>
 <20130715172423.GA27745@redhat.com>
 <20130715173848.GA1066@redhat.com>
 <1373914182.17876.165.camel@gandalf.local.home>
 <20130715185624.GB1706@redhat.com>
 <1373916620.17876.182.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373916620.17876.182.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 03:30:20PM -0400, Steven Rostedt wrote:
> On Mon, 2013-07-15 at 14:56 -0400, Dave Jones wrote:
> > On Mon, Jul 15, 2013 at 02:49:42PM -0400, Steven Rostedt wrote:
> >  
> > Is a printk not enough for that purpose ? Tainting the kernel is kinda anti-social.
> > 
> 
> printk's don't usually get peoples attention. Taints and warnings do. If
> the hardware doesn't allow for nohz-full, and the only way to enable it
> is via kernel command line, how do you scream to the user that it isn't
> going to work.
> 
> We could do a large banner saying:
> 
> ***************************************************************
> ***************************************************************
> ***************************************************************
> ***************************************************************
> ***                    UNSTABLE TSC                         ***
> ***                NO_HZ_FULL disabled                      ***
> ***************************************************************
> ***************************************************************
> ***************************************************************
> ***************************************************************

May be we can try that. In fact I have a pending patch that converts the
stacktrace warning to a one line printk message, as Ingo reported that issue
to me. But the risk is that it can be indeed lost in the flow.

> 
> 
> And not do the warning. Maybe that will get peoples attentions?
> 
> But then again, this could be lost in the boot up if the box prints a
> lot of data.

Well the above example is unlikely to be missed. If it is, then I believe a
traditional warning would be lost as well.

> 
> -- Steve
> 
> 
