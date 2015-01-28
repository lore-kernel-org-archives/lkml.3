Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbbA1UZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:25:12 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:53687 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbbA1UZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:25:07 -0500
Date: Wed, 28 Jan 2015 16:25:04 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Paul Bolle <pebolle@tiscali.nl>
cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: arm64: USB_ARCH_HAS_EHCI
In-Reply-To: <1422438405.5666.16.camel@x220>
Message-ID: <alpine.DEB.2.02.1501281621330.19947@utopia.booyaka.com>
References: <1422351833.14015.20.camel@x220>  <alpine.DEB.2.02.1501272130470.19947@utopia.booyaka.com> <1422438405.5666.16.camel@x220>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2015, Paul Bolle wrote:

> On Tue, 2015-01-27 at 21:31 +0000, Paul Walmsley wrote:
> > On Tue, 27 Jan 2015, Paul Bolle wrote:
> > 
> > > Your commit d035fdfa27ac ("arm64: Add Tegra132 support") is included in
> > > today's linux-next (ie, next-20150127). I noticed because a script I use
> > > to check linux-next spotted a minor problem with it.
> > > 
> > > It adds a select for the Kconfig symbol USB_ARCH_HAS_EHCI. That Kconfig
> > > was obsoleted in v3.11 and removed in v3.15. See commit b797b76fb464
> > > ("usb: host: remove USB_ARCH_HAS_?HCI"). That select is now a nop.
> > > 
> > > Should I submit the trivial patch to remove that line or do you prefer
> > > to do that yourself?
> > 
> > Thanks, I'll post a new version.
> 
> I just noticed that your commit added another unneeded select. The entry
> for ARCH_TEGRA selects HAVE_SMP, but HAVE_SMP is only available on arm
> or xtensa. There's no point in selecting it in arm64.

OK thanks, will roll that in.  Looks like Thierry's already sent a pull 
request for the original patch, so I'll probably just send a follow-up.

Is the Kconfig checker script you mentioned on Tuesday available in the 
mainline tree?  I don't see anything obvious under the "Static Analysers" 
section of the Makefile, but perhaps I'm overlooking it.


- Paul
