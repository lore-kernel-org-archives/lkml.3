Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab3JBSmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 14:42:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34874 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715Ab3JBSmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 14:42:35 -0400
Date: Wed, 2 Oct 2013 20:42:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Young <dyoung@redhat.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Message-ID: <20131002184229.GE20568@pd.tnic>
References: <20130921113929.GB1587@pd.tnic>
 <20130922123515.GA7476@dhcp-16-126.nay.redhat.com>
 <20130922133722.GC28718@pd.tnic>
 <1ba7eca6-419c-4181-9927-9ba0927a6abf@email.android.com>
 <20130924025209.GA5561@dhcp-16-126.nay.redhat.com>
 <2d27a1bc-eabf-4d45-8303-27ae58511b11@email.android.com>
 <20131002100426.GB20568@pd.tnic>
 <524C3F38.6050507@zytor.com>
 <20131002170522.GA20647@pd.tnic>
 <524C58A3.4090704@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <524C58A3.4090704@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 10:32:19AM -0700, H. Peter Anvin wrote:
> So this is a bug in the sense that 2M pages were used when they were
> not safe to use (matching alignment is part of the requirement for 2M
> pages being allowable.) However, we of course want to use 2M pages, so
> see below.

Yes, so the alignment has to be such that both PA and VA are the same
amount of 4K pages away from the next 2M boundary, to put it bluntly.

I have a couple of ideas on how to do that.

> We could achieve the same thing by doing alignment after subtracting the
> pointer.  HOWEVER, it also goes to show that any mapping scheme is
> inherently fragile (consider if the mapping scheme above ends up
> consuming too much virtual space in the future), and as a result I

Yes, I understand your sentiment - we want to be as conservative as
possible with the approach before it is cast in stone, for we don't know
what firmware turds are to be expected in the future.

> really think that explicitly passing the map to the kexec kernel
> really is the only sane thing to do, as otherwise we have to maintain
> the same algorithm forever.

Yes, we'll have to announce the mapping over sysfs of proc for the
kexec-tools to parse it, as I'm sure you've already heard. But this can
and will be done in the next step, right after we have a stable regions
mapping algorithm.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
