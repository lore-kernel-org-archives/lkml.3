Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab3J1LCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 07:02:16 -0400
Received: from mout.gmx.net ([212.227.17.22]:53445 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442Ab3J1LCO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 07:02:14 -0400
Date: Mon, 28 Oct 2013 12:02:09 +0100
From: Andreas Werner <wernerandy@gmx.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, dave@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: MM: Add PAT Type write-through in combination with
 mtrr
Message-ID: <20131028110209.GC2278@thinkpad.fritz.box>
References: <20131027165159.GD1617@thinkpad.fritz.box>
 <20131027173131.GC21868@pd.tnic>
 <20131027175608.GA1340@thinkpad.fritz.box>
 <20131027190148.GD21868@pd.tnic>
 <20131028062946.GA1391@thinkpad.fritz.box>
 <20131028101749.GA4389@gmail.com>
 <20131028102938.GD4314@pd.tnic>
 <20131028103132.GA6274@gmail.com>
 <20131028104505.GB2278@thinkpad.fritz.box>
 <20131028105101.GC6274@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131028105101.GC6274@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:nUYs+I2tgxC0TWoxXSGR81fng7IxVj7wjT0PH7Izcyl9lCd6S2h
 mrl81WCWwRhVL9eLHT/He3vXow/kH/gTIt1Dnzlelb28g66yPR38Tooyi9qx1CglcfmDI/T
 425/crosVOSLGt0elbXAZgaj9pI1T942z+DpuDrrOwcOg+pz0fqQs2++aHJN+PW5I91H06Y
 ip4jrYyovKSqJKsWRhqmw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 11:51:01AM +0100, Ingo Molnar wrote:
> 
> * Andreas Werner <wernerandy@gmx.de> wrote:
> 
> > On Mon, Oct 28, 2013 at 11:31:32AM +0100, Ingo Molnar wrote:
> > > 
> > > * Borislav Petkov <bp@alien8.de> wrote:
> > > 
> > > > On Mon, Oct 28, 2013 at 11:17:49AM +0100, Ingo Molnar wrote:
> > > >
> > > > > And regular write-back cacheable isn't sufficient because the 
> > > > > CPU could do things like prefetch your range automatically?
> > > > 
> > > > Yeah, he's doing a CLFLUSH anyway which basically makes it a 
> > > > write-through...
> > > 
> > > The CLFLUSH is done afterwards (making it a use-once thing), so WB 
> > > might still be faster and would avoid the PAT headache ...
> > > 
> > > Thanks,
> > > 
> > > 	Ingo
> > What i do right now is:
> > 1. clflush the data range to read from my mmio device
> > 2. read the data.
> > On PCIe Tracer i see the pcie  bursts.
> > 
> > If i mark the region WB and call clflush my system will crash without
> > any message, it just stop working.
> 
> Yeah, I was wondering whether it's valid at all to mark IO memory as 
> cacheable - with the lack of MESI transactions and all that ...
> 
> So it's apparently not valid and we've got to live with WT as the 
> 'best' caching/bursting method for reads.
> 
> Thanks,
> 
> 	Ingo

Yeah, as you can see in the link i´ve posted before, the guy who
did the post mentioned also that WB on MMIO is not valid, he said
"id could work on some CPUs", and therefore he decided to do it
like I with WC (write) and WT (read).

regards Andy
