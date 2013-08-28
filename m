Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab3H1Lk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 07:40:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62911 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752855Ab3H1LkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 07:40:25 -0400
Date: Wed, 28 Aug 2013 12:39:18 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Baruch Siach <baruch@tkos.co.il>,
        Will Deacon <Will.Deacon@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4 2/4] ARM: Add atomic_io_modify optimized routines
Message-ID: <20130828113918.GB58575@MacBook-Pro.local>
References: <1377358532-23802-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <1377358532-23802-3-git-send-email-ezequiel.garcia@free-electrons.com>
 <20130828085340.GB58219@MacBook-Pro.local>
 <20130828094907.GB2343@localhost>
 <20130828120122.487e6ed6@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828120122.487e6ed6@skate>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 11:01:22AM +0100, Thomas Petazzoni wrote:
> Dear Ezequiel Garcia,
> 
> On Wed, 28 Aug 2013 06:49:08 -0300, Ezequiel Garcia wrote:
> 
> > > Is this any different from the generic one introduced in patch 1/4? I
> > > would rather just use the generic definition.
> > 
> > Well, according to Will Deacon (and as documented in the commit log)
> > we can optimize in ARM by using readl_relaxed instead of readl.
> > 
> > Now, I'm sure you now better than me if that results (or not) in any
> > significant optimization.
> > 
> > > Similarly, a generic
> > > atomic_io_modify_relaxed() but guarded with something like
> > > __HAVE_ARCH_RELAXED_IO.
> > > 
> > 
> > No, that's not possible. As far as I understand, there's no guarantee
> > of _relaxed variants to be available architecture-wide.
> 
> I think what Catalin was suggesting is that atomic_io_modify() should
> use readl() and writel() (i.e *not* the relaxed variants), and that a
> separate atomic_io_modify_relaxed() could be added on architectures
> that define __HAVE_ARCH_RELAXED_IO.
> 
> I think you misread Catalin's comment when you say there's no guarantee
> of _relaxed variants to be available architecture-wide, since Catalin
> precisely suggested to guard that with __HAVE_ARCH_RELAXED_IO, which
> indicates that _relaxed variants are available.

Indeed, thanks for the translation ;).

-- 
Catalin
