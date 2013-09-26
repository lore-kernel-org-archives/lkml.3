Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab3IZVNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 17:13:42 -0400
Received: from www.sr71.net ([198.145.64.142]:38192 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab3IZVNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 17:13:39 -0400
Message-ID: <5244A368.4080208@sr71.net>
Date: Thu, 26 Sep 2013 14:13:12 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Ning Qu <quning@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Luck, Tony" <tony.luck@intel.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCHv6 00/22] Transparent huge page cache: phase 1, everything
 but mmap()
References: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 05:05 AM, Kirill A. Shutemov wrote:
> To proof that the proposed changes are functional we enable the feature
> for the most simple file system -- ramfs. ramfs is not that useful by
> itself, but it's good pilot project.

This does, at the least, give us a shared memory mechanism that can move
between large and small pages.  We don't have anything which can do that
today.

Tony Luck was just mentioning that if we have a small (say 1-bit) memory
failure in a hugetlbfs page, then we end up tossing out the entire 2MB.
 The app gets a chance to recover the contents, but it has to do it for
the entire 2MB.  Ideally, we'd like to break the 2M down in to 4k pages,
which lets us continue using the remaining 2M-4k, and leaves the app to
rebuild 4k of its data instead of 2M.

If you look at the diffstat, it's also pretty obvious that virtually
none of this code is actually specific to ramfs.  It'll all get used as
the foundation for the "real" filesystems too.  I'm very interested in
how those end up looking, too, but I think Kirill is selling his patches
a bit short calling this a toy.
