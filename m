Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab3IYFqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 01:46:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52406 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab3IYFqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 01:46:47 -0400
Date: Wed, 25 Sep 2013 07:47:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Young <dyoung@redhat.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Message-ID: <20130925054703.GA12962@nazgul.tnic>
References: <e39e1065bddc2afee2cb6eed957e3ba8.squirrel@www.skyhub.de>
 <52422A6A.8080305@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52422A6A.8080305@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 05:12:26PM -0700, H. Peter Anvin wrote:
> I am starting to think that we really should explicitly pass along the
> EFI mappings to the secondary kernel.  This will also help if we have to
> change the algorithm in a future kernel.

That would be the most flexible solution, sure.

> The most logical way to do this is to define a new setup_data type and
> pass the entire set of physical-to-virtual mappings that way.
> 
> For example:
> 
> struct efi_mapping {
> 	u64 va;			/* Virtual start address */
> 	u64 pa;			/* Physical start address */
> 	u64 len;		/* Length in bytes */
> 	u64 type;		/* Mapping type */
> 	u64 reserved[3];	/* Reserved, must be zero */
> };
> 
> Adding some reserved fields seems like a prudent precaution;

... and making checking they're zeroed out initially so that I can use
them in the future, if needed :)

> the map shouldn't be all that large anyway.

Yeah, let me look at it in more detail when I get back - it shouldn't be
that hard to do.

Thanks.
