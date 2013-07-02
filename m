Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563Ab3GBVdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 17:33:25 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:34185 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab3GBVdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 17:33:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWoTMEyyph8aEu46+xHfkXRFN_qn4a987n7eo6EPRyyhw@mail.gmail.com>
References: <alpine.DEB.2.02.1307021912180.12710@ayla.of.borg>
 <CAErSpo41dwRCbMgYz8veHP6Mz62Z-uFJZ8NEQY6y1ULsqwiY7g@mail.gmail.com> <CAMuHMdWoTMEyyph8aEu46+xHfkXRFN_qn4a987n7eo6EPRyyhw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 2 Jul 2013 15:33:00 -0600
Message-ID: <CAErSpo5Un=KFKyKNbUOXMtPcYoreWLb4rYb=+fDn+Qp8bGXc3Q@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.10
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-xtensa@linux-xtensa.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 2, 2013 at 3:29 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Tue, Jul 2, 2013 at 8:34 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>>   + warning: vmlinux.o(.text+0x1ad7a4): Section mismatch in reference from the function pwmchip_add() to the function .init.text:pcibios_fixup_bus():  => N/A
>>>   + warning: vmlinux.o(.text+0x1b18d8): Section mismatch in reference from the function pci_scan_child_bus() to the function .init.text:pcibios_fixup_bus():  => N/A
>>
>> I understand the second warning, but not the first (reference from
>> pwmchip_add() to pcibios_fixup_bus()).  I don't think pwmchip_add()
>> calls pcibios_fixup_bus().  Is the pwmchip_chip() function name
>> inexact, or is there some other problem here?
>
> Indeed, that's weird.
>
> This happened with xtensa-allmodconfig.
> I compiled my own xtensa-allmodconfig kernel, and it happens there, too.
>
> If I'm not mistaken, the hex address between parentheses should match
> the "from" function, right?
> After disassembly ("xtensa-linux-objdump -D vmlinux"), the addresses
> didn't seem to match the function names at all.
> So it may be an issue with the toolchain?

OK, I sent an xtensa patch to fix the
pci_scan_child_bus()/pcibios_fixup_bus() mismatch; I wouldn't be
surprised if that makes this pwmchip_add() thing go away, too.

Bjorn
