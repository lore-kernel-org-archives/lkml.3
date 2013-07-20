Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab3GTW7W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 18:59:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33728 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733Ab3GTW7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 18:59:21 -0400
Date: Sun, 21 Jul 2013 00:59:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        Jacob Shin <jacob.shin@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.w.shin@gmail.com>
Subject: Re: early microcode on amd is broken when no initramfs provided
Message-ID: <20130720225911.GC13731@pd.tnic>
References: <20130709183601.5d567a83@fem.tu-ilmenau.de>
 <20130710073049.GA15525@pd.tnic>
 <20130711230525.40bc6491@fem.tu-ilmenau.de>
 <20130716170055.GG4402@pd.tnic>
 <CAPVoSvQuzUQUgRgk6fhsxEhjWS8oPreo00u_urntaCzmERpOtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPVoSvQuzUQUgRgk6fhsxEhjWS8oPreo00u_urntaCzmERpOtg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 09:01:33PM +0200, Torsten Kaiser wrote:
> On Tue, Jul 16, 2013 at 7:00 PM, Borislav Petkov <bp@alien8.de> wrote:
> > On Thu, Jul 11, 2013 at 11:05:25PM +0200, Johannes Hirte wrote:
> >> config is attached
> >
> > Ok, I can reproduce the hang with your config but even with:
> >
> > $ grep MICROCODE .config
> > # CONFIG_MICROCODE is not set
> > # CONFIG_MICROCODE_INTEL_EARLY is not set
> > # CONFIG_MICROCODE_AMD_EARLY is not set
> >
> > which means, it cannot be microcode-related.
> >
> > And I'd bet if you wait a minute (yep, it should be exactly 60 seconds)
> > the boot would probably continue. And if so, this is that 60 sec delay
> > where the kernel tries to find firmware.
> >
> > Hmm...
> 
> I have the same problem: Booting 3.11-rc1 hangs after the line:
> ACPI: Executed 3 blocks of module-level executable AML code
> 
> I bisected it down to the early microcode changes:
> 757885e94a22bcc82beb9b1445c95218cb20ceab (the new early loading
> implementation) and 6b3389ac21b5e557b957f1497d0ff22bf733e8c3 (small
> fixup) completely fail to boot (No output beyond "Booting kernel") ,
> from 275bbe2e299f1820ec8faa443d689469a9e6ecc5 ("Make
> find_ucode_in_initrd() __init") I'm seeing this hang.
> 
> Just turning CONFIG_MICROCODE_EARLY off solves the problem: The system
> now sucessfully boots 3.11-rc1.

Ok, I need to be able to reproduce that first - I wasn't that successful
with Johannes' setup.

So, can you please send .config and how you're loading your microcode?
Is it in the initrd or are you doing that later, how? Grub entry please.

Also, is it just plain v3.11-rc1 or with patches ontop?

Also, /proc/cpuinfo please.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
