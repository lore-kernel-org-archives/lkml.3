Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbaIZLo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:44:59 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56772 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbaIZLo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:44:57 -0400
Date: Fri, 26 Sep 2014 12:44:54 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [GIT PULL] EFI urgent fixes
Message-ID: <20140926114454.GV18635@console-pimps.org>
References: <20140925073133.GQ18635@console-pimps.org>
 <20140925144127.GA3828@gmail.com>
 <1411730854.7866.10.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411730854.7866.10.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep, at 01:27:34PM, Paul Bolle wrote:
> 
> This Makefile was changed in the first patch. That became 84be880560fb
> ("Revert "efi/x86: efistub: Move shared dependencies to <asm/efi.h>""),
> which just landed in next-20140926.
> 
> It appears to have introduced a typo, because:
>     CONFIG_EFI_ARM_STUB
> 
> should probably have been:
>     CONFIG_EFI_ARMSTUB

Crap. Thanks for catching that Paul. I'm wondering how this slipped
through because that commit has an explicit Tested-by from Leif.

Hell, even I built an arm64 EFI kernel before sending that commit.

Ohh.. I see why no one caught this. From arch/arm64/Makefile,

  libs-$(CONFIG_EFI_STUB) += drivers/firmware/efi/libstub/

so libstub will be built for arm64 regardless of the broken logic in
drivers/firmware/efi/Makefile.

Paul, how did you notice the typo? Did you hit an explicit build
failure? It's definitely wrong and I'm trying to figure out whether I
need to add some more testing to my build infrastructure to catch this
kind of problem in the future.

The next question is: should we fix this up at this point in the merge
cycle? It's basically just dead code.

-- 
Matt Fleming, Intel Open Source Technology Center
