Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731Ab3GaVy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 17:54:29 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44452 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3GaVy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 17:54:28 -0400
Date: Wed, 31 Jul 2013 22:54:23 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>, linux-efi@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Corrupted EFI region
Message-ID: <20130731215423.GA2628@srcf.ucam.org>
References: <20130731205431.GG4724@pd.tnic>
 <20130731205858.GA1678@srcf.ucam.org>
 <20130731215130.GA6087@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731215130.GA6087@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 11:51:30PM +0200, Borislav Petkov wrote:

> But the problem is, something messes up the upper boundary of the region
> and it is an EFI_BOOT_SERVICES_DATA region which we need for the runtime
> services mapping and if we can't map it properly, we're probably going
> to miss functionality or not have runtime at all.

"Easiest" way around this would probably be to stash the address map 
after ExitBootServices() and compare it at SetVirtualAddressMap() time, 
then take the widest boundaries and trim the e820 map to match. This is 
obviously dependent upon the system not allocating anything further 
after that, but it seems safest. The worst case is finding the firmware 
writing over bits of the kernel.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
