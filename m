Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbaCMTAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 15:00:09 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:20613 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbaCMTAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 15:00:07 -0400
Message-ID: <1394737202.2452.8.camel@buesod1.americas.hpqcorp.net>
Subject: Re: mm: mmap_sem lock assertion failure in __mlock_vma_pages_range
From: Davidlohr Bueso <davidlohr@hp.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 13 Mar 2014 12:00:02 -0700
In-Reply-To: <531F8C3A.1040502@oracle.com>
References: <531F6689.60307@oracle.com>
				<1394568453.2786.28.camel@buesod1.americas.hpqcorp.net>
			 <20140311133051.bf5ca716ef189746ebcff431@linux-foundation.org>
			 <531F75D1.3060909@oracle.com>
		 <1394570844.2786.42.camel@buesod1.americas.hpqcorp.net>
		 <531F79F7.5090201@oracle.com>
	 <1394574323.2786.45.camel@buesod1.americas.hpqcorp.net>
	 <531F8C3A.1040502@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-11 at 18:20 -0400, Sasha Levin wrote:
> On 03/11/2014 05:45 PM, Davidlohr Bueso wrote:
> > On Tue, 2014-03-11 at 17:02 -0400, Sasha Levin wrote:
> >> >On 03/11/2014 04:47 PM, Davidlohr Bueso wrote:
> >>>> > >>Bingo! With the above patch:
> >>>>> > >> >
> >>>>> > >> >[  243.565794] kernel BUG at mm/vmacache.c:76!
> >>>>> > >> >[  243.566720] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> >>>>> > >> >[  243.568048] Dumping ftrace buffer:
> >>>>> > >> >[  243.568740]    (ftrace buffer empty)
> >>>>> > >> >[  243.569481] Modules linked in:
> >>>>> > >> >[  243.570203] CPU: 10 PID: 10073 Comm: trinity-c332 Tainted: G        W    3.14.0-rc5-next-20140307-sasha-00010-g1f812cb-dirty #143
> >>> > >and this is also part of the DEBUG_PAGEALLOC + trinity combo! I suspect
> >>> > >the root cause it the same as Fengguang's report.
> >> >
> >> >The BUG still happens without DEBUG_PAGEALLOC.
> > Any idea what trinity itself is doing?
> >
> > Could you add the following, I just want to make sure the bug isn't
> > being caused by an overflow:
> 
> Not hitting that WARN.

Sasha, could you please try the following patch:
https://lkml.org/lkml/2014/3/13/312

thanks.

