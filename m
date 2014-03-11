Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbaCKT3C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:29:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbaCKT3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:29:00 -0400
Date: Tue, 11 Mar 2014 12:28:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, hhuang@redhat.com,
        knoel@redhat.com, aarcange@redhat.com,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: [PATCH -mm] mm,numa,mprotect: always continue after finding a
 stable thp page
Message-Id: <20140311122859.fb6c1e772d82d9f4edd02f52@linux-foundation.org>
In-Reply-To: <531F616A.7060300@oracle.com>
References: <5318E4BC.50301@oracle.com>
	<20140306173137.6a23a0b2@cuia.bos.redhat.com>
	<5318FC3F.4080204@redhat.com>
	<20140307140650.GA1931@suse.de>
	<20140307150923.GB1931@suse.de>
	<20140307182745.GD1931@suse.de>
	<20140311162845.GA30604@suse.de>
	<531F3F15.8050206@oracle.com>
	<531F4128.8020109@redhat.com>
	<531F48CC.303@oracle.com>
	<20140311180652.GM10663@suse.de>
	<531F616A.7060300@oracle.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014 15:18:02 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:

> > 3. Can you test with the following patches reverted please?
> >
> > 	e15d25d9c827b4346a36a3a78dd566d5ad353402 mm-per-thread-vma-caching-fix-fix
> > 	e440e20dc76803cdab616b4756c201d5c72857f2 mm-per-thread-vma-caching-fix
> > 	0d9ad4220e6d73f63a9eeeaac031b92838f75bb3 mm: per-thread vma caching
> >
> > The last patch will not revert cleanly (least it didn't for me) but it
> > was just a case of git rm the two affected files, remove any include of
> > vmacache.h and commit the rest.
> 
> Don't see the issues I've reported before now.

This is foggy.  Do you mean that all the bugs went away when
per-thread-vma-caching was reverted?
