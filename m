Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab3J1KRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:17:54 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:56088 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab3J1KRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:17:52 -0400
Date: Mon, 28 Oct 2013 11:17:49 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andreas Werner <wernerandy@gmx.de>
Cc: Borislav Petkov <bp@alien8.de>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, dave@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: MM: Add PAT Type write-through in combination with
 mtrr
Message-ID: <20131028101749.GA4389@gmail.com>
References: <1382878525-3410-1-git-send-email-wernerandy@gmx.de>
 <20131027133401.GB24817@pd.tnic>
 <20131027165159.GD1617@thinkpad.fritz.box>
 <20131027173131.GC21868@pd.tnic>
 <20131027175608.GA1340@thinkpad.fritz.box>
 <20131027190148.GD21868@pd.tnic>
 <20131028062946.GA1391@thinkpad.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028062946.GA1391@thinkpad.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Werner <wernerandy@gmx.de> wrote:

> > IOW, you probably could use a WC buffer here too, as it would 
> > combine the writes coming from the FPGA.
> > 
> > Btw, there's also mtrr_add(..., MTRR_TYPE_WRTHROUGH, ) if you 
> > must use a WT thing. Have you tried that?
> 
> For reading i need to map the mmio with attributes that allow 
> cache-line read. Therefore i use WT. For the Virtual address i use 
> ioremap_cache in combination with this patch to get an effective 
> memory type of "Write-Through". This allows me to read from the 
> mmio with "PCIe burst". The write behaviour to this region do not 
> matter.

And regular write-back cacheable isn't sufficient because the CPU 
could do things like prefetch your range automatically?

If the reads are for packet data and not for commands, WB could 
still be beneficial as it should allow even higher bandwidth. (For 
non-data with real semantics WB is probably not good.)

Thanks,

	Ingo
