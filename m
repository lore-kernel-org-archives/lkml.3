Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab3GWJge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:36:34 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:58270 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab3GWJgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:36:32 -0400
Date: Tue, 23 Jul 2013 11:36:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Chen Gang <gang.chen@asianux.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH, re-send] Always trap on BUG()
Message-ID: <20130723093628.GC19786@gmail.com>
References: <201307051738.35930.arnd@arndb.de>
 <20130715151612.9499c2b2ad40e88d183a4600@linux-foundation.org>
 <20130715222755.GY24642@n2100.arm.linux.org.uk>
 <51E47924.9030005@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E47924.9030005@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 07/15/2013 03:27 PM, Russell King - ARM Linux wrote:
> > On Mon, Jul 15, 2013 at 03:16:12PM -0700, Andrew Morton wrote:
> >> I've been thinking for a while that CONFIG_BUG=n is a pretty dumb thing
> >> to do, and that maintaining it (and trying to fix the warnings it
> >> produces) aren't worth the effort and that we should remove the whole
> >> thing.  Perhaps your patch changes that calculus, dunno.  Please discuss.
> > 
> > This isn't about introducing "CONFIG_BUG=n" - this is about making a
> > kernel with CONFIG_BUG=n build without producing tonnes and tonnes of
> > warnings, as it does today.  It makes building randconfig pretty
> > useless to find what could be more important warnings.
> > 
> 
> Well, there are three alternatives here, right:
> 
> 1. We can use unreachable(), which means that the compiler can assume it
> never happens.

AFAICS this is dangerous as it loses warnings and moves execution into 
la-la-land without any obvious sign at the C level.

> 2. We can trap without metadata.

This is what the patch does.

> 3. We can trap with metadata (current CONFIG_BUG=y).

That is still kept with the patch.

> I am *guessing* this does 2, but it isn't clear.

Yes, that's what it does - and I think it's the best of all worlds:

Acked-by: Ingo Molnar <mingo@kernel.org>

(the crazies can keep a separate patch to remove even more of BUG() to win 
a K or two.)

Thanks,

	Ingo
