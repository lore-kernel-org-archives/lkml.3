Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbaBGSOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 13:14:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:62047 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbaBGSN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 13:13:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,802,1384329600"; 
   d="scan'208";a="451511214"
Date: Fri, 7 Feb 2014 10:11:39 -0800
From: Andi Kleen <ak@linux.intel.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ning Qu <quning@google.com>, Dave Hansen <dave.hansen@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [RFC, PATCH] mm: map few pages around fault address if they are
 in page cache
Message-ID: <20140207181139.GD12219@tassilo.jf.intel.com>
References: <CA+55aFxpBkTn3LvSzxFj7ZoxuY=Rrg0OoAVuk5dK-ZLsO8kk4A@mail.gmail.com>
 <20140206005534.GA27848@node.dhcp.inet.fi>
 <CA+55aFx70seh4VD+=ZKHrjTCrinG0Hq3=X6ygCeOeuNCSG8n8Q@mail.gmail.com>
 <CA+55aFwfGVCVouh5uap3UPy92vc4N9OrRRa-NpYT9ZMicU6w8w@mail.gmail.com>
 <CA+55aFyq31f=30YeRbZbqgBFp13Zdk=Gb-UiLRqeR48MOfVwag@mail.gmail.com>
 <20140206222450.GA8823@node.dhcp.inet.fi>
 <CA+55aFysEbwfzJxVbZY6X+eEZ5KSgO5b8-S_a=-nrLj0sQfecA@mail.gmail.com>
 <20140207154232.GA18611@node.dhcp.inet.fi>
 <20140207173200.GC12219@tassilo.jf.intel.com>
 <20140207175622.GA14953@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207175622.GA14953@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > There are some extreme cases where workloads could use a lot more memory
> > than before, if they access their memory sparsely in the right pattern.
> 
> Have you noticied that we don't actually allocate any memory: only reuse
> what's already there. Sure, it will increase VmSize, but do we care?

Good point. With that probably readahead is overkill, agree.

We would need it though if we ever do it for anonymous.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
