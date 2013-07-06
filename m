Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab3GFGk3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 02:40:29 -0400
Received: from pan-hq.tensilica.com ([65.119.96.30]:39314 "EHLO
	mailgw.tensilica.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751900Ab3GFGkV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 02:40:21 -0400
X-Greylist: delayed 1909 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Jul 2013 02:40:21 EDT
From: Marc Gauthier <Marc.Gauthier@tensilica.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Bjorn Helgaas <bhelgaas@google.com>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Date: Fri, 5 Jul 2013 23:07:31 -0700
Subject: Re: Build regressions/improvements in v3.10
Thread-Topic: Build regressions/improvements in v3.10
Thread-Index: Ac53bFEliOqsQnA4RhqdEq3t/sOc2wAMLpcg
Message-ID: <522C1DF17AF50042AD8AE87F7887BD3D0B7886DB32@exch>
References: <alpine.DEB.2.02.1307021912180.12710@ayla.of.borg>
	<CAErSpo41dwRCbMgYz8veHP6Mz62Z-uFJZ8NEQY6y1ULsqwiY7g@mail.gmail.com>
 <CAMuHMdWoTMEyyph8aEu46+xHfkXRFN_qn4a987n7eo6EPRyyhw@mail.gmail.com>
In-Reply-To: <CAMuHMdWoTMEyyph8aEu46+xHfkXRFN_qn4a987n7eo6EPRyyhw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert, Bjorn,

Geert Uytterhoeven wrote:
> On Tue, Jul 2, 2013 at 8:34 PM, Bjorn Helgaas
> <bhelgaas@google.com> wrote:
> >>   + warning: vmlinux.o(.text+0x1ad7a4): Section mismatch
> in reference from the function pwmchip_add() to the function
> .init.text:pcibios_fixup_bus():  => N/A
> >>   + warning: vmlinux.o(.text+0x1b18d8): Section mismatch
> in reference from the function pci_scan_child_bus() to the
> function .init.text:pcibios_fixup_bus():  => N/A
> >
> > I understand the second warning, but not the first (reference from
> > pwmchip_add() to pcibios_fixup_bus()).  I don't think pwmchip_add()
> > calls pcibios_fixup_bus().  Is the pwmchip_chip() function name
> > inexact, or is there some other problem here?
>
> Indeed, that's weird.
>
> This happened with xtensa-allmodconfig.
> I compiled my own xtensa-allmodconfig kernel, and it happens
> there, too.
>
> If I'm not mistaken, the hex address between parentheses should match
> the "from" function, right?
> After disassembly ("xtensa-linux-objdump -D vmlinux"), the addresses
> didn't seem to match the function names at all.
> So it may be an issue with the toolchain?


The Xtensa linker, by default, does some code shrinkage
(some of the "relaxations") after applying relocations,
causing code to move around.  This can sometimes cause
error/warning messages to use incorrect addresses.
(Not trivial to fix in the linker.)

There's a config option LD_NO_RELAX to disable linker
relaxation.  If using this option fixes the names, it
may be this issue.

-Marc
