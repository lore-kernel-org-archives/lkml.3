Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941Ab3CHBPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 20:15:41 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:50272 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab3CHBPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 20:15:39 -0500
MIME-Version: 1.0
In-Reply-To: <20130307165642.00153a01.akpm@linux-foundation.org>
References: <1362683754-706-1-git-send-email-paul.gortmaker@windriver.com>
 <20130307112536.82288f41924a38a441cdf345@linux-foundation.org>
 <5138EF7F.1050003@windriver.com> <20130307133542.8bdb23612990fa25c5cc9112@linux-foundation.org>
 <CAP=VYLpeqVOC2ZpCdnPDuLrRjwdpbHn3XQoSwAUaYFRdwQPfaQ@mail.gmail.com> <20130307165642.00153a01.akpm@linux-foundation.org>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 7 Mar 2013 20:15:08 -0500
X-Google-Sender-Auth: Zv0HDXLp2VUXAoP8O4Hf5kj-Qrw
Message-ID: <CAP=VYLp-A9dMwD4_48zokL-XQ5pqPrkAy4UVx6cwUHQ3KozpSQ@mail.gmail.com>
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

On Thu, Mar 7, 2013 at 7:56 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 7 Mar 2013 19:49:35 -0500 Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
>
>> > otoh, offering useless stuff to non-kernel-developers has downsides
>> > with no balancing benefit, and we really should optimise things for
>> > our users because there are so many more of them than there are of us.
>>
>> Glad to hear that, and I agree totally.  I hope the above three lines
>> will persuade people to merge practical/sane dependency lines that
>> have the end users in mind, instead of focusing on ease of local testing.
>
> It is possible to just ignore the Kconfig system and type "make
> drivers/foo/bar.o".  Sometimes this actually works.

Yes, I've used that many times too[1] -- it however fails on things like
sched which has C files including C files.  Dave Miller had posted a tip
to people a while back on how to ferret out basic compile failures without
having _any_ cross toolchains by at least doing the basic CPP part, but I
can't find the archived thread in my  rudimentary searches at the moment...

In any case, it sounds like all are in agreement that we should not
complicate the end user main Kconfig use case just to offload a trivial
component of the automated build testing burden onto general users.

[1] https://git.kernel.org/cgit/linux/kernel/git/paulg/longterm-queue-2.6.34.git/tree/scripts/buildcommits

Paul.
