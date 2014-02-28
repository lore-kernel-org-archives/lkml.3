Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaB1Wen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:34:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaB1Wel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:34:41 -0500
Date: Fri, 28 Feb 2014 14:34:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ning Qu <quning@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, Ning Qu <quning@gmail.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 0/1] mm, shmem: map few pages around fault address if
 they are in page cache
Message-Id: <20140228143440.e0ec026baeced2efbb52aa50@linux-foundation.org>
In-Reply-To: <1393625931-2858-1-git-send-email-quning@google.com>
References: <1393625931-2858-1-git-send-email-quning@google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014 14:18:50 -0800 Ning Qu <quning@google.com> wrote:

> This is a follow-up patch for "mm: map few pages around fault address if they are in page cache"
> 
> We use the generic filemap_map_pages as ->map_pages in shmem/tmpfs.
> 

Please cc Hugh on shmem/tmpfs things

> 
> =========================================================================
> Below is just some simple experiment numbers from this patch, let me know if
> you would like more:
> 
> Tested on Xeon machine with 64GiB of RAM, using the current default fault
> order 4.
> 
> Sequential access 8GiB file
> 			Baseline 	with-patch
> 1 thread
>     minor fault		205		101	

Confused.  Sequential access of an 8G file should generate 2,000,000
minor faults, not 205.  And with FAULT_AROUND_ORDER=4, that should come
down to 2,000,000/16 minor faults when using faultaround?

>     time, seconds	7.94		7.82
> 
> Random access 8GiB file
> 			Baseline 	with-patch
> 1 thread
>     minor fault		724		623
>     time, seconds	9.75		9.84
> 

