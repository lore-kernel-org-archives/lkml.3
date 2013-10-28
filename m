Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab3J1KpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:45:19 -0400
Received: from mout.gmx.net ([212.227.17.20]:53373 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980Ab3J1KpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:45:10 -0400
Date: Mon, 28 Oct 2013 11:45:05 +0100
From: Andreas Werner <wernerandy@gmx.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, dave@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: MM: Add PAT Type write-through in combination with
 mtrr
Message-ID: <20131028104505.GB2278@thinkpad.fritz.box>
References: <1382878525-3410-1-git-send-email-wernerandy@gmx.de>
 <20131027133401.GB24817@pd.tnic>
 <20131027165159.GD1617@thinkpad.fritz.box>
 <20131027173131.GC21868@pd.tnic>
 <20131027175608.GA1340@thinkpad.fritz.box>
 <20131027190148.GD21868@pd.tnic>
 <20131028062946.GA1391@thinkpad.fritz.box>
 <20131028101749.GA4389@gmail.com>
 <20131028102938.GD4314@pd.tnic>
 <20131028103132.GA6274@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028103132.GA6274@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:cBgFcVeHiLk/s0Cqe+RvvXi67s44Hy0iiqyRKPq0NReJQEsuiau
 0qU6a9AOcQrfJI9WflXDjbke/1dGJxj7mSRx0xvwGwyi8gs2ZkqW/27UGtY9SAiLnendman
 1hdKCNFa9phKyQya2YB6hQa5gZtRHXTS4ro9+mJH0+LP0X/7HgyIt8nPPZQUIEZTuSUmNNP
 uzMiotgrYnX+c4BWSC/9Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 11:31:32AM +0100, Ingo Molnar wrote:
> 
> * Borislav Petkov <bp@alien8.de> wrote:
> 
> > On Mon, Oct 28, 2013 at 11:17:49AM +0100, Ingo Molnar wrote:
> >
> > > And regular write-back cacheable isn't sufficient because the 
> > > CPU could do things like prefetch your range automatically?
> > 
> > Yeah, he's doing a CLFLUSH anyway which basically makes it a 
> > write-through...
> 
> The CLFLUSH is done afterwards (making it a use-once thing), so WB 
> might still be faster and would avoid the PAT headache ...
> 
> Thanks,
> 
> 	Ingo
What i do right now is:
1. clflush the data range to read from my mmio device
2. read the data.
On PCIe Tracer i see the pcie  bursts.

If i mark the region WB and call clflush my system will crash without
any message, it just stop working.

regards
Andy
