Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbaIVVHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:07:15 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:60161 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbaIVVHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:07:10 -0400
Date: Mon, 22 Sep 2014 22:07:07 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Michael Brown <mbrown@fensystems.co.uk>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ulf Winkelvos <ulf@winkelvos.de>,
        Matt Fleming <matt.fleming@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
Message-ID: <20140922210707.GG18635@console-pimps.org>
References: <CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw@mail.gmail.com>
 <20140903175948.GH3001@console-pimps.org>
 <CAKv+Gu9tejixb3Kb3YM_7sLcpKNuRHN+Dn+twFyCAXx99wYRCw@mail.gmail.com>
 <54084376.8090002@canonical.com>
 <540860F1.6060801@fensystems.co.uk>
 <CAKv+Gu8wALTqtNQK_855A7M5f2a+EB1JyLxo=j6G0T1cf8ZFog@mail.gmail.com>
 <CAKv+Gu_sLmkBHF-9GyPUgfAbLYirQTD4vk63o6HzdZhm6s_e0g@mail.gmail.com>
 <20140904213753.GM3001@console-pimps.org>
 <20140905202744.GO3001@console-pimps.org>
 <CA+5PVA4odm8K-vK0wjD4U9=twngADyJMEokYhHSsGCu1QjZnHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA4odm8K-vK0wjD4U9=twngADyJMEokYhHSsGCu1QjZnHQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep, at 02:44:23PM, Josh Boyer wrote:
> 
> This wound up in rc6 as commit
> 9cb0e394234d244fe5a97e743ec9dd7ddff7e64b.  That caused all the EFI
> machines I have to no longer boot.  They hang after the 'setup_efi_pci
> failed' message and I get nothing from the kernel at all, even with
> earlyprintk, etc.
> 
> I did a git bisect between rc5 and rc6 and it points to this commit.
> This is a typical Fedora setup, which is EFI->shim->grub2->kernel.  It
> broke the boot on multiple machines I have, and I've confirmed that a
> revert on top of rc6 makes things boot again on both my macbook and my
> tunnel mountain machine.  I'll be testing it on my celeron and i7
> based NUC machines as well, but I expect similar results.

Thanks for doing the bisect.

I've now booted with this commit using grub2 and it boots fine on Qemu.
I don't have a shim setup, but I'll look at sorting one out.

> Is there something I can do to help debug why this is failing on this
> kind of setup?  Config and bisect log are attached below for the
> macbook I used for the bisect.

Could you provide the dmesg of a working boot? I'm curious to know more
about your memory map layout.

Other than that, trying to diagnose exactly where it hangs during
booting would be useful.

-- 
Matt Fleming, Intel Open Source Technology Center
