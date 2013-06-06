Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab3FFVCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:02:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53650 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255Ab3FFVCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:02:34 -0400
Date: Thu, 6 Jun 2013 23:02:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matt Fleming <matt@console-pimps.org>,
        Linux EFI <linux-efi@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 3/4] x86, efi: Add an efi= kernel command line parameter
Message-ID: <20130606210218.GR20972@pd.tnic>
References: <20130606185140.GK20972@pd.tnic>
 <20130606193548.GA2946@srcf.ucam.org>
 <20130606194134.GN20972@pd.tnic>
 <20130606195450.GA3252@srcf.ucam.org>
 <20130606200705.GO20972@pd.tnic>
 <20130606201828.GA3950@srcf.ucam.org>
 <20130606202717.GP20972@pd.tnic>
 <20130606203057.GA4237@srcf.ucam.org>
 <20130606204410.GQ20972@pd.tnic>
 <20130606205057.GA4363@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130606205057.GA4363@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 09:50:57PM +0100, Matthew Garrett wrote:
> What do you mean by "call them"? I don't think we ever want to call by
> physical address, other than maybe in the kexec case. The only reason
> we really care about the physical addresses being mapped 1:1 is that
> some pointers may not have been updated.

I want to be able to call the runtime services in the kexec kernel.
Which means, the kexec kernel would simply map the runtime code/data
regions 1:1 and then use the physical addresses to call the runtime
services.

Question is: would that work even if SetVirtualAddressMap has already
run in the original kernel and with virtual addresses?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
