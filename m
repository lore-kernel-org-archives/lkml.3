Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbaBGR5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:57:12 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:43428 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbaBGR5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:57:11 -0500
Date: Fri, 7 Feb 2014 19:56:22 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andi Kleen <ak@linux.intel.com>
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
Message-ID: <20140207175622.GA14953@node.dhcp.inet.fi>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
 <CA+55aFxpBkTn3LvSzxFj7ZoxuY=Rrg0OoAVuk5dK-ZLsO8kk4A@mail.gmail.com>
 <20140206005534.GA27848@node.dhcp.inet.fi>
 <CA+55aFx70seh4VD+=ZKHrjTCrinG0Hq3=X6ygCeOeuNCSG8n8Q@mail.gmail.com>
 <CA+55aFwfGVCVouh5uap3UPy92vc4N9OrRRa-NpYT9ZMicU6w8w@mail.gmail.com>
 <CA+55aFyq31f=30YeRbZbqgBFp13Zdk=Gb-UiLRqeR48MOfVwag@mail.gmail.com>
 <20140206222450.GA8823@node.dhcp.inet.fi>
 <CA+55aFysEbwfzJxVbZY6X+eEZ5KSgO5b8-S_a=-nrLj0sQfecA@mail.gmail.com>
 <20140207154232.GA18611@node.dhcp.inet.fi>
 <20140207173200.GC12219@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207173200.GC12219@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 09:32:00AM -0800, Andi Kleen wrote:
> > I haven't tested it much, but my kvm boots. There're few places where code
> > should be fixed. __do_fault() and filemap_fault() are too ugly and need to
> > be cleaned.
> > 
> > I don't have any performance data yet.
> > 
> > Any thoughts?
> 
> It seems very drastic to do it unconditionally. How about at least a simple
> stream detection heuristic and perhaps also madvise?

We already have readahead here it can be reused here. But see below.

> There are some extreme cases where workloads could use a lot more memory
> than before, if they access their memory sparsely in the right pattern.

Have you noticied that we don't actually allocate any memory: only reuse
what's already there. Sure, it will increase VmSize, but do we care?

-- 
 Kirill A. Shutemov
