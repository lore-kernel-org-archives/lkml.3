Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaBGRcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:32:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:51364 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbaBGRcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:32:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,802,1384329600"; 
   d="scan'208";a="479748325"
Date: Fri, 7 Feb 2014 09:32:00 -0800
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
Message-ID: <20140207173200.GC12219@tassilo.jf.intel.com>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
 <CA+55aFxpBkTn3LvSzxFj7ZoxuY=Rrg0OoAVuk5dK-ZLsO8kk4A@mail.gmail.com>
 <20140206005534.GA27848@node.dhcp.inet.fi>
 <CA+55aFx70seh4VD+=ZKHrjTCrinG0Hq3=X6ygCeOeuNCSG8n8Q@mail.gmail.com>
 <CA+55aFwfGVCVouh5uap3UPy92vc4N9OrRRa-NpYT9ZMicU6w8w@mail.gmail.com>
 <CA+55aFyq31f=30YeRbZbqgBFp13Zdk=Gb-UiLRqeR48MOfVwag@mail.gmail.com>
 <20140206222450.GA8823@node.dhcp.inet.fi>
 <CA+55aFysEbwfzJxVbZY6X+eEZ5KSgO5b8-S_a=-nrLj0sQfecA@mail.gmail.com>
 <20140207154232.GA18611@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207154232.GA18611@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I haven't tested it much, but my kvm boots. There're few places where code
> should be fixed. __do_fault() and filemap_fault() are too ugly and need to
> be cleaned.
> 
> I don't have any performance data yet.
> 
> Any thoughts?

It seems very drastic to do it unconditionally. How about at least a simple
stream detection heuristic and perhaps also madvise?

There are some extreme cases where workloads could use a lot more memory
than before, if they access their memory sparsely in the right pattern.

-Andi
