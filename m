Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaJGLCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 07:02:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbaJGLCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 07:02:13 -0400
Date: Tue, 7 Oct 2014 12:01:02 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Robert Love <rlove@google.com>, Dave Hansen <dave@sr71.net>,
        Jan Kara <jack@suse.cz>, kvm@vger.kernel.org,
        Neil Brown <neilb@suse.de>, Stefan Hajnoczi <stefanha@gmail.com>,
        qemu-devel@nongnu.org, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Taras Glek <tglek@mozilla.com>,
        Andrew Jones <drjones@redhat.com>, Juan Quintela <quintela@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>, Mel Gorman <mgorman@suse.de>,
        Sasha Levin <sasha.levin@oracle.com>,
        Android Kernel Team <kernel-team@android.com>,
        "Huangpeng (Peter)" <peter.huangpeng@huawei.com>,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Christopher Covington <cov@codeaurora.org>,
        Anthony Liguori <anthony@codemonkey.ws>, Mike Hommey <mh@glandium.org>,
        Keith Packard <keithp@keithp.com>, Wenchao Xia <wenchaoqemu@gmail.com>,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Minchan Kim <minchan@kernel.org>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Feiner <pfeiner@google.com>
Subject: Re: [Qemu-devel] [PATCH 08/17] mm: madvise MADV_USERFAULT
Message-ID: <20141007110102.GJ2404@work-vm>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
 <1412356087-16115-9-git-send-email-aarcange@redhat.com>
 <20141007103645.GB30762@node.dhcp.inet.fi>
 <20141007104603.GI2404@work-vm>
 <20141007105245.GC30762@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007105245.GC30762@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kirill A. Shutemov (kirill@shutemov.name) wrote:
> On Tue, Oct 07, 2014 at 11:46:04AM +0100, Dr. David Alan Gilbert wrote:
> > * Kirill A. Shutemov (kirill@shutemov.name) wrote:
> > > On Fri, Oct 03, 2014 at 07:07:58PM +0200, Andrea Arcangeli wrote:
> > > > MADV_USERFAULT is a new madvise flag that will set VM_USERFAULT in the
> > > > vma flags. Whenever VM_USERFAULT is set in an anonymous vma, if
> > > > userland touches a still unmapped virtual address, a sigbus signal is
> > > > sent instead of allocating a new page. The sigbus signal handler will
> > > > then resolve the page fault in userland by calling the
> > > > remap_anon_pages syscall.
> > > 
> > > Hm. I wounder if this functionality really fits madvise(2) interface: as
> > > far as I understand it, it provides a way to give a *hint* to kernel which
> > > may or may not trigger an action from kernel side. I don't think an
> > > application will behaive reasonably if kernel ignore the *advise* and will
> > > not send SIGBUS, but allocate memory.
> > 
> > Aren't DONTNEED and DONTDUMP  similar cases of madvise operations that are
> > expected to do what they say ?
> 
> No. If kernel would ignore MADV_DONTNEED or MADV_DONTDUMP it will not
> affect correctness, just behaviour will be suboptimal: more than needed
> memory used or wasted space in coredump.

That's not how the manpage reads for DONTNEED; it calls it out as a special
case near the top, and explicitly says what will happen if you read the
area marked as DONTNEED.

It looks like there are openssl patches that use DONTDUMP to explicitly
make sure keys etc don't land in cores.

Dave

> 
> -- 
>  Kirill A. Shutemov
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
