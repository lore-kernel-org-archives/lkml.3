Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760719AbaGYPgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:36:52 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:63105 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbaGYPgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:36:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140725080244.GA31950@carfax.org.uk>
References: <1502954.OtX3SzjMKZ@merkaba>
	<1809953.ithLVmijbn@merkaba>
	<53D11F2B.1070008@fb.com>
	<1557956.045aK4K0qS@merkaba>
	<pan$aa09d$75e2870b$4abbbcef$7f21a37d@cox.net>
	<CAPDOMVhXL2nS8BDbwfhZpBehE2Tmb7wo3iK45KKqK38n9YzF2A@mail.gmail.com>
	<20140725080244.GA31950@carfax.org.uk>
Date: Fri, 25 Jul 2014 11:36:49 -0400
Message-ID: <CAPDOMVg+oNW1G_QmpXYQZ0Rb1jWZw0BxpvRt-Hsk-ceHX7Lh=Q@mail.gmail.com>
Subject: Re: BTRFS hang with 3.16-rc5 (and also with 3.16-rc4)
From: Nick Krause <xerofoify@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Hugo,
Thanks for the advice. I will look into this today :).
Cheers Nick

On Fri, Jul 25, 2014 at 4:02 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Thu, Jul 24, 2014 at 11:06:34PM -0400, Nick Krause wrote:
>> On Thu, Jul 24, 2014 at 10:32 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> [snip]
>> Hey Duncan and others ,
>> I have read this and this seems to need some working on.
>> If you want my help please ask , I am new to the kernel
>> so I may ask a dumb question or two but if that's fine with
>> you I have no problem helping out here. I would like
>> a log of printk statements leading to the hand if that's
>> not too much work in order for me to trace this back.
>
>    Note that btrfs is complex -- there's something around 100k lines
> of code in it. My first piece of kernel work in btrfs was simply
> documenting the way that the on-disk data structures related to each
> other[1]. That on its own took me two to three weeks of solid
> full-time effort, reading the code to find where each structure was
> used and how its elements related to other structures. You can't just
> wander up and dive in without putting in the effort of learning first.
> Whilst people will help you (come over to #btrfs on Freenode for more
> real-time interaction), they can't do the basic work of sitting down
> and understanding the code in detail for you.
>
>    Chris, who designed and wrote the filesystem, has spent the last
> couple of weeks tracking down this particular problem. Do you think
> it's appropriate to leap into the middle of the discussion on this
> subtle bug as someone with absolutely no experience in the area?
>
>    Your first task is to reproduce the bug on your own machine. If you
> can do that, _then_ you might be able to start tracking down its
> cause. But I wouldn't recommend doing that, as (a) it's a nasty subtle
> bug, and (b) Chris seems to be close to tracking it down anyway.
>
>    My recommendations for you, if you want to work on btrfs, are:
>
>  * Build and install the latest kernel from Linus's git repo
>
>  * Read and understand the user documentation [2]
>
>  * Create one or several btrfs filesystems with different
>    configurations and learn how they work in userspace -- what are the
>    features, what are the problems you see? Actually use at least one
>    of the filesystems you created for real data in daily use (with
>    backups)
>
>  * Build the userspace tools from git
>
>  * Pick up one of the userspace projects from [3] and implement that.
>    If you pick the right one(s), you'll have to learn about some of
>    the internal structures of the FS anyway. Compile and test your
>    patch. If you're adding a new feature, write an automated xfstest
>    for it as well.
>
>  * Get that patch accepted. This will probably involve a sequence of
>    revisions to it, multiple versions over a period of several weeks
>    or more, with a review process. You should also send your test to
>    xfstests and get that accepted.
>
>  * Do the above again, until you get used to the processes involved,
>    and have demonstrated that you can work well with the other people
>    in the subsystem, and are generally producing useful and sane code.
>    It's all about trust -- can you be trusted to mostly do the right
>    thing? (So far on linux-kernel, you've rather demonstrated the
>    opposite: your intentions are good, but your execution leaves a lot
>    to be desired)
>
>  * Use the documentation at [4], and the output of btrfs-debug-tree to
>    understand the internal structure of the FS
>
>  * Pick up one of the smaller, more self-contained ideas from the
>    projects page [5] (say, [6] or [7]) and try to implement it. Again:
>    build, write test code, test thoroughly, submit patch for review,
>    modify as suggested by reviewers, and repeat as often as necessary
>
>    Hugo.
>
> [1] https://btrfs.wiki.kernel.org/index.php/Data_Structures
> [2] https://btrfs.wiki.kernel.org/index.php/Main_Page#Guides_and_usage_information
> [3] https://btrfs.wiki.kernel.org/index.php/Project_ideas#Userspace_tools_projects
> [4] https://btrfs.wiki.kernel.org/index.php/Main_Page#Developer_documentation
> [5] https://btrfs.wiki.kernel.org/index.php/Project_ideas
> [6] https://btrfs.wiki.kernel.org/index.php/Project_ideas#Cancellable_operations
> [7] https://btrfs.wiki.kernel.org/index.php/Project_ideas#Implement_new_FALLOC_FL_.2A_modes
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>   --- But people have always eaten people,  / what else is there to ---
>          eat?  / If the Juju had meant us not to eat people / he
>                      wouldn't have made us of meat.
