Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab3JWMZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 08:25:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49401 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab3JWMZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 08:25:37 -0400
Date: Wed, 23 Oct 2013 14:25:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org,
        fwts-devel@lists.ubuntu.com
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Message-ID: <20131023122531.GA15848@nazgul.tnic>
References: <20131012101308.GI12321@console-pimps.org>
 <20131012103054.GA13739@pd.tnic>
 <20131013031126.GB1914@darkstar.nay.redhat.com>
 <20131013092521.GA22866@pd.tnic>
 <20131014155851.GJ4009@pd.tnic>
 <20131021124739.GA4515@dhcp-16-126.nay.redhat.com>
 <20131021133741.GA5716@nazgul.tnic>
 <20131021150426.GB4515@dhcp-16-126.nay.redhat.com>
 <20131022111857.GA10660@nazgul.tnic>
 <20131023021730.GE4594@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131023021730.GE4594@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 10:17:31AM +0800, Dave Young wrote:
> The reason is that I only pass runtime regions from 1st kernel to
> kexec kernel, your efi mapping function uses the region size to
> determin the virtual address from top to down. Because the passed-in
> md ranges in kexec kernel are different from ranges booting from
> firmware so the virtual address will be different.

Well, this shouldn't be because SetVirtualAddressMap has already fixed
the virtual addresses for us. And if they're different, then runtime
services won't work anyway. Or am I missing something...?

> Even I pass the whole untouched ranges including BOOT_SERVICE there's
> still chance the function for reserving boot regions overwrite the
> boot region size to 0, and 1st kernel will leave it to be used as
> normal memory after efi init. I think we have talked about this issue
> previously.

Matt, didn't you question the need to keep boot services regions
mapped indefinitely? What was the story there?

Thanks.
