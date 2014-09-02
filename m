Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbaIBT3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 15:29:45 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47713 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbaIBT3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 15:29:44 -0400
Date: Tue, 2 Sep 2014 20:29:41 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Ulf Winkelvos <ulf@winkelvos.de>, Matt Fleming <matt.fleming@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
Message-ID: <20140902192941.GB3001@console-pimps.org>
References: <5405E186.2080406@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5405E186.2080406@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep, at 05:25:58PM, Maarten Lankhorst wrote:
> Hey,
> 
> My macbook pro 8.2 fails to do a efi stub boot with these patches.
> 
> Commit f23cf8bd5c1f49 "efi/x86: efistub: Move shared dependencies to <asm/efi.h>"
> causes the first break, but this can be averted by changing
> 
> struct efi_config *efi_early;
> 
> to
> 
> struct efi_config *efi_early __attribute__((visibility("hidden")));
 
Weird. That sounds like a bug in the Apple EFI PE loader. Does any other
visibility result in a working kernel?

> I also need to revert commit f4f75ad5741fe "efi: efistub: Convert into static library"
> to get boot working.
 
I'll take a look at the symbol changes between these commits and try and
guess what's going on.

> I'm not an early boot expert, so I have no idea what's going on here.
> Only console output I see when the boot fails is "setup_efi_pci() failed!" after
> the commit that adds this message.

Yeah, that should be unrelated.

Thanks for the report.

-- 
Matt Fleming, Intel Open Source Technology Center
