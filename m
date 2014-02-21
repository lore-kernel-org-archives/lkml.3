Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbaBUU52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:57:28 -0500
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:10543 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbaBUU50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:57:26 -0500
Message-ID: <1393016226.3039.44.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] mm: per-thread vma caching
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 21 Feb 2014 12:57:06 -0800
In-Reply-To: <CA+55aFw1_Ecbjjv9vijj3o46mkq3NrJn0X-FnbpCGBZG2=NuOA@mail.gmail.com>
References: <1392960523.3039.16.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFw1_Ecbjjv9vijj3o46mkq3NrJn0X-FnbpCGBZG2=NuOA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-21 at 10:13 -0800, Linus Torvalds wrote:
> On Thu, Feb 20, 2014 at 9:28 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> > From: Davidlohr Bueso <davidlohr@hp.com>
> >
> > This patch is a continuation of efforts trying to optimize find_vma(),
> > avoiding potentially expensive rbtree walks to locate a vma upon faults.
> 
> Ok, so I like this one much better than the previous version.

Btw, one concern I had is regarding seqnum overflows... if such
scenarios should happen we'd end up potentially returning bogus vmas and
getting bus errors and other sorts of issues. So we'd have to flush the
caches, but, do we care? I guess on 32bit systems it could be a bit more
possible to trigger given enough forking.

Thanks,
Davidlohr

