Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab3IWGaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 02:30:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40715 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab3IWG37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 02:29:59 -0400
Date: Mon, 23 Sep 2013 08:29:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Message-ID: <20130923062947.GA2527@pd.tnic>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <1379602494-26684-12-git-send-email-bp@alien8.de>
 <20130921113929.GB1587@pd.tnic>
 <20130923054741.GC7007@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130923054741.GC7007@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 01:47:41PM +0800, Dave Young wrote:
> > +	unsigned long size = md->num_pages << PAGE_SHIFT;
> > +
> > +	efi_va -= size;
> > +	if (efi_va < EFI_VA_END) {
> > +		pr_warning(FW_WARN "VA address range overflow!\n");
> > +		return;
> > +	}
> > +
> > +	/* Do the 1:1 map */
> > +	__map_region(md, md->phys_addr);
> > +
> > +	/* Do the VA map */
> > +	__map_region(md, efi_va);
> 
> 
> Could you add comment for above code? It's hard to understand the
> twice mapping if one did not follow the old thread.

Does that suffice:

/*
 * Make sure the 1:1 mappings are present as a catch-all for b0rked firmware
 * which doesn't update all internal pointers after switching to virtual mode
 * and would otherwise crap on us.
 */

?

Btw, when you reply to a mail, please remove that quoted portion of it
which you're not replying to - I had to scroll a bunch of screens down
and I almost missed your reply. :)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
