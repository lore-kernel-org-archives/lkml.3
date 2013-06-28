Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab3F1WDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 18:03:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab3F1WDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 18:03:22 -0400
Date: Fri, 28 Jun 2013 15:03:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joern Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] hugetlb: properly account rss
Message-Id: <20130628150321.106fe1e67f0e18a6eb3ca320@linux-foundation.org>
In-Reply-To: <1371581225-27535-2-git-send-email-joern@logfs.org>
References: <1371581225-27535-1-git-send-email-joern@logfs.org>
	<1371581225-27535-2-git-send-email-joern@logfs.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013 14:47:04 -0400 Joern Engel <joern@logfs.org> wrote:

> When moving a program from mmap'ing small pages to mmap'ing huge pages,
> a remarkable drop in rss ensues.  For some reason hugepages were never
> accounted for in rss, which in my book is a clear bug.  Sadly this bug
> has been present in hugetlbfs since it was merged back in 2002.  There
> is every chance existing programs depend on hugepages not being counted
> as rss.
> 
> I think the correct solution is to fix the bug and wait for someone to
> complain.  It is just as likely that noone cares - as evidenced by the
> fact that noone seems to have noticed for ten years.
> 

Yes, that is a concern.  I'll toss it in there so we can see what
happens, but I fear that any problems will take a long time to be
discovered.
