Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbaLJLJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:09:06 -0500
Received: from mta-out1.inet.fi ([62.71.2.227]:42680 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbaLJLJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:09:03 -0500
Date: Wed, 10 Dec 2014 13:05:56 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Konstantin Khlebnikov'" <koct9i@gmail.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'n-horiguchi@ah.jp.nec.com'" <n-horiguchi@ah.jp.nec.com>,
        "'oleg@redhat.com'" <oleg@redhat.com>,
        "'gorcunov@openvz.org'" <gorcunov@openvz.org>,
        "'pfeiner@google.com'" <pfeiner@google.com>
Subject: Re: [RFC] mm:fix zero_page huge_zero_page rss/pss statistic
Message-ID: <20141210110556.GA10630@node.dhcp.inet.fi>
References: <35FD53F367049845BC99AC72306C23D103E688B313EE@CNBJMBX05.corpusers.net>
 <CALYGNiOuBKz8shHSrFCp0BT5AV6XkNOCHj+LJedQQ-2YdZtM7w@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D103E688B313F2@CNBJMBX05.corpusers.net>
 <20141205143134.37139da2208c654a0d3cd942@linux-foundation.org>
 <35FD53F367049845BC99AC72306C23D103E688B313F4@CNBJMBX05.corpusers.net>
 <20141208114601.GA28846@node.dhcp.inet.fi>
 <35FD53F367049845BC99AC72306C23D103E688B313FB@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E688B31403@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E688B31403@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 03:22:21PM +0800, Wang, Yalin wrote:
> smaps_pte_entry() doesn't ignore zero_huge_page,
> but it ignore zero_page, because vm_normal_page() will
> ignore it. We remove vm_normal_page() call, because walk_page_range()
> have ignore VM_PFNMAP vma maps, it's safe to just use pfn_valid(),
> so that we can also consider zero_page to be a valid page.

We fixed huge zero page accounting in smaps recentely. See mm tree.

-- 
 Kirill A. Shutemov
