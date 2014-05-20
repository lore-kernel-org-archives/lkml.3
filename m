Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaETHRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:17:11 -0400
Received: from ozlabs.org ([103.22.144.67]:42378 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbaETHRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:17:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org, x86@kernel.org,
        benh@kernel.crashing.org, paulus@samba.org, riel@redhat.com,
        mgorman@suse.de, ak@linux.intel.com, peterz@infradead.org,
        mingo@kernel.org, dave.hansen@intel.com
Subject: Re: [PATCH V4 0/2] mm: FAULT_AROUND_ORDER patchset performance data for powerpc
In-Reply-To: <20140520004429.E660AE009B@blue.fi.intel.com>
References: <1399541296-18810-1-git-send-email-maddy@linux.vnet.ibm.com> <537479E7.90806@linux.vnet.ibm.com> <alpine.LSU.2.11.1405151026540.4664@eggly.anvils> <87wqdik4n5.fsf@rustcorp.com.au> <53797511.1050409@linux.vnet.ibm.com> <alpine.LSU.2.11.1405191531150.1317@eggly.anvils> <20140519164301.eafd3dd288ccb88361ddcfc7@linux-foundation.org> <20140520004429.E660AE009B@blue.fi.intel.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 20 May 2014 15:52:07 +0930
Message-ID: <87oaythsvk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> writes:
> Andrew Morton wrote:
>> On Mon, 19 May 2014 16:23:07 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:
>> 
>> > Shouldn't FAULT_AROUND_ORDER and fault_around_order be changed to be
>> > the order of the fault-around size in bytes, and fault_around_pages()
>> > use 1UL << (fault_around_order - PAGE_SHIFT)
>> 
>> Yes.  And shame on me for missing it (this time!) at review.
>> 
>> There's still time to fix this.  Patches, please.
>
> Here it is. Made at 3.30 AM, build tested only.

Prefer on top of Maddy's patch which makes it always a variable, rather
than CONFIG_DEBUG_FS.  It's got enough hair as it is.

Cheers,
Rusty.
