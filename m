Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbbABCCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 21:02:52 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:46120 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbbABCCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 21:02:50 -0500
Date: Thu, 1 Jan 2015 18:02:32 -0800
From: Darren Hart <dvhart@infradead.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        platform-driver-x86@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] x86: Add IMR support to Quark/Galileo
Message-ID: <20150102020232.GA51121@vmdeb7>
References: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie>
 <CAHp75VcRmm3raZ8juLJJOyuDpuxLLg44UHNprwQ=b2hhvqHOsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VcRmm3raZ8juLJJOyuDpuxLLg44UHNprwQ=b2hhvqHOsA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 12:12:58PM +0200, Andy Shevchenko wrote:
> On Mon, Dec 29, 2014 at 7:23 PM, Bryan O'Donoghue
> <pure.logic@nexus-software.ie> wrote:
> > This patchset adds an IMR driver to the kernel plus platform code for
> > Intel Galileo Gen1/Gen2 boards.
> 
> []
> 
> > Bryan O'Donoghue (2):
> >   x86: Add Isolated Memory Regions for Quark X1000
> >   platform/x86 Add Intel Galileo platform specific setup
> 
> I'm going to review this soon, but here few comments below.

Thanks for your review Andy, good advice throughout.

> 
> >  arch/x86/Kconfig                     |  23 ++
> >  arch/x86/include/asm/imr.h           |  79 ++++++
> >  arch/x86/include/asm/intel-quark.h   |  31 ++
> 
> Could it be just a quark.h? Like for ce4100.
> Those intel- prefixes in the modules looks awkward especially when
> pathname consists x86 already.
> 
> >  arch/x86/kernel/Makefile             |   1 +
> >  arch/x86/kernel/imr.c                | 529 +++++++++++++++++++++++++++++++++++
> >  drivers/platform/x86/Kconfig         |  15 +
> >  drivers/platform/x86/Makefile        |   1 +
> >  drivers/platform/x86/intel_galileo.c | 175 ++++++++++++
> 
> Here what about to make an hierarchy like:
> intel/galileo.c
> intel/mid/... would be those modules with intel_mid_ prefixes in
> future. See my proposal regarding to drivers/mfd [1]

As Bryan is only adding one file to the platform/drivers/x86, let's skip the
reorg as part of this patch series. We can consider that separately if someone
wants to make the argument that the time has come to add another directory
layer.

-- 
Darren Hart
Intel Open Source Technology Center
