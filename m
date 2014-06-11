Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbaFKCYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 22:24:12 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:46511 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784AbaFKCYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 22:24:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140611120249.56a64953@canb.auug.org.au>
References: <20140611120249.56a64953@canb.auug.org.au>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 10 Jun 2014 20:23:49 -0600
Message-ID: <CAErSpo6ZOQbnNugEAz=YGN6Dcc13Yj_8gfFrn0haw6OtP+zQKA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the pci tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next list <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ryan Desfosses <ryan@desfo.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 8:02 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Bjorn,
>
> After merging the pci tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
>
> ERROR: ".pci_try_set_mwi" [drivers/scsi/qla2xxx/qla2xxx.ko] undefined!
> ERROR: ".pci_clear_mwi" [drivers/scsi/qla2xxx/qla2xxx.ko] undefined!
> ERROR: ".pci_try_set_mwi" [drivers/scsi/lpfc/lpfc.ko] undefined!
>
> Caused by commit 9259d755975f ("PCI: Move EXPORT_SYMBOL so it
> immediately follows function/variable").
> arch/powerpc/include/asm/pci.h defines PCI_DISABLE_MWI and there are
> two version of those functions depending on the setting of that symbol.
>
> I have used the pci tree from next-20140610 for today.

Thanks.  This is my fault, not Ryan's.  I made more similar changes,
but didn't notice the #ifdefs around the definitions.  I fixed it and
will update my "next" branch tomorrow, after Fengguang's buildbot
confirms the fix.

Bjorn
