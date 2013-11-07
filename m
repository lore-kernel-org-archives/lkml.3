Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3KGXq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 18:46:59 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:36482 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab3KGXqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 18:46:51 -0500
Date: Fri, 8 Nov 2013 00:46:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 3/4] printk: Defer printing to irq work when we printed
 too much
Message-ID: <20131107234647.GG28130@localhost.localdomain>
References: <1383860919-1883-1-git-send-email-jack@suse.cz>
 <1383860919-1883-4-git-send-email-jack@suse.cz>
 <CAFTL4hw6wO+3Y8EpW3_swodfyV9UAaLF-KE6KC+u-5sKjKY7eA@mail.gmail.com>
 <20131107225733.GE2054@quack.suse.cz>
 <20131107232148.GE28130@localhost.localdomain>
 <20131107183717.0fc9eb6e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107183717.0fc9eb6e@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 06:37:17PM -0500, Steven Rostedt wrote:
> On Fri, 8 Nov 2013 00:21:51 +0100
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > Offloading to a workqueue would be perhaps better, and writing to the serial
> > console could then be done with interrupts enabled, preemptible context, etc...
> 
> Oh God no ;-)  Adding workqueue logic into printk just spells a
> nightmare of much more complexity for a critical kernel infrastructure.

But yeah that's scary, that means workqueues itself can't printk that safely.
So, you're right after all.
