Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab3C1QF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:05:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158Ab3C1QFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:05:22 -0400
Date: Thu, 28 Mar 2013 12:04:29 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Message-ID: <1364486669-10tbmvlb-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20130328155109.GA13075@kroah.com>
References: <1364485358-8745-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1364485358-8745-2-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20130328155109.GA13075@kroah.com>
Subject: Re: [PATCH 1/2] hugetlbfs: stop setting VM_DONTDUMP in initializing
 vma(VM_HUGETLB)
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <20130328155109.GA13075@kroah.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 08:51:09AM -0700, Greg KH wrote:
> On Thu, Mar 28, 2013 at 11:42:37AM -0400, Naoya Horiguchi wrote:
> > Currently we fail to include any data on hugepages into coredump,
> > because VM_DONTDUMP is set on hugetlbfs's vma. This behavior was recently
> > introduced by commit 314e51b98 "mm: kill vma flag VM_RESERVED and
> > mm->reserved_vm counter". This looks to me a serious regression,
> > so let's fix it.
> > 
> > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
> > ---
> >  fs/hugetlbfs/inode.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> for how to do this properly.
> 
> </formletter>

I guess you mean this patch violates one/both of these rules:

 - It must fix a problem that causes a build error (but not for things
   marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
   security issue, or some "oh, that's not good" issue.  In short, something
   critical.
 - It or an equivalent fix must already exist in Linus' tree (upstream).

I'm not sure if the problem "we can't get any hugepage in coredump"
is considered as 'some "oh, that's not good" issue'.
But yes, it's not a critical one.
If you mean I violated the second rule, sorry, I'll get it into upstream first.

Thanks,
Naoya
