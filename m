Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab3KFAmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 19:42:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab3KFAmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 19:42:18 -0500
Date: Tue, 5 Nov 2013 16:43:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] mm: create a separate slab for page->ptl allocation
Message-Id: <20131105164351.b2c63109.akpm@linux-foundation.org>
In-Reply-To: <20131105231310.GE20167@shutemov.name>
References: <1382442839-7458-1-git-send-email-kirill.shutemov@linux.intel.com>
	<20131105150145.734a5dd5b5d455800ebfa0d3@linux-foundation.org>
	<20131105224217.GC20167@shutemov.name>
	<20131105155619.021f32eba1ca8f15a73ed4c9@linux-foundation.org>
	<20131105231310.GE20167@shutemov.name>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013 01:13:11 +0200 "Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> > Really the function shouldn't exist in this case.  It is __init so the
> > sin is not terrible, but can this be arranged?
> 
> I would like to get rid of __ptlock_alloc()/__ptlock_free() too, but I
> don't see a way within C: we need to know sizeof(spinlock_t) on
> preprocessor stage.
> 
> We can have a hack on kbuild level: write small helper program to find out
> sizeof(spinlock_t) before start building and turn it into define.
> But it's overkill from my POV. And cross-compilation will be a fun.

Yes, it doesn't seem worth the fuss.  The compiler will remove all this
code anyway, so for example ptlock_cache_init() becomes an empty function.
