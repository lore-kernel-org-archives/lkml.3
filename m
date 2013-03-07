Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864Ab3CGVfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:35:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab3CGVfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:35:44 -0500
Date: Thu, 7 Mar 2013 13:35:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Mike Frysinger <vapier@gentoo.org>, Ingo Molnar <mingo@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH v2] early_printk: consolidate random copies of identical
 code
Message-Id: <20130307133542.8bdb23612990fa25c5cc9112@linux-foundation.org>
In-Reply-To: <5138EF7F.1050003@windriver.com>
References: <1362683754-706-1-git-send-email-paul.gortmaker@windriver.com>
	<20130307112536.82288f41924a38a441cdf345@linux-foundation.org>
	<5138EF7F.1050003@windriver.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Mar 2013 14:50:23 -0500 Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> This brings up a recurring question.  I was tempted to just go make
> CONFIG_EARLY_PRINTK depend on CONFIG_PRINTK, but lately I've faced
> pushback when trying to "fix" things like seeing ARM OMAP USB options
> for an x86 build[1], and GOLDFISH virt drivers being offered even
> when the end user already said no to GOLDFISH[2].
> 
> Do we want to use dependencies to reflect the real world layout of
> platforms/systems, or do we want to go the minimal dependency
> approach, where we are building sparc specific drivers on mips just
> because we can?
> 
> I think the former is better from a user specific point of view, as
> the maze of Kconfig is better as a tree topology with branches that
> have clear dependencies that exclude them, versus it being a flat
> monolithic space where anything can select anything.
> 
> Arguments I've heard for the latter seem to be developer centric
> (i.e forcing wider build coverage on the population as a whole, etc)

For me personally, I really really want good compilation coverage.  It
drives me bats when I merge a patch but have to jump through a series
of hoops (such as not having the appropriate cross-compiler!) to be
able to build the thing.

otoh, offering useless stuff to non-kernel-developers has downsides
with no balancing benefit, and we really should optimise things for
our users because there are so many more of them than there are of us.

I wish we could do both :(   CONFIG_AKPM?
