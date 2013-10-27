Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab3J0QMk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 12:12:40 -0400
Received: from know-smtprelay-omc-11.server.virginmedia.net ([80.0.253.75]:49649
	"EHLO know-smtprelay-omc-11.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497Ab3J0QMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 12:12:39 -0400
X-Originating-IP: [81.99.114.138]
X-Spam: 0
X-Authority: v=2.0 cv=D70fsYtj c=1 sm=1 a=rTb9Q+mClrhkGV9Ah9iRIA==:17
 a=jlPsK6Yxj2MA:10 a=IkcTkHD0fZMA:10 a=xqWC_Br6kY4A:10 a=xq3W2uTSAAAA:8
 a=N1CowNylAAAA:8 a=7NqCWP14w4AA:10 a=GW-m_OFFJhGzqacPKksA:9 a=QEXdDO2ut3YA:10
 a=wTsYZljDQnEA:10 a=rTb9Q+mClrhkGV9Ah9iRIA==:117
Message-ID: <1382893938.2598.24.camel@artifact>
Subject: Re: [PATCH] staging: Merge Crystal HD driver with linuxtv.org
From: Steven Newbury <steve@snewbury.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Naren Sankar <nsankar@broadcom.com>,
        Jarod Wilson <jarod@wilsonet.com>, Scott Davilla <davilla@4pi.com>,
        Manu Abraham <abraham.manu@gmail.com>
Date: Sun, 27 Oct 2013 17:12:18 +0000
In-Reply-To: <20131027155408.GA22705@kroah.com>
References: <1382891243.2598.10.camel@artifact>
	 <20131027155408.GA22705@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-10-27 at 08:54 -0700, Greg KH wrote:
> On Sun, Oct 27, 2013 at 04:27:23PM +0000, Steven Newbury wrote:
> > The in-kernel staging version and upstream diverged in Jan 2010,
> > whilst the in-kernel version has been kept up to date with kernel
> > changes, both have recieved some clean ups and bug fixes, upstream
> > has also added support for new cards, particularly BCM70015 which
> > is now a much more common device than the original BCM70012 and
> > is currently available for purchase.
> > 
> > In addition to the changes below, I've applied all the relevant
> > modifications applied to the in-kernel version to the new code
> > introduced from upstream, in particular the removal of typedefs and
> > unified header handling.
> > 
> > Quite a lot of the code churn relates to upstream commit
> > 317dbd6dda65b4177627d6417b762c287cefa0e7 (crystalhd: nuke BCMLOG
> > macros, use std dev_foo ones), I considered stripping these changes
> > out and making them a separate patch but decided to stay as close as
> > possible to the state of the current linuxtv.org codebase.
> > 
> > Unfortunately, AFAIK, it's not possible to simply merge the upstream
> > git history since the upstream code isn't in a kernel tree structure,
> > and isn't even in a simple directory, but includes a script to
> > convert the external module into a staging tree driver which I used
> > to create a reference tree.  I had to then manually merge both
> > versions and fix code conflicts.
> > 
> > It does now successfully detect and initialise a BCM70015 bought
> > last week from Amazon.  It is currently untested on the original
> > BCM70012.
> > 
> > Signed-off-by: Steven Newbury <steve@snewbury.org.uk>
> 
> Any reason why you didn't send this to me, the staging tree maintainer?
> 
My apologies, that was remiss of me.
> And I can't take a giant patch like this, it's a mess.  Why not send me
> a series of patches that sync things up, like you detail in the odd
> changelog entries you show below?
TBH, I just hoped I'd get away with fixing the thing up and posting it.
I bought the hardware last week assuming it would work since the driver
has been hanging around in the kernel for years, only to realise that
there is *no* working driver for the current cards on the market, at
least with recent kernel releases.  (The linuxtv.org driver seems to
have stopped being updated.) 

So I spent the weekend getting it working for me, and rather than leave
it sitting in my local machine with far too many other patches for way
too many projects, I sent it here. :-)  

But, you're right, I've only done half the job, and I knew it as I wrote
the email. :-/  I'll start breaking it up into separate patches.

> 
> And these patches do a lot of new work to the driver, I'd rather see it
> get fixed up properly and moved out of staging first, before adding new
> support to it, otherwise why is it in staging at all?

That last part it a good question, it's been sitting there for 3 years,
I assume there are specific things that need improving to get it out of
staging?  Would the changes in this patch, without the support for new
hw support be sufficient to get that to happen?  I can't test it without
that support though...




