Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab3J0TBw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 15:01:52 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50872 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427Ab3J0TBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 15:01:51 -0400
Date: Sun, 27 Oct 2013 20:01:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andreas Werner <wernerandy@gmx.de>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        dave@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: MM: Add PAT Type write-through in combination with
 mtrr
Message-ID: <20131027190148.GD21868@pd.tnic>
References: <1382878525-3410-1-git-send-email-wernerandy@gmx.de>
 <20131027133401.GB24817@pd.tnic>
 <20131027165159.GD1617@thinkpad.fritz.box>
 <20131027173131.GC21868@pd.tnic>
 <20131027175608.GA1340@thinkpad.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131027175608.GA1340@thinkpad.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 06:56:08PM +0100, Andreas Werner wrote:
> Transmit Buffers WC (only write to that buffer)
> i have PICe bursts on my tracer.

For that you can do ioremap_wc().

> Receive Buffers WT (only read to that buffer). I use
> clflush_cache_range before reading from that adresses and i have PCIe
> bursts on my tracer.

That one I don't understand - why would you need a WT buffer? It only
caches reads but you will read from it only once after it has been
received. Why pollute the cache?

IOW, you probably could use a WC buffer here too, as it would combine
the writes coming from the FPGA.

Btw, there's also mtrr_add(..., MTRR_TYPE_WRTHROUGH, ) if you must use a
WT thing. Have you tried that?

> With UC memory there are no PCIe bursts and my bandwidth is very slow.

Right.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
