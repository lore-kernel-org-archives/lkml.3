Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab3HZMEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:04:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab3HZMEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:04:53 -0400
Date: Mon, 26 Aug 2013 15:04:45 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v2] tile: support KVM for tilegx
Message-ID: <20130826120445.GD8218@redhat.com>
References: <52091682.8020004@siemens.com>
 <201308122037.r7CKbo99011833@farm-0021.internal.tilera.com>
 <20130825113953.GN8218@redhat.com>
 <521AAED7.4080407@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521AAED7.4080407@tilera.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 25, 2013 at 09:26:47PM -0400, Chris Metcalf wrote:
> On 8/25/2013 7:39 AM, Gleb Natapov wrote:
> > On Mon, Aug 12, 2013 at 04:24:11PM -0400, Chris Metcalf wrote:
> >> This change provides the initial framework support for KVM on tilegx.
> >> Basic virtual disk and networking is supported.
> >>
> > This needs to be broken down to more reviewable patches.
> 
> I already broke out one pre-requisite patch that wasn't strictly KVM-related:
> 
> https://lkml.org/lkml/2013/8/12/339
> 
> In addition, we've separately arranged to support booting our kernels in a way that is compatible with the Tilera booter running at the highest privilege level, which enables multiple kernel privilege levels:
> 
> https://lkml.org/lkml/2013/5/2/468
> 
> How would you recommend further breaking down this patch?  It's pretty much just the basic support for minimal KVM.  I suppose I could break out all the I/O related stuff into a separate patch, though it wouldn't amount to much; perhaps the console could also be broken out separately.  Any other suggestions?
>
First of all please break out host and guest bits. Also I/O related stuff,
like you suggest (so that guest PV bits will be in separate patch) and
change to a common code (not much as far as I see) with explanation why
it is needed. (Why kvm_vcpu_kick() is not needed for instance?)
 
> > Also can you
> > describe the implementation a little bit? Does tile arch has vitalization
> > extension this implementation uses, or is it trap and emulate approach?
> > If later does it run unmodified guest kernels? What userspace are you
> > using with this implementation?
> 
> We could do full virtualization via trap and emulate, but we've elected to do a para-virtualized approach.  Userspace runs at PL (privilege level) 0, the guest kernel runs at PL1, and the host runs at PL2.  We have available per-PL resources for various things, and take advantage of having two on-chip timers (for example) to handle timing for the host and guest kernels.  We run the same userspace with either the host or the guest.
> 
OK, thanks for explanation. Why have you decided to do PV over trap and
emulate?

--
			Gleb.
