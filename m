Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbaDDOyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:54:01 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:59716 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbaDDOxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:53:55 -0400
Date: Fri, 4 Apr 2014 07:52:47 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: "Kirill A. Shutemov" <kirill@shutemov.name>
cc: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Roland Dreier <roland@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Inki Dae <inki.dae@samsung.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-rdma@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] mm: get_user_pages(write,force) refuse to COW in shared
 areas
In-Reply-To: <20140404123242.GA22320@node.dhcp.inet.fi>
Message-ID: <alpine.LSU.2.11.1404040733490.7442@eggly.anvils>
References: <alpine.LSU.2.11.1404040120110.6880@eggly.anvils> <20140404123242.GA22320@node.dhcp.inet.fi>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2014, Kirill A. Shutemov wrote:
> 
> There's comment in do_wp_page() which is not true anymore with patch
> applied. It should be fixed.

The * Only catch write-faults on shared writable pages,
    * read-only shared pages can get COWed by
    * get_user_pages(.write=1, .force=1).

Yes, I went back and forth on that: I found it difficult to remove that
comment without also simplifying the VM_WRITE|VM_SHARED test immediately
above it, possibly even looking again at the ordering of those tests.

In the end I decided to leave changing it to when we do the other
little cleanups outside get_user_pages(), after it's become clear
whether the new EFAULT is troublesome or not.  Most of my testing
had been without any change in do_wp_page(), so I left that out.

> 
> Otherwise, looks good to me:
> 
> Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Thanks,
Hugh
