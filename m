Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab3IXX6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 19:58:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab3IXX6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 19:58:50 -0400
Date: Tue, 24 Sep 2013 16:58:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Ning Qu <quning@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv6 00/22] Transparent huge page cache: phase 1,
 everything but mmap()
Message-Id: <20130924165848.4f3ba25b4de236fa746fb7ee@linux-foundation.org>
In-Reply-To: <20130924234950.GC2018@tassilo.jf.intel.com>
References: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
	<20130924163740.4bc7db61e3e520798220dc4c@linux-foundation.org>
	<20130924234950.GC2018@tassilo.jf.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Sep 2013 16:49:50 -0700 Andi Kleen <ak@linux.intel.com> wrote:

> > At the very least we should get this done for a real filesystem to see
> > how intrusive the changes are and to evaluate the performance changes.
> 
> That would give even larger patches, and people already complain
> the patchkit is too large.

The thing is that merging an implementation for ramfs commits us to
doing it for the major real filesystems.  Before making that commitment
we should at least have a pretty good understanding of what those
changes will look like.

Plus I don't see how we can realistically performance-test it without
having real physical backing store in the picture?

