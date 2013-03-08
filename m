Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab3CHAuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 19:50:09 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:54072 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759228Ab3CHAuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 19:50:07 -0500
MIME-Version: 1.0
In-Reply-To: <20130307133542.8bdb23612990fa25c5cc9112@linux-foundation.org>
References: <1362683754-706-1-git-send-email-paul.gortmaker@windriver.com>
 <20130307112536.82288f41924a38a441cdf345@linux-foundation.org>
 <5138EF7F.1050003@windriver.com> <20130307133542.8bdb23612990fa25c5cc9112@linux-foundation.org>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 7 Mar 2013 19:49:35 -0500
X-Google-Sender-Auth: QT1LH_TgTa7oP3qV65gU5bl0aws
Message-ID: <CAP=VYLpeqVOC2ZpCdnPDuLrRjwdpbHn3XQoSwAUaYFRdwQPfaQ@mail.gmail.com>
Subject: Re: [PATCH v2] early_printk: consolidate random copies of identical code
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Frysinger <vapier@gentoo.org>, Ingo Molnar <mingo@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 4:35 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 7 Mar 2013 14:50:23 -0500 Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
>
>> This brings up a recurring question.  I was tempted to just go make
>> CONFIG_EARLY_PRINTK depend on CONFIG_PRINTK, but lately I've faced
>> pushback when trying to "fix" things like seeing ARM OMAP USB options
>> for an x86 build[1], and GOLDFISH virt drivers being offered even
>> when the end user already said no to GOLDFISH[2].
>>
>> Do we want to use dependencies to reflect the real world layout of
>> platforms/systems, or do we want to go the minimal dependency
>> approach, where we are building sparc specific drivers on mips just
>> because we can?
>>
>> I think the former is better from a user specific point of view, as
>> the maze of Kconfig is better as a tree topology with branches that
>> have clear dependencies that exclude them, versus it being a flat
>> monolithic space where anything can select anything.
>>
>> Arguments I've heard for the latter seem to be developer centric
>> (i.e forcing wider build coverage on the population as a whole, etc)
>
> For me personally, I really really want good compilation coverage.  It
> drives me bats when I merge a patch but have to jump through a series
> of hoops (such as not having the appropriate cross-compiler!) to be
> able to build the thing.

Interestingly enough, I discovered this has become automated to a
degree beyond any expectations I could have ever imagined.  To
the point where I really don't need any cross-compiler at all.

Recently I had some TIPC changes, destined for net-next, and I'd
pushed them to a personal branch on kernel.org called tipc-next, in
a paulg repo which I assumed nobody was looking at.

Within an hour, Fengguang's robots[1] found the branch, were compiling
it for fringe architectures, and running sparse on it, and sending me the
sparse regressions.  I'd listened to Fengguang's presentation while at
KS in San Diego, but I had no idea it was this proactive, until it did
autobot testing on my branch.

I have most of the prebuilt toolchains[2], and two line wrappers to set
the ARCH/CROSS_COMPILE, but as it stands, it seems I really don't
need those any more.  I can sanity test on a common arch and then
simply push to kernel.org to trigger build sanity across all arch.  I'll
probably still continue to use the toolchain prebuilts to test locally
though, just for the peace of mind.  But knowing FW bots are doing
testing before it goes into linux-next or anywhere else is really nice.

> otoh, offering useless stuff to non-kernel-developers has downsides
> with no balancing benefit, and we really should optimise things for
> our users because there are so many more of them than there are of us.

Glad to hear that, and I agree totally.  I hope the above three lines
will persuade people to merge practical/sane dependency lines that
have the end users in mind, instead of focusing on ease of local testing.

Thanks,
Paul.
---

[1] http://lwn.net/Articles/514278/
[2] ftp://ftp.kernel.org/pub/tools/crosstool/files/bin/x86_64/
