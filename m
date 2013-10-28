Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab3J1KvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:51:07 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:63678 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab3J1KvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:51:05 -0400
Date: Mon, 28 Oct 2013 11:51:01 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andreas Werner <wernerandy@gmx.de>
Cc: Borislav Petkov <bp@alien8.de>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, dave@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: MM: Add PAT Type write-through in combination with
 mtrr
Message-ID: <20131028105101.GC6274@gmail.com>
References: <20131027133401.GB24817@pd.tnic>
 <20131027165159.GD1617@thinkpad.fritz.box>
 <20131027173131.GC21868@pd.tnic>
 <20131027175608.GA1340@thinkpad.fritz.box>
 <20131027190148.GD21868@pd.tnic>
 <20131028062946.GA1391@thinkpad.fritz.box>
 <20131028101749.GA4389@gmail.com>
 <20131028102938.GD4314@pd.tnic>
 <20131028103132.GA6274@gmail.com>
 <20131028104505.GB2278@thinkpad.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028104505.GB2278@thinkpad.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Werner <wernerandy@gmx.de> wrote:

> On Mon, Oct 28, 2013 at 11:31:32AM +0100, Ingo Molnar wrote:
> > 
> > * Borislav Petkov <bp@alien8.de> wrote:
> > 
> > > On Mon, Oct 28, 2013 at 11:17:49AM +0100, Ingo Molnar wrote:
> > >
> > > > And regular write-back cacheable isn't sufficient because the 
> > > > CPU could do things like prefetch your range automatically?
> > > 
> > > Yeah, he's doing a CLFLUSH anyway which basically makes it a 
> > > write-through...
> > 
> > The CLFLUSH is done afterwards (making it a use-once thing), so WB 
> > might still be faster and would avoid the PAT headache ...
> > 
> > Thanks,
> > 
> > 	Ingo
> What i do right now is:
> 1. clflush the data range to read from my mmio device
> 2. read the data.
> On PCIe Tracer i see the pcie  bursts.
> 
> If i mark the region WB and call clflush my system will crash without
> any message, it just stop working.

Yeah, I was wondering whether it's valid at all to mark IO memory as 
cacheable - with the lack of MESI transactions and all that ...

So it's apparently not valid and we've got to live with WT as the 
'best' caching/bursting method for reads.

Thanks,

	Ingo
