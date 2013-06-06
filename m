Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab3FFEVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 00:21:48 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:34179 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3FFEVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 00:21:46 -0400
Date: Thu, 6 Jun 2013 00:21:43 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] ARM: avoid mis-detecting some V7 cores in the
 decompressor
In-Reply-To: <20130606012921.GO599@codeaurora.org>
Message-ID: <alpine.LFD.2.03.1306060019280.18597@syhkavp.arg>
References: <51AD0703.6050408@codeaurora.org> <20130603222321.GP18614@n2100.arm.linux.org.uk> <51AD1AB3.9050908@codeaurora.org> <20130603224555.GR18614@n2100.arm.linux.org.uk> <51AD1FE9.80709@codeaurora.org> <alpine.LFD.2.03.1306040032510.1200@syhkavp.arg>
 <20130604194705.GK599@codeaurora.org> <alpine.LFD.2.03.1306041559440.1200@syhkavp.arg> <20130604214501.GL599@codeaurora.org> <alpine.LFD.2.03.1306041751470.1200@syhkavp.arg> <20130606012921.GO599@codeaurora.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jun 2013, Stephen Boyd wrote:

> On 06/04, Nicolas Pitre wrote:
> > 
> > The LC0 area should be considered read-only as it may be located in 
> > flash.
> > 
> > Here's what I came with instead:
> > 
> > From: Nicolas Pitre <nicolas.pitre@linaro.org>
> > Date: Tue, 4 Jun 2013 17:01:30 -0400
> > Subject: [PATCH] ARM: zImage: don't overwrite ourself with a page table
> > 
> > When zImage is loaded into RAM at a low address but TEXT_OFFSET
> > is set higher, we risk overwriting ourself with the page table
> > needed to turn on the cache as it is located relative to the relocation
> > address.  Let's defer the cache setup after relocation in that case.
> > 
> > Signed-off-by: Nicolas Pitre <nico@linaro.org>
> 
> Reported-by: Stephen Boyd <sboyd@codeurora.org>
> Tested-by: Stephen Boyd <sboyd@codeurora.org>
> 
> This one passes testing on my two platforms with and without the
> 2Mb reservation at the beginning of ram. Seems like a good enough
> compromise for me.

Good!  Queued here:

http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7751/1


Nicolas
