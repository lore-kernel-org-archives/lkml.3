Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab3FFUSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:18:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39196 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab3FFUSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:18:33 -0400
Date: Thu, 6 Jun 2013 21:18:28 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>,
        Linux EFI <linux-efi@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 3/4] x86, efi: Add an efi= kernel command line parameter
Message-ID: <20130606201828.GA3950@srcf.ucam.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-4-git-send-email-bp@alien8.de>
 <20130606104224.GH30420@console-pimps.org>
 <20130606132603.GD20972@pd.tnic>
 <20130606175052.GA1285@srcf.ucam.org>
 <20130606185140.GK20972@pd.tnic>
 <20130606193548.GA2946@srcf.ucam.org>
 <20130606194134.GN20972@pd.tnic>
 <20130606195450.GA3252@srcf.ucam.org>
 <20130606200705.GO20972@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606200705.GO20972@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 10:07:05PM +0200, Borislav Petkov wrote:
> On Thu, Jun 06, 2013 at 08:54:50PM +0100, Matthew Garrett wrote:
> > We want both to be available when we're making the call, but I think
> > we should probably enter via the high addresses. The only reason we're
> > doing this at all is that some systems don't update all of their
> > pointers from physical mode, and we'd prefer them to work rather than
> > fault...
> 
> Actually, we do the 1:1 thing so that EFI runtime works in a kexec
> kernel too. Which won't work if we use the high addresses.

kexec seems like a lower priority than compatibility. Perhaps keep the 
efi argument for people who want to use kexec? hpa suggested allocating 
a fixed high area for UEFI mappings, which would also solve this.

> However, if we can use the 1:1 map *after* SetVirtualAddressMap() has
> been called with the high mappings, then my issue is solved - we drop
> to using 1:1 in the kexec kernel only. But I don't think that is the
> case...

Yeah, calling SetVirtualAddressMap() with high addresses is going to 
result in the firmware having a bunch of pointers to high addresses.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
