Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934361AbaKMVYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:24:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57413 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934044AbaKMVYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:24:06 -0500
Date: Thu, 13 Nov 2014 22:23:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>, Andy Lutomirski <luto@amacapital.net>
Cc: Oleg Nesterov <oleg@redhat.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, kvm ML <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Message-ID: <20141113212355.GH14070@pd.tnic>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141112220058.GA5295@redhat.com>
 <CALCETrWA5z7-1fiz_9N0Qi2OR5s1jCkHiynCtTD_+9taOBs-Mg@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BAB4@ORSMSX114.amr.corp.intel.com>
 <CALCETrU8uyc4nu-5MBXQR0PY0rexUhPkuPRLK+gWt0gEWMDhTA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BD44@ORSMSX114.amr.corp.intel.com>
 <20141113105936.GA14070@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141113105936.GA14070@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 11:59:37AM +0100, Borislav Petkov wrote:
> I've been thinking about it recently too - adding MCA functionality to
> qemu/kvm could be very useful, especially the thresholding stuff, for
> testing RAS kernel code.

Btw, qemu monitor has a mce injection command with which I was able
to tickle some response from the guest kernel. I'll play more with it
tomorrow and try to tickle a response from the memory failure code.

[  195.328466] Disabling lock debugging due to kernel taint
[  195.328466] [Hardware Error]: System Fatal error.
[  195.328466] [Hardware Error]: CPU:1 (10:2:3) MC4_STATUS[Over|UE|MiscV|PCC|AddrV|UECC]: 0xfe002000001f012b
[  195.328466] [Hardware Error]: MC4_ADDR: 0x0000000000000000
[  195.328466] [Hardware Error]: MC4 Error (node 1): ECC Error in the Probe Filter directory.
[  195.328466] [Hardware Error]: cache level: L3/GEN, tx: GEN, mem-tx: WR
[  195.328466] mce: [Hardware Error]: CPU 1: Machine Check Exception: 3 Bank 4: fe002000001f012b
[  195.328466] mce: [Hardware Error]: RIP 10:<ffffffff8100e0b5> {default_idle+0x25/0x240}
[  195.328466] mce: [Hardware Error]: TSC b9e2f56f95 MISC d1d1dad1deadbeef 
[  195.328466] mce: [Hardware Error]: PROCESSOR 2:100f23 TIME 1415915466 SOCKET 1 APIC 1 microcode 1000065
[  195.328466] [Hardware Error]: System Fatal error.
[  195.328466] [Hardware Error]: CPU:1 (10:2:3) MC4_STATUS[Over|UE|MiscV|PCC|AddrV|UECC]: 0xfe002000001f012b
[  195.328466] [Hardware Error]: MC4_ADDR: 0x0000000000000000
[  195.328466] [Hardware Error]: MC4 Error (node 1): ECC Error in the Probe Filter directory.
[  195.328466] [Hardware Error]: cache level: L3/GEN, tx: GEN, mem-tx: WR
[  195.328466] mce: [Hardware Error]: Machine check: Invalid
[  195.328466] Kernel panic - not syncing: Fatal machine check on current CPU
[  195.328466] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[  195.328466] ---[ end Kernel panic - not syncing: Fatal machine check on current CPU

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
