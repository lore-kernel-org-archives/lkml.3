Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaIMFlw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 01:41:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60177 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaIMFlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 01:41:51 -0400
Date: Fri, 12 Sep 2014 22:42:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Rafael Aquini <aquini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH v2 4/6] mm: introduce common page state for ballooned
 memory
Message-Id: <20140912224221.9ee5888a.akpm@linux-foundation.org>
In-Reply-To: <CALYGNiM0Uh1KG8Z6pFEAn=uxZBRPfHDffXjKkKJoG-K0hCaqaA@mail.gmail.com>
References: <20140830163834.29066.98205.stgit@zurg>
	<20140830164120.29066.8857.stgit@zurg>
	<20140912165143.86d5f83dcde4a9fd78069f79@linux-foundation.org>
	<CALYGNiM0Uh1KG8Z6pFEAn=uxZBRPfHDffXjKkKJoG-K0hCaqaA@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Sep 2014 09:26:49 +0400 Konstantin Khlebnikov <koct9i@gmail.com> wrote:

> >
> > Did we really need to put the BalloonPages count into per-zone vmstat,
> > global vmstat and /proc/meminfo?  Seems a bit overkillish - why so
> > important?
> 
> Balloon grabs random pages, their distribution among numa nodes might
> be important.
> But I know nobody who uses numa-aware vm together with ballooning.
> 
> Probably it's better to drop per-zone vmstat and line from meminfo,
> global vmstat counter should be enough.

Yes, the less we add the better - we can always add stuff later if
there is a demonstrated need.

> >
> > Consuming another page flag is a big deal.  We keep on nearly running
> > out and one day we'll run out for real.  page-flags-layout.h is
> > incomprehensible.  How many flags do we have left (worst-case) with this
> > change?  Is there no other way?  Needs extraordinary justification,
> > please.
> 
> PageBalloon is not a page flags, it's like PageBuddy -- special state
> of _mapcount (-256 in this case).
> The same was in v1 and is written in the comment above.

oop sorry, I got confused about KPF_BALLOON.
