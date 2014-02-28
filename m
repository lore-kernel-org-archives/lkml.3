Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaB1AUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 19:20:04 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:33302 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaB1AUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 19:20:02 -0500
Date: Fri, 28 Feb 2014 02:18:58 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, Ning Qu <quning@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        anton@samba.org, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCHv3 1/2] mm: introduce vm_ops->map_pages()
Message-ID: <20140228001858.GC8034@node.dhcp.inet.fi>
References: <1393530827-25450-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1393530827-25450-2-git-send-email-kirill.shutemov@linux.intel.com>
 <530FB55F.2070106@linux.intel.com>
 <CA+55aFzUYTHXcVnZL0vTGRPh3oQ8qYGO9+Va1Ch3P1yX+9knDg@mail.gmail.com>
 <530FBD8F.7090304@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530FBD8F.7090304@linux.intel.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 02:34:55PM -0800, Dave Hansen wrote:
> Kirill's git test suite runs did show that it _can_ hurt in some cases.

And see last use-case for how much it can hurt. :)

It shouldn't differs much for the same *number* of pages between [u]archs
unless setup of the pte is significantly more expensive or page fault is
faster.

But of course, I can move FAULT_AROUND_PAGES to arch/x86/ and let
architecture mantainers to decide if they want the feature. ;)

-- 
 Kirill A. Shutemov
