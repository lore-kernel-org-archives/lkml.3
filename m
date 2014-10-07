Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbaJGLLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 07:11:17 -0400
Received: from mta-out1.inet.fi ([62.71.2.197]:35298 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbaJGLLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 07:11:13 -0400
Date: Tue, 7 Oct 2014 14:10:26 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-api@vger.kernel.org,
        Robert Love <rlove@google.com>, Dave Hansen <dave@sr71.net>,
        Jan Kara <jack@suse.cz>, Neil Brown <neilb@suse.de>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Andrew Jones <drjones@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>, Taras Glek <tglek@mozilla.com>,
        Juan Quintela <quintela@redhat.com>, Hugh Dickins <hughd@google.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>, Mel Gorman <mgorman@suse.de>,
        Sasha Levin <sasha.levin@oracle.com>,
        Android Kernel Team <kernel-team@android.com>,
        "\\\"Dr. David Alan Gilbert\\\"" <dgilbert@redhat.com>,
        "Huangpeng (Peter)" <peter.huangpeng@huawei.com>,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Christopher Covington <cov@codeaurora.org>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Paolo Bonzini <pbonzini@redhat.com>, Keith Packard <keithp@keithp.com>,
        Wenchao Xia <wenchaoqemu@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Minchan Kim <minchan@kernel.org>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mike Hommey <mh@glandium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Feiner <pfeiner@google.com>
Subject: Re: [Qemu-devel] [PATCH 10/17] mm: rmap preparation for
 remap_anon_pages
Message-ID: <20141007111026.GD30762@node.dhcp.inet.fi>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
 <1412356087-16115-11-git-send-email-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412356087-16115-11-git-send-email-aarcange@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 07:08:00PM +0200, Andrea Arcangeli wrote:
> There's one constraint enforced to allow this simplification: the
> source pages passed to remap_anon_pages must be mapped only in one
> vma, but this is not a limitation when used to handle userland page
> faults with MADV_USERFAULT. The source addresses passed to
> remap_anon_pages should be set as VM_DONTCOPY with MADV_DONTFORK to
> avoid any risk of the mapcount of the pages increasing, if fork runs
> in parallel in another thread, before or while remap_anon_pages runs.

Have you considered triggering COW instead of adding limitation on
pages' mapcount? The limitation looks artificial from interface POV.

-- 
 Kirill A. Shutemov
