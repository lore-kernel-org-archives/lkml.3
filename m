Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab3GBSed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 14:34:33 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:56243 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab3GBSec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 14:34:32 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1307021912180.12710@ayla.of.borg>
References: <alpine.DEB.2.02.1307021912180.12710@ayla.of.borg>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 2 Jul 2013 12:34:11 -0600
Message-ID: <CAErSpo41dwRCbMgYz8veHP6Mz62Z-uFJZ8NEQY6y1ULsqwiY7g@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.10
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 2, 2013 at 11:12 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Below is the list of build error/warning regressions/improvements in
> v3.10[1] compared to v3.9[2].

Thanks for doing this!

>   + warning: vmlinux.o(.text+0x1ad7a4): Section mismatch in reference from the function pwmchip_add() to the function .init.text:pcibios_fixup_bus():  => N/A
>   + warning: vmlinux.o(.text+0x1b18d8): Section mismatch in reference from the function pci_scan_child_bus() to the function .init.text:pcibios_fixup_bus():  => N/A

I understand the second warning, but not the first (reference from
pwmchip_add() to pcibios_fixup_bus()).  I don't think pwmchip_add()
calls pcibios_fixup_bus().  Is the pwmchip_chip() function name
inexact, or is there some other problem here?

I did post patches to fix the pcibios_fixup_bus() implementations that
are incorrectly marked __init.

Bjorn
