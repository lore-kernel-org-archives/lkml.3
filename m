Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbbAZMLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:11:47 -0500
Received: from 8bytes.org ([81.169.241.247]:46097 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbbAZMLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:11:45 -0500
Date: Mon, 26 Jan 2015 13:11:42 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 3/3] x86, crash: Allocate enough low-mem when
 crashkernel=high
Message-ID: <20150126121142.GG30345@8bytes.org>
References: <1420555874-11506-1-git-send-email-joro@8bytes.org>
 <1420555874-11506-4-git-send-email-joro@8bytes.org>
 <20150123170243.GG22635@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123170243.GG22635@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 06:02:43PM +0100, Borislav Petkov wrote:
> On Tue, Jan 06, 2015 at 03:51:14PM +0100, Joerg Roedel wrote:
> > From: Joerg Roedel <jroedel@suse.de>
> > 
> > When the crashkernel is loaded above 4GiB in memory the
> > first kernel only allocates 72MiB of low-memory for the DMA
> > requirements of the second kernel. On systems with many
> > devices this is not enough and causes device driver
> > initialization errors and failed crash dumps. Set this
> > default value to 256MiB to make sure there is enough memory
> 
> This upper limit of 256 looks arbitrary. Are we going to raise it a
> couple of years from now if it becomes insufficient then?

Yes, it is arbitrary. I am open for suggestions on what might be a
proper value to satisfy most systems.

> It probably won't be easy but is there some more reliable way to
> allocate enough memory for DMA on a say per-system basis or whatever...?
> Probably not but let me ask it anyway.

Well, there is no easy way. But we could collect information from the
loaded drivers on boot about how many dma-memory they allocate and base
our allocation on that. Or we solve it in user-space by some more
cleverness in creating the kernel command-line for crashkernel=high.

But besides that, I think the first two patches of this set make sense
anyway. I understand that the third one is debatable.


	Joerg

