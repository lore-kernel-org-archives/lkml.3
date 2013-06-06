Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab3FFTyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 15:54:55 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38949 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3FFTyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 15:54:53 -0400
Date: Thu, 6 Jun 2013 20:54:50 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>,
        Linux EFI <linux-efi@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 3/4] x86, efi: Add an efi= kernel command line parameter
Message-ID: <20130606195450.GA3252@srcf.ucam.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-4-git-send-email-bp@alien8.de>
 <20130606104224.GH30420@console-pimps.org>
 <20130606132603.GD20972@pd.tnic>
 <20130606175052.GA1285@srcf.ucam.org>
 <20130606185140.GK20972@pd.tnic>
 <20130606193548.GA2946@srcf.ucam.org>
 <20130606194134.GN20972@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606194134.GN20972@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 09:41:34PM +0200, Borislav Petkov wrote:
> On Thu, Jun 06, 2013 at 08:35:48PM +0100, Matthew Garrett wrote:
> > No, I think that's the wrong thing to do. We should set up the current
> > mappings and the 1:1 mappings, and pass the current mappings through
> > SetVirtualAddressMap(). That matches the behaviour of Windows.
> 
> And when do we use the 1:1 mappings and when the current mappings when
> doing runtime calls?

We want both to be available when we're making the call, but I think we 
should probably enter via the high addresses. The only reason we're 
doing this at all is that some systems don't update all of their 
pointers from physical mode, and we'd prefer them to work rather than 
fault...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
