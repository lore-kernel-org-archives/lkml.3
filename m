Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbaGHUpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 16:45:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36196 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbaGHUpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 16:45:13 -0400
Date: Tue, 8 Jul 2014 13:45:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] mm: Don't forget to set softdirty on file mapped fault
Message-Id: <20140708134511.4a32b7400a952541a31e9078@linux-foundation.org>
In-Reply-To: <20140708204017.GG17860@moon.sw.swsoft.com>
References: <20140708192151.GD17860@moon.sw.swsoft.com>
	<20140708131920.2a857d573e8cc89780c9fa1c@linux-foundation.org>
	<20140708204017.GG17860@moon.sw.swsoft.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2014 00:40:17 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On Tue, Jul 08, 2014 at 01:19:20PM -0700, Andrew Morton wrote:
> > On Tue, 8 Jul 2014 23:21:51 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > 
> > > Otherwise we may not notice that pte was softdirty because pte_mksoft_dirty
> > > helper _returns_ new pte but not modifies argument.
> > 
> > When fixing a bug, please describe the end-user visible effects of that
> > bug.
> > 
> > [for the 12,000th time :(]
> 
> "we may not notice that pte was softdirty" I thought it's enough, because
> that's the effect user sees -- pte is not dirtified where it should.
> 
> Really sorry Andrew if I were not clear enough. What about: In case if page
> fault happend on dirty filemapping the newly created pte may not
> notice if old one were already softdirtified because pte_mksoft_dirty
> doesn't modify its argument but rather returns new pte value.

The user doesn't know or care about pte bits.

What actually *happens*?  Does criu migration hang?  Does it lose data?
Does it take longer?

IOW, what would an end-user's bug report look like?

It's important to think this way because a year from now some person
we've never heard of may be looking at a user's bug report and
wondering whether backporting this patch will fix it.  Amongst other
reasons.
