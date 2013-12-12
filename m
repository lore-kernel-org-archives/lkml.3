Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab3LLHSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:18:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab3LLHS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:18:27 -0500
Date: Thu, 12 Dec 2013 15:17:43 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v5 09/14] efi: passing kexec necessary efi data via
 setup_data
Message-ID: <20131212071743.GJ3751@dhcp-16-126.nay.redhat.com>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-10-git-send-email-dyoung@redhat.com>
 <20131211222057.GB8863@pd.tnic>
 <20131212030619.GG3751@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212030619.GG3751@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >  
> > > +void __init parse_efi_setup(u64 phys_addr)
> > > +{
> > > +	struct setup_data *sd;
> > > +
> > > +	if (!efi_enabled(EFI_64BIT)) {
> > > +		pr_warn("SETUP_EFI not supported on 32-bit\n");
> > > +		return;
> > > +	}
> > 
> > Shouldn't this function be in two versions in efi_64.c and efi_32.c?
> > This way you don't need this check with cryptic printk message.
> 
> Ok, will update.

Rethink about this issue, moving them to efi_$(BITS).c I need move the
efi_setup from a static variable to an extern, It looks not worth.

Thanks
Dave
