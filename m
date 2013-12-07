Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab3LGNay (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 08:30:54 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53172 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750Ab3LGNav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 08:30:51 -0500
Date: Sat, 7 Dec 2013 14:30:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: mjg59@srcf.ucam.org, linux-efi@vger.kernel.org,
        toshi kani <toshi.kani@hp.com>, matt@console-pimps.org, greg@kroah.com,
        x86@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        horms@verge.net.au, ebiederm@xmission.com, hpa@zytor.com,
        vgoyal@redhat.com
Subject: Re: [PATCH v4 06/12] efi: export efi runtime memory mapping to sysfs
Message-ID: <20131207133048.GA4183@pd.tnic>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-7-git-send-email-dyoung@redhat.com>
 <20131127114402.GB32267@pd.tnic>
 <20131129094034.GI4186@dhcp-16-126.nay.redhat.com>
 <20131129115029.GB4266@pd.tnic>
 <20131202025942.GF3999@dhcp-16-126.nay.redhat.com>
 <20131202094020.GA7380@pd.tnic>
 <2141297830.13051543.1386406862068.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2141297830.13051543.1386406862068.JavaMail.root@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 07, 2013 at 04:01:02AM -0500, Dave Young wrote:
> Hi, all
> 
> Update my status:
> 
> I have finished most of thecode related changes including the krealloc
> fixes (both for original code and my new code). And I'm slowly
> moving the kexec related stuff to efi_kexec.c, this involves
> some other cleanups, such as:
> efi_systab_init:
>  -> move 64bit code to efi_64.c, move 32bit code to efi_32.c
> 
> efi_setup global variable is changing to physical address, ioremapping
> it when necessary instead of directly using the virt addr because
> previously the virt addr will be freed until entering virtual mode,
> it's possible a leak in case something is wrong in the middle also it
> occupies the ioremap slot a little bit long.
> 
> There's also other problems, so I still need a few days probably
> a week to carefully restructure the code.

Those are all lofty goals but beware that trying to solve it all at
once can be very painful and can cause unnecessary work for both coders
and reviewers. Especially if the patchset grows out of proportion which
makes it much harder to review and deal with.

So, from my experience and if I were you, I'd try to address the most
important issue I'm trying to fix, have 10ish nice clean patches and put
the rest on the TODO list. This is much easier to deal with for everyone
involved than trying to solve it all at once.

Besides, if you solve it all at once, what are you going to work on
afterwards? :-)

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
