Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081Ab3FSQIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:08:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38360 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845Ab3FSQIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:08:09 -0400
Date: Wed, 19 Jun 2013 17:08:04 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Message-ID: <20130619160804.GB27832@srcf.ucam.org>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
 <20130619125243.GD11209@gmail.com>
 <20130619130225.GA28311@pd.tnic>
 <20130619130434.GB24957@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619130434.GB24957@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 03:04:34PM +0200, Ingo Molnar wrote:
> * Borislav Petkov <bp@alien8.de> wrote:
> > And yet there are the Macs which reportedly cannot stomach this.
> 
> Do we know why?

I got lost in a maze of pointer arithmetic. There seems to be an 
assumption that nvram writes should be forbidden if in runtime mode but 
with pointers still below the phys/virt split, which obviously makes no 
sense but hey.

But, as always, the only reliable thing to do here is to behave as much 
like Windows as possible. Which means performing the 1:1 mapping but 
maintaining the high mapping, and passing the high values via 
SetVirtualAddressMap.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
