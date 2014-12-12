Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbaLLB7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 20:59:23 -0500
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:15359 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750701AbaLLB7W convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 20:59:22 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Kirill A. Shutemov'" <kirill@shutemov.name>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Konstantin Khlebnikov'" <koct9i@gmail.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'n-horiguchi@ah.jp.nec.com'" <n-horiguchi@ah.jp.nec.com>,
        "'oleg@redhat.com'" <oleg@redhat.com>,
        "'gorcunov@openvz.org'" <gorcunov@openvz.org>,
        "'pfeiner@google.com'" <pfeiner@google.com>
Date: Fri, 12 Dec 2014 09:59:15 +0800
Subject: RE: [RFC] mm:fix zero_page huge_zero_page rss/pss statistic
Thread-Topic: [RFC] mm:fix zero_page huge_zero_page rss/pss statistic
Thread-Index: AdAUabTsySoG7nhnQeKiYv7Mut+5OwBRXJ+A
Message-ID: <35FD53F367049845BC99AC72306C23D103E688B31406@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E688B313EE@CNBJMBX05.corpusers.net>
 <CALYGNiOuBKz8shHSrFCp0BT5AV6XkNOCHj+LJedQQ-2YdZtM7w@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D103E688B313F2@CNBJMBX05.corpusers.net>
 <20141205143134.37139da2208c654a0d3cd942@linux-foundation.org>
 <35FD53F367049845BC99AC72306C23D103E688B313F4@CNBJMBX05.corpusers.net>
 <20141208114601.GA28846@node.dhcp.inet.fi>
 <35FD53F367049845BC99AC72306C23D103E688B313FB@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E688B31403@CNBJMBX05.corpusers.net>
 <20141210110556.GA10630@node.dhcp.inet.fi>
In-Reply-To: <20141210110556.GA10630@node.dhcp.inet.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Kirill A. Shutemov [mailto:kirill@shutemov.name]
> Sent: Wednesday, December 10, 2014 7:06 PM
> To: Wang, Yalin
> Cc: 'Andrew Morton'; 'Konstantin Khlebnikov'; 'linux-
> kernel@vger.kernel.org'; 'linux-mm@kvack.org'; 'linux-arm-
> kernel@lists.infradead.org'; 'n-horiguchi@ah.jp.nec.com'; 'oleg@redhat.com';
> 'gorcunov@openvz.org'; 'pfeiner@google.com'
> Subject: Re: [RFC] mm:fix zero_page huge_zero_page rss/pss statistic
> 
> On Wed, Dec 10, 2014 at 03:22:21PM +0800, Wang, Yalin wrote:
> > smaps_pte_entry() doesn't ignore zero_huge_page, but it ignore
> > zero_page, because vm_normal_page() will ignore it. We remove
> > vm_normal_page() call, because walk_page_range() have ignore VM_PFNMAP
> > vma maps, it's safe to just use pfn_valid(), so that we can also
> > consider zero_page to be a valid page.
> 
> We fixed huge zero page accounting in smaps recentely. See mm tree.
> 
Hi 
I can't find the git, could you send me a link?
Thank you !
