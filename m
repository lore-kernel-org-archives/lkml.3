Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612Ab3DXXXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 19:23:34 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:58486 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270Ab3DXXXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 19:23:32 -0400
Date: Wed, 24 Apr 2013 16:23:29 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ 04/26] hugetlbfs: add swap entry check in follow_hugetlb_page()
Message-ID: <20130424232329.GA9073@kroah.com>
References: <20130423215333.344045754@linuxfoundation.org>
 <20130423215333.802657218@linuxfoundation.org>
 <20130424230410.GB2619@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130424230410.GB2619@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 12:04:10AM +0100, Ben Hutchings wrote:
> On Tue, Apr 23, 2013 at 02:53:44PM -0700, Greg Kroah-Hartman wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > 
> > commit 9cc3a5bd40067b9a0fbd49199d0780463fc2140f upstream.
> > 
> > With applying the previous patch "hugetlbfs: stop setting VM_DONTDUMP in
> > initializing vma(VM_HUGETLB)" to reenable hugepage coredump, if a memory
> > error happens on a hugepage and the affected processes try to access the
> > error hugepage, we hit VM_BUG_ON(atomic_read(&page->_count) <= 0) in
> > get_page().
>  
> Is this required?  You didn't apply the previous patch referred to
> above (commit a2fce9143057) to 3.4.y or 3.0.y since it claimed to fix
> a regression in 3.7 (commit 314e51b9851b 'mm: kill vma flag VM_RESERVED
> and mm->reserved_vm counter').
> 
> I'm not saying it *isn't* required, mind.

Yeah, but I went off of the stable: marking in this patch, which said:
	    Cc: <stable@vger.kernel.org>        [2.6.34+?]


Naoya, any chance you could clear this up?  Is this needed for kernels
older than 3.7?

thanks,

greg k-h
