Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935046AbaKNDvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 22:51:42 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:14642 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934473AbaKNDvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 22:51:41 -0500
Date: Thu, 13 Nov 2014 22:51:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: Pranith Kumar <bobby.prani@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.cz>, Jan Kara <jack@suse.cz>,
        "Luis R. Rodriguez" <mcgrof@suse.com>, Alex Elder <elder@linaro.org>,
        open list <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com
Subject: Re: [RFC PATCH] printk: Use ACCESS_ONCE() instead of a volatile
 type
Message-ID: <20141113225128.3568bae6@gandalf.local.home>
In-Reply-To: <1415936460.5912.1.camel@perches.com>
References: <1415935283-19198-1-git-send-email-bobby.prani@gmail.com>
	<1415936460.5912.1.camel@perches.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014 19:41:00 -0800
Joe Perches <joe@perches.com> wrote:

> On Thu, 2014-11-13 at 22:21 -0500, Pranith Kumar wrote:
> > Remove volatile type qualifier and use ACCESS_ONCE() in its place for each
> > access. Using volatile is not recommended as documented in
> > Documentation/volatile-considered-harmful.txt.
> > 
> > Here logbuf_cpu is a local variable and it is not clear how it is being accessed
> > concurrently. We should remove volatile accesses entirely here, but for now make
> > a safer change of using ACCESS_ONCE().
> 
> Not recommended does not mean "don't ever use".

I would argue that the use of volatile in open code is evil and prone
to bugs. I agree that this is one of the few occasions that this is not
the case.

> 
> Forcing the volatile at each use site instead
> of the declaration isn't necessarily better.
> 
> I think the code is more readable as-is but I'm
> not going to object if Andrew picks this up...
> 

The ACCESS_ONCE() calls at each location makes it a bit uglier, but it
drives in the point of what that is doing. Where as the volatile may be
missed.

-- Steve

