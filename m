Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaIEWIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:08:35 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64144 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaIEWIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:08:32 -0400
Date: Fri, 5 Sep 2014 15:08:28 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Francis Moreau <francis.moro@gmail.com>, stable@vger.kernel.org,
        linux-pm@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 3.10.y+] PM / sleep: Use valid_state() for
 platform-dependent sleep states only
Message-ID: <20140905220828.GE18411@ld-irv-0074>
References: <1849024.CHOUso6H2K@vostro.rjw.lan>
 <1409865665-5375-1-git-send-email-computersforpeace@gmail.com>
 <54095835.7000207@gmail.com>
 <20140905074512.GA12218@brian-ubuntu>
 <20140905214758.GC30221@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905214758.GC30221@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 02:47:58PM -0700, Greg Kroah-Hartman wrote:
> On Fri, Sep 05, 2014 at 12:45:12AM -0700, Brian Norris wrote:
> > On Fri, Sep 05, 2014 at 08:29:09AM +0200, Francis Moreau wrote:
> > > On 09/04/2014 11:21 PM, Brian Norris wrote:
> > [...]
> > > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > Cc: <stable@vger.kernel.org> # 3.10+: 27ddcc6596e5: PM / sleep: Add state field to pm_states[] entries
> > > > Cc: <stable@vger.kernel.org> # 3.10+
> > > > ---
> > > > This is a backport request for these two commits upstream:
> > > > 
> > > >     27ddcc6596e5 PM / sleep: Add state field to pm_states[] entries
> > > >     43e8317b0bba PM / sleep: Use valid_state() for platform-dependent sleep states only
> > > > 
> > > 
> > > Wouldn't it be cleaner to have 2 separate backports then ?
> > 
> > The first is purely a dependency for the second. It has no value on its
> > own. So I thought the above form made sense and followed the process
> > mentioned in Documentation/stable_kernel_rules.txt.
> > 
> > Admittedly, it's a little asymmetric. But I really don't know what the
> > "best" option is, since I'd prefer not having to send around any patch
> > text at all, unless the backport is not trivial (these apply cleanly).
> 
> If they apply cleanly, then just list the git commit ids, and I can take
> care of the rest.

OK. Is this a policy that should be documented? AIUI, we have a few
options:

  1. Include 'Cc: stable@vger.kernel.org' in the original commit that
  gets to Linus

  2. Send an email to stable@vger.kernel.org that just contains the
  commit IDs, after they've made it to Linus

  3. Send patches to stable@vger.kernel.org, if backporting is not
  trivial

#1 is most common, and #2 seems like it would handle most of what misses
#1. #3 seems inferior, whenever #2 would suffice. But #2 is not in
stable_kernel_rules.txt.

> Don't merge patches together, it just causes problems and makes it
> harder to track what is going on.

To be clear, the diff I sent is actually just a single patch (the fix);
it is not a squashed version of both. I realize now that this was
probably unclear.

Brian
