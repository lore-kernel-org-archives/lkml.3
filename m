Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab3H1KB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 06:01:28 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41257 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752565Ab3H1KB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 06:01:27 -0400
Date: Wed, 28 Aug 2013 12:01:22 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Baruch Siach <baruch@tkos.co.il>,
        Will Deacon <Will.Deacon@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4 2/4] ARM: Add atomic_io_modify optimized routines
Message-ID: <20130828120122.487e6ed6@skate>
In-Reply-To: <20130828094907.GB2343@localhost>
References: <1377358532-23802-1-git-send-email-ezequiel.garcia@free-electrons.com>
	<1377358532-23802-3-git-send-email-ezequiel.garcia@free-electrons.com>
	<20130828085340.GB58219@MacBook-Pro.local>
	<20130828094907.GB2343@localhost>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Ezequiel Garcia,

On Wed, 28 Aug 2013 06:49:08 -0300, Ezequiel Garcia wrote:

> > Is this any different from the generic one introduced in patch 1/4? I
> > would rather just use the generic definition.
> 
> Well, according to Will Deacon (and as documented in the commit log)
> we can optimize in ARM by using readl_relaxed instead of readl.
> 
> Now, I'm sure you now better than me if that results (or not) in any
> significant optimization.
> 
> > Similarly, a generic
> > atomic_io_modify_relaxed() but guarded with something like
> > __HAVE_ARCH_RELAXED_IO.
> > 
> 
> No, that's not possible. As far as I understand, there's no guarantee
> of _relaxed variants to be available architecture-wide.

I think what Catalin was suggesting is that atomic_io_modify() should
use readl() and writel() (i.e *not* the relaxed variants), and that a
separate atomic_io_modify_relaxed() could be added on architectures
that define __HAVE_ARCH_RELAXED_IO.

I think you misread Catalin's comment when you say there's no guarantee
of _relaxed variants to be available architecture-wide, since Catalin
precisely suggested to guard that with __HAVE_ARCH_RELAXED_IO, which
indicates that _relaxed variants are available.

Thanks,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
