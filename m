Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3J3SM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 14:12:26 -0400
Received: from mail12.copyleft.no ([188.94.218.224]:40431 "EHLO
	mail12.copyleft.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3J3SMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 14:12:24 -0400
MIME-Version: 1.0
In-Reply-To: <20131029020824.GE11861@sigill.intra.peff.net>
References: <20131024122255.GI9378@mwanda>
	<20131024122512.GB9534@mwanda>
	<20131026181709.GB10488@kroah.com>
	<20131027013402.GA7146@leaf>
	<526CA7D4.1070904@alum.mit.edu>
	<20131027071407.GA11683@leaf>
	<526E283A.1070801@alum.mit.edu>
	<CALKQrgfsk3fjyF77XL9+CPyJ_s-AfzkNAj4Eaj1LT-G0Ph=bfg@mail.gmail.com>
	<20131029020824.GE11861@sigill.intra.peff.net>
Date: Wed, 30 Oct 2013 19:12:16 +0100
Message-ID: <CALKQrge8T8R7roUUYyLcu_QnL1afeqTATOp+0n_OOsZZoJXF4Q@mail.gmail.com>
Subject: Re: [PATCH] commit: Add -f, --fixes <commit> option to add Fixes: line
From: Johan Herland <johan@herland.net>
To: Jeff King <peff@peff.net>
Cc: Michael Haggerty <mhagger@alum.mit.edu>,
        Josh Triplett <josh@joshtriplett.org>,
        Git mailing list <git@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, Greg KH <greg@kroah.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        ksummit-attendees@lists.linuxfoundation.org,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 3:08 AM, Jeff King <peff@peff.net> wrote:
> On Mon, Oct 28, 2013 at 12:29:32PM +0100, Johan Herland wrote:
>> > A hook-based solution could do this.  But a built-in "all-purpose"
>> > handler like "footer.Fixes.arg=commit", which was intended to be
>> > reusable, wouldn't be able to do such footer-specific extra work without
>> > having to create new special cases in git each time.
>>
>> Which begs the question (posed to all, not specifically to you): Why
>> would we want solve this issue in config instead of in hooks? The
>> hooks will always be more flexible and less dependent on making
>> changes in git.git. (...a suitably flexible hook could even use the
>> config options discussed above as input...) In both cases, we need the
>> user to actively enable the functionality (either installing hooks, or
>> setting up config), and in both cases we could bundle Git with
>> defaults that solve the common cases, so that is not a useful
>> differentiator between the two approaches. I would even venture to
>> ask: If we end up solving this problem in config and not in hooks,
>> then why do we bother having hooks in the first place?
>
> One thing that is much nicer with config vs hooks is that you can manage
> config for all of your repositories by tweaking ~/.gitconfig (and that
> is where I would expect this type of config to go).

Actually, I believe the use of footers are more often guided by
project conventions/rules, so I wouldn't expect such config to go into
~/.gitconfig. I would rather expect to find it in an in-project config
that was included from the repo config...

> Managing hooks globally means having each repo symlink to a central hook
> area, and having the forethought to set up the symlink farm and use
> init.templatedir before cloning any repos.  We could probably make this
> friendlier by reading from ~/.githooks and defining some semantics for
> multiple hooks. E.g., fall back to ~/.githooks if the repo hook is not
> executable, or possibly run them both (or even allow multiple instances
> of a hook in ~/.githooks, which can help organization), and consider the
> hook a failure if any of them fail.

Yes, we do lack a good infrastructure for managing Git hooks from
multiple sources. It makes people afraid to use them, because they
might conflict with hooks from another source. There are (off the top
of my head):

 - "personal" hooks ("I want this behaviour in my repo(s)")
 - "project" hooks ("In this project we follow these conventions")
 - "system" hooks ("This host runs gitolite (or whatever) which needs
these hooks...")
 - "default" hooks (Some of the core Git code could have be
implemented as hooks (e.g. "--signoff"), but is instead put into core
Git)

Maybe if we solved that problem, we could actually make use of hooks
instead of adding "code" to our git configs (by which I mean config
directives that are flexible enough to encode all kinds of semantics
and behaviors that are probably better expressed in real code...).

...Johan

-- 
Johan Herland, <johan@herland.net>
www.herland.net
