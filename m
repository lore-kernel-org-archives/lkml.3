Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbaA0RCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:02:41 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50044 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753970AbaA0RCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:02:39 -0500
Date: Mon, 27 Jan 2014 17:02:31 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Q] block / zynq: DMA bouncing
Message-ID: <20140127170230.GQ15937@n2100.arm.linux.org.uk>
References: <Pine.LNX.4.64.1401271549280.23931@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1401271549280.23931@axis700.grange>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 04:13:56PM +0100, Guennadi Liakhovetski wrote:
> I'm working on an MMC driver with a DMA capability. All has been working 
> well, until at some point I've got a bus error, when the mmc driver had 
> been handed in a buffer at 0x3000 physical RAM address. The reason is, 
> that on Zynq arch bus masters cannot access RAM below 0x80000. Therefore 
> my question: how shall I configure this in software?

You're going to run into all sorts of problems here.  Normally, the
DMA-able memory is limited to the first N bytes of memory, not "you must
avoid the first N bytes of memory".

Linux has it hard-coded into the memory subsystems that the DMA zone
is from the start of memory to N, the normal zone is from N to H, and
high memory is from H upwards - and allocations for high can fall back
to normal, which can fall back to DMA but not the other way around.

Short of permanently reserving the first 0x80000 bytes of memory, I'm
not sure that there's much which can be done.  You may wish to talk to
the MM gurus to see whether there's a modern alternative.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
