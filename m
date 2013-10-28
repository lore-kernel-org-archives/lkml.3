Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab3J1Keg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:34:36 -0400
Received: from mout.gmx.net ([212.227.17.20]:49690 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755716Ab3J1Kef convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:34:35 -0400
Date: Mon, 28 Oct 2013 11:34:28 +0100
From: Andreas Werner <wernerandy@gmx.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, dave@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: MM: Add PAT Type write-through in combination with
 mtrr
Message-ID: <20131028103428.GA2278@thinkpad.fritz.box>
References: <1382878525-3410-1-git-send-email-wernerandy@gmx.de>
 <20131027133401.GB24817@pd.tnic>
 <20131027165159.GD1617@thinkpad.fritz.box>
 <20131027173131.GC21868@pd.tnic>
 <20131027175608.GA1340@thinkpad.fritz.box>
 <20131027190148.GD21868@pd.tnic>
 <20131028062946.GA1391@thinkpad.fritz.box>
 <20131028101749.GA4389@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131028101749.GA4389@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:CHNhBEKzynj2BHc7i08dUzlQRdDRxKareGVFWTtqmb6WpgDWAKn
 Xxkdnlnwjad3cP6Q7GSNt7K5zdkcC77b4fkBGzi8xbEClE7XPnntDWQq3rXp2yOnMdC0Fxs
 JpHqvGE1hXFg1AZLj95ChSNU3uKNxMI0SzoVYUg8c6tpNqWCbjU1n2UOd5cMz/9xTVVAHag
 /4J/CZUZrkJ79H+wt+tpA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 11:17:49AM +0100, Ingo Molnar wrote:
> 
> * Andreas Werner <wernerandy@gmx.de> wrote:
> 
> > > IOW, you probably could use a WC buffer here too, as it would 
> > > combine the writes coming from the FPGA.
> > > 
> > > Btw, there's also mtrr_add(..., MTRR_TYPE_WRTHROUGH, ) if you 
> > > must use a WT thing. Have you tried that?
> > 
> > For reading i need to map the mmio with attributes that allow 
> > cache-line read. Therefore i use WT. For the Virtual address i use 
> > ioremap_cache in combination with this patch to get an effective 
> > memory type of "Write-Through". This allows me to read from the 
> > mmio with "PCIe burst". The write behaviour to this region do not 
> > matter.
> 
> And regular write-back cacheable isn't sufficient because the CPU 
> could do things like prefetch your range automatically?
> 
> If the reads are for packet data and not for commands, WB could 
> still be beneficial as it should allow even higher bandwidth. (For 
> non-data with real semantics WB is probably not good.)
> 
> Thanks,
> 
> 	Ingo

Yes the reads are only for packet data, the commands or configuration
registers are mapped non cachable.

I´ve tried WB, but on PCIe Tracer i could not see any burst access.
Thats the reason why i have created this patch.

Is there a chance to get this patch into the kernel? Or
is this solution so special?

Regards
Andy
