Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbaLBOlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:41:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37406 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbaLBOld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:41:33 -0500
Date: Tue, 2 Dec 2014 15:41:22 +0100
From: Joerg Roedel <jroedel@suse.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] swiotlb: Warn on allocation failure in
 swiotlb_alloc_coherent
Message-ID: <20141202144122.GI3156@suse.de>
References: <1417174149-31210-1-git-send-email-joro@8bytes.org>
 <1417174149-31210-2-git-send-email-joro@8bytes.org>
 <20141201202802.GC21626@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201202802.GC21626@laptop.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 03:28:03PM -0500, Konrad Rzeszutek Wilk wrote:
> On Fri, Nov 28, 2014 at 12:29:07PM +0100, Joerg Roedel wrote:
> > From: Joerg Roedel <jroedel@suse.de>
> > 
> > Print a warning when all allocation tries have been failed
> > and the function is about to return NULL. This prepares for
> > calling the function with __GFP_NOWARN to suppress
> > allocation failure warnings before all fall-backs have
> > failed.
> 
> This can be quite noisy. Especially the dump-stack.

Well, this is as noisy as the dump_stack()s from the page-allocator when
the first allocation try fails. The goal of the first two patches in
this series is to only print a warning (with stack-trace) when
alloc_coherent failed, and not when only an intermediate step failed
that has a fall-back anyway (and might thus be no real problem).


	Joerg

