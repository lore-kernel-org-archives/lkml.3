Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab3FFVDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:03:47 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39833 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab3FFVDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:03:46 -0400
Date: Thu, 6 Jun 2013 22:03:43 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>,
        Linux EFI <linux-efi@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 3/4] x86, efi: Add an efi= kernel command line parameter
Message-ID: <20130606210343.GA4939@srcf.ucam.org>
References: <20130606193548.GA2946@srcf.ucam.org>
 <20130606194134.GN20972@pd.tnic>
 <20130606195450.GA3252@srcf.ucam.org>
 <20130606200705.GO20972@pd.tnic>
 <20130606201828.GA3950@srcf.ucam.org>
 <20130606202717.GP20972@pd.tnic>
 <20130606203057.GA4237@srcf.ucam.org>
 <20130606204410.GQ20972@pd.tnic>
 <20130606205057.GA4363@srcf.ucam.org>
 <20130606210218.GR20972@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606210218.GR20972@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 11:02:18PM +0200, Borislav Petkov wrote:
> On Thu, Jun 06, 2013 at 09:50:57PM +0100, Matthew Garrett wrote:
> > What do you mean by "call them"? I don't think we ever want to call by
> > physical address, other than maybe in the kexec case. The only reason
> > we really care about the physical addresses being mapped 1:1 is that
> > some pointers may not have been updated.
> 
> I want to be able to call the runtime services in the kexec kernel.
> Which means, the kexec kernel would simply map the runtime code/data
> regions 1:1 and then use the physical addresses to call the runtime
> services.
> 
> Question is: would that work even if SetVirtualAddressMap has already
> run in the original kernel and with virtual addresses?

No. You'll need to have an option for that case.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
