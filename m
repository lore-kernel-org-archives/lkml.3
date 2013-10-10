Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab3JJI6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:58:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57464 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549Ab3JJI6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:58:33 -0400
Date: Thu, 10 Oct 2013 10:58:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org,
        fwts-devel@lists.ubuntu.com
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Message-ID: <20131010085827.GA9929@pd.tnic>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20131008164551.GB16793@pd.tnic>
 <20131008164831.GD16793@pd.tnic>
 <20131010080635.GA3692@dhcp-16-126.nay.redhat.com>
 <20131010081434.GB3692@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131010081434.GB3692@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 04:14:34PM +0800, Dave Young wrote:
> Even though I still have no idea why kernel text overlap with efi boot
> region, anyway map the un-overlapped part is necessary though.
>
> I can post the kexec related patches after your mapping patches settle
> down

Right, "settle down" being the key here.

Matt just mentioned on IRC that we might not need boot services mappings
by the time we have to start the kexec kernel, which would mean, you
don't have to do anything in efi_reserve_boot_services().

The question which needs answering first though is, how the whole efi
thing is going to handle any functionality like calling into efi boot
regions from runtime functions and such. Which hasn't really been tested
and fw vendors don't really want to support that. But this is all bits
and pieces I heard yesterday so it is all pretty wet and I'll let efi
guys, i.e. the Matts and a couple of others :-), figure out this whole
issue.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
