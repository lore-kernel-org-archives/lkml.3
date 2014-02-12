Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaBLKh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:37:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32867 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbaBLKhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:37:23 -0500
Date: Wed, 12 Feb 2014 11:37:13 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: Another preempt folding issue?
Message-ID: <20140212103713.GE3545@laptop.programming.kicks-ass.net>
References: <52FA6D4B.7020709@canonical.com>
 <20140211194553.GZ9987@twins.programming.kicks-ass.net>
 <52FB2EC8.4080602@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FB2EC8.4080602@canonical.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 09:20:24AM +0100, Stefan Bader wrote:
> On 11.02.2014 20:45, Peter Zijlstra wrote:
> > On Tue, Feb 11, 2014 at 07:34:51PM +0100, Stefan Bader wrote:
> >> Hi Peter,
> >>
> >> I am currently looking at a weird issue that manifest itself when trying to run
> >> kvm enabled qemu on a i386 host (v3.13 kernel, oh and potentially important the
> >> cpu is 64bit capable, so qemu-system-x86_64 is called). 
> > 
> > AMD or Intel machine?
> 
> Personally I am reproducing this on an AMD:
> 
> cpu family	: 15
> model		: 72
> model name	: AMD Turion(tm) 64 X2 Mobile Technology TL-64
> 
> but the reports I got are showing the same issue on an Intel i7
> 
> cpu family	: 6
> model		: 37
> model name	: Intel(R) Core(TM) i7 CPU       M 620  @ 2.67GH
> 
> Another reporter also saw this on an AMD and said it could not be reproduced on
> the same hardware and the same software versions when using 64bit instead of 32.
> 
> In my case on a 32bit installation I will see this on every invocation of

Curious.. so its both AMD and Intel.

That makes funny hardware less likely... but how can the vmexit loose an
interrupt like this.


