Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbbAMUmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 15:42:04 -0500
Received: from mta-out1.inet.fi ([62.71.2.227]:38897 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbbAMUmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 15:42:01 -0500
Date: Tue, 13 Jan 2015 22:41:44 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: rename mm->nr_ptes to mm->nr_pgtables
Message-ID: <20150113204144.GA1865@node.dhcp.inet.fi>
References: <1421176456-21796-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1421176456-21796-2-git-send-email-kirill.shutemov@linux.intel.com>
 <54B581C7.50206@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B581C7.50206@linux.intel.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 12:36:23PM -0800, Dave Hansen wrote:
> On 01/13/2015 11:14 AM, Kirill A. Shutemov wrote:
> >  	pgd_t * pgd;
> >  	atomic_t mm_users;			/* How many users with user space? */
> >  	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
> > -	atomic_long_t nr_ptes;			/* Page table pages */
> > +	atomic_long_t nr_pgtables;		/* Page table pages */
> >  	int map_count;				/* number of VMAs */
> 
> One more crazy idea...
> 
> There are 2^9 possible pud pages, 2^18 pmd pages and 2^27 pte pages.
> That's only 54 bits (technically minus one bit each because the upper
> half of the address space is for the kernel).

Does this math make sense for all architecures? IA64? Power?

-- 
 Kirill A. Shutemov
