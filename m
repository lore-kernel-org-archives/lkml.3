Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaEUUeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 16:34:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaEUUeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 16:34:10 -0400
Date: Wed, 21 May 2014 13:34:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Hugh Dickins <hughd@google.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org, x86@kernel.org,
        benh@kernel.crashing.org, paulus@samba.org, riel@redhat.com,
        mgorman@suse.de, ak@linux.intel.com, peterz@infradead.org,
        mingo@kernel.org, dave.hansen@intel.com
Subject: Re: [PATCH V4 0/2] mm: FAULT_AROUND_ORDER patchset performance data
 for powerpc
Message-Id: <20140521133408.4d2f1a551e9652fb0e12265f@linux-foundation.org>
In-Reply-To: <20140521134027.263DDE009B@blue.fi.intel.com>
References: <1399541296-18810-1-git-send-email-maddy@linux.vnet.ibm.com>
	<537479E7.90806@linux.vnet.ibm.com>
	<alpine.LSU.2.11.1405151026540.4664@eggly.anvils>
	<87wqdik4n5.fsf@rustcorp.com.au>
	<53797511.1050409@linux.vnet.ibm.com>
	<alpine.LSU.2.11.1405191531150.1317@eggly.anvils>
	<20140519164301.eafd3dd288ccb88361ddcfc7@linux-foundation.org>
	<20140520004429.E660AE009B@blue.fi.intel.com>
	<87oaythsvk.fsf@rustcorp.com.au>
	<20140520102738.7F096E009B@blue.fi.intel.com>
	<20140520125956.aa61a3bfd84d4d6190740ce2@linux-foundation.org>
	<20140521134027.263DDE009B@blue.fi.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2014 16:40:27 +0300 (EEST) "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> > Or something.  Can we please get some code commentary over
> > do_fault_around() describing this design decision and explaining the
> > reasoning behind it?
> 
> I'll do this. But if do_fault_around() rework is needed, I want to do that
> first.

This sort of thing should be at least partially driven by observation
and I don't have the data for that.  My seat of the pants feel is that
after the first fault, accesses at higher addresses are more
common/probable than accesses at lower addresses.  In which case we
should see improvements by centering the window at some higher address
than the fault.  Much instrumentation and downstream analysis is needed
and the returns will be pretty small!

But we don't need to do all that right now.  Let's get the current
implementation wrapped up for 3.15: get the interface finalized (bytes,
not pages!) and get the current design decisions appropriately
documented.
