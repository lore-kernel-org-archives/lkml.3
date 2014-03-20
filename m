Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999AbaCTNv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 09:51:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757555AbaCTNv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 09:51:56 -0400
Date: Thu, 20 Mar 2014 09:51:37 -0400
From: Dave Jones <davej@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Bob Liu <bob.liu@oracle.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: bad rss-counter message in 3.14rc5
Message-ID: <20140320135137.GA2263@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Bob Liu <bob.liu@oracle.com>,
	Konstantin Khlebnikov <koct9i@gmail.com>
References: <20140311171045.GA4693@redhat.com>
 <20140311173603.GG32390@moon>
 <20140311173917.GB4693@redhat.com>
 <alpine.LSU.2.11.1403181703470.7055@eggly.anvils>
 <5328F3B4.1080208@oracle.com>
 <20140319020602.GA29787@redhat.com>
 <20140319021131.GA30018@redhat.com>
 <alpine.LSU.2.11.1403181918130.3423@eggly.anvils>
 <20140319145200.GA4608@redhat.com>
 <alpine.LSU.2.11.1403192147470.971@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1403192147470.971@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 10:00:29PM -0700, Hugh Dickins wrote:

 > > This might be collateral damage from the swapops thing, I guess we won't know until
 > > that gets fixed, but I thought I'd mention that we might still have a problem here.
 > 
 > Yes, those Bad rss-counters could well be collateral damage from the
 > swapops BUG.  To which I believe I now have the answer: again untested,
 > but please give this a try...

This survived an overnight run. No swapops bug, and no bad RSS. Good job :)

 > (It's worth saying, by the way, that these bugs are not a consequence
 > of recent changes at all, they've been there for ages; but trinity has
 > just got better at taunting remap_file_pages and the rest of mm...)

Indeed. I hope to lift the covers on more stuff like this (and hopefully
get it done in a more reproducable manner).  A lot of the stuff trinity
is doing with VM syscalls is still very naive.

	Dave

