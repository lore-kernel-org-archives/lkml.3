Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935798Ab3DPQdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 12:33:17 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36518 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753110Ab3DPQdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 12:33:15 -0400
X-Sasl-enc: /Pm6Ml7WeNUXvHFjUsf/YLX1eq4VsWnX+0xxZUK0JZZg 1366129994
Date: Mon, 15 Apr 2013 21:40:49 -0700
From: Greg KH <greg@kroah.com>
To: D M German <dmg@uvic.ca>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: helping with tracking commits across repos
Message-ID: <20130416044049.GA6162@kroah.com>
References: <87r4ifxzwu.fsf@mn.cs.uvic.ca>
 <20130412203146.GA31283@kroah.com>
 <87r4ibpiq9.fsf@mn.cs.uvic.ca>
 <20130415230923.GA2417@kroah.com>
 <87mwsznxhi.fsf@mn.cs.uvic.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwsznxhi.fsf@mn.cs.uvic.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 05:13:45PM -0700, D M German wrote:
> 
> 
>  Greg KH twisted the bytes to say:
> 
>  >> http://o.cs.uvic.ca:20810/perl/next.pl
> 
>  Greg> Yes, that's a great thing.  Maybe the ability to see the subject: line
>  Greg> of the commit somewhere easier than having to click through to the patch
>  Greg> would be nice, so we can just glance at the report and say, "Look at all
>  Greg> of the btrfs patches that showed up out of nowhere, what happened?"
> 
>  Greg> Oh, and if you could do it for a specific kernel release, not a date
>  Greg> range, that would be nice (i.e. report for 3.9-rc1, 3.8-rc1, 3.7-rc1,
>  Greg> etc.)
> 
> What would be the simplest approach to getting the date? I suspect that
> it can be done by doing some command line magic in Linus git repo.

You want to look at the commits from the last major release (i.e. 3.8)
to the -rc1 release, (i.e. 3.9-rc1).  You can't look at the dates,
that's not going to reflect when the patch landed in Linus's branch.

So a simple:
	git rev-list --no-merges v3.8..v3.9-rc1
will give you the commits needed.

As for storage issues, look at the -s option to 'git clone'.  If you
read the man page, it talks about the .git/objects/info/alternates file
you can use to save on diskspace.

Use Linus's repo as a full clone, and then all other git repo you pull
from, should have the alternates file pointing to Linus's tree.  That
way, only the commits that are not in Linus's tree will be in the
directory, the shared ones will not be duplicated.

You can do this today on your existing repos by creating the alternates
file, and then doing 'git gc' on the repo to clean out the duplicates.
That should save you a _lot_ of storage space.

And you should also be keeping only --bare repos, no need for the
checked out trees on your disks, you don't need them, right?

Hope this helps,

greg k-h
