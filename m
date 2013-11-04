Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab3KDVJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 16:09:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab3KDVJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 16:09:52 -0500
Date: Mon, 4 Nov 2013 13:09:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] x86, mm: get ASLR work for hugetlb mappings
Message-Id: <20131104130951.44c20ed3d29395a3da57ad46@linux-foundation.org>
In-Reply-To: <20131104104152.72F91E0090@blue.fi.intel.com>
References: <1382449940-24357-1-git-send-email-kirill.shutemov@linux.intel.com>
	<20131104104152.72F91E0090@blue.fi.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  4 Nov 2013 12:41:52 +0200 (EET) "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> Kirill A. Shutemov wrote:
> > Matthew noticed that hugetlb doesn't participate in ASLR on x86-64.
> > The reason is genereic hugetlb_get_unmapped_area() which is used on
> > x86-64. It doesn't support randomization and use bottom-up unmapped area
> > lookup, instead of usual top-down on x86-64.
> > 
> > x86 has arch-specific hugetlb_get_unmapped_area(), but it's used only on
> > x86-32.
> > 
> > Let's use arch-specific hugetlb_get_unmapped_area() on x86-64 too.
> > It fixes the issue and make hugetlb use top-down unmapped area lookup.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Cc: Matthew Wilcox <willy@linux.intel.com>
> 
> Andrew, any comments?

whome?  I'm convinced, but it's an x86 patch.  I tossed it in there so
it gets a bit of linux-next exposure.

