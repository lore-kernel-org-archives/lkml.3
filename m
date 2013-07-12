Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab3GLAuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:50:32 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37038 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120Ab3GLAua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 20:50:30 -0400
Date: Thu, 11 Jul 2013 20:50:23 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        ksummit-2013-discuss@lists.linux-foundation.org
Subject: When to push bug fixes to mainline
Message-ID: <20130712005023.GB31005@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, stable@vger.kernel.org,
	ksummit-2013-discuss@lists.linux-foundation.org
References: <20130711214830.611455274@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130711214830.611455274@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 03:01:17PM -0700, Greg Kroah-Hartman wrote:
> <rant>
>   I'm sitting on top of over 170 more patches that have been marked for
>   the stable releases right now that are not included in this set of
>   releases.  The fact that there are this many patches for stable stuff
>   that are waiting to be merged through the main -rc1 merge window cycle
>   is worrying to me.
> 
>   Why are subsystem maintainers holding on to fixes that are
>   _supposedly_ affecting all users?  I mean, 21 powerpc core changes
>   that I don't see until a -rc1 merge?  It's as if developers don't
>   expect people to use a .0 release and are relying on me to get the
>   fixes they have burried in their trees out to users.  That's not that
>   nice.  6 "core" iscsi-target fixes?  That's the sign of either a
>   broken subsystem maintainer, or a lack of understanding what the
>   normal -rc kernel releases are supposed to be for.

At least at one point in the past, the rule that Linus had laid down
after discussing things at Kernel Summits was after -rc2, or maybe
-rc3 at the latest, the ***only*** fixes that should be sent to Linus
would be for regression fixes or for really serious data integrity
issues.  The concern was that people were pushing bug fixes in -rc5 or
-rc6 that were in some cases causing regressions.

(As I recall, Linus laid down the law regarding this policy in his own
inimitable and colorful style; which today would result in all sorts
of tsk, tsking on Hacker News regarding his language.  :-)

In any case, I've been very conservative in _not_ pushing bug fixes to
Linus after -rc3 (unless they are fixing a regression or the bug fix
is super-serious); I'd much rather have them cook in the ext4 tree
where they can get a lot more testing (a full regression test run for
ext4 takes over 24 hours), and for people trying out linux-next.

Maybe the pendulum has swung too far in the direction of holding back
changes and trying to avoid the risk of introducing regressions;
perhaps this would be a good topic to discuss at the Kernel Summit.

Regards,

						- Ted
