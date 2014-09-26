Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbaIZL7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:59:20 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:53996 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753803AbaIZL7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:59:18 -0400
Message-ID: <1411732755.7866.24.camel@x220>
Subject: Re: [GIT PULL] EFI urgent fixes
From: Paul Bolle <pebolle@tiscali.nl>
To: Matt Fleming <matt@console-pimps.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 26 Sep 2014 13:59:15 +0200
In-Reply-To: <20140926114454.GV18635@console-pimps.org>
References: <20140925073133.GQ18635@console-pimps.org>
	 <20140925144127.GA3828@gmail.com> <1411730854.7866.10.camel@x220>
	 <20140926114454.GV18635@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Sep 2014 11:59:16.0524 (UTC) FILETIME=[4BF2B6C0:01CFD981]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-26 at 12:44 +0100, Matt Fleming wrote:
> On Fri, 26 Sep, at 01:27:34PM, Paul Bolle wrote:
> > 
> > This Makefile was changed in the first patch. That became 84be880560fb
> > ("Revert "efi/x86: efistub: Move shared dependencies to <asm/efi.h>""),
> > which just landed in next-20140926.
> > 
> > It appears to have introduced a typo, because:
> >     CONFIG_EFI_ARM_STUB
> > 
> > should probably have been:
> >     CONFIG_EFI_ARMSTUB
> 
> Crap. Thanks for catching that Paul. I'm wondering how this slipped
> through because that commit has an explicit Tested-by from Leif.
> 
> Hell, even I built an arm64 EFI kernel before sending that commit.
> 
> Ohh.. I see why no one caught this. From arch/arm64/Makefile,
> 
>   libs-$(CONFIG_EFI_STUB) += drivers/firmware/efi/libstub/
> 
> so libstub will be built for arm64 regardless of the broken logic in
> drivers/firmware/efi/Makefile.
> 
> Paul, how did you notice the typo? Did you hit an explicit build
> failure? It's definitely wrong and I'm trying to figure out whether I
> need to add some more testing to my build infrastructure to catch this
> kind of problem in the future.

I have a 800 line perl monster that checks for stuff like this. It's not
very sophisticated but smart enough to spot typos like this one. I try
to have it check each linux-next (and mainline) release.

(I think Valentin Rothberg is trying to automate this properly. See
http://www.linuxplumbersconf.org/2014/ocw/sessions/1863 .)

> The next question is: should we fix this up at this point in the merge
> cycle? It's basically just dead code.


Paul Bolle

