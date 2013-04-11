Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965070Ab3DKRfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:35:38 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:61659 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965020Ab3DKRfe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:35:34 -0400
MIME-Version: 1.0
In-Reply-To: <5166F39C.1050907@openwrt.org>
References: <1365098483-26821-1-git-send-email-juhosg@openwrt.org>
 <1365098483-26821-2-git-send-email-juhosg@openwrt.org> <CAErSpo4ih-Kgp4LxX1MDodac-eoPo=Mu1d6ex8oNnaEEc_GQnw@mail.gmail.com>
 <5166F39C.1050907@openwrt.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 11 Apr 2013 11:35:14 -0600
Message-ID: <CAErSpo454_bkXa1Uy70_dv9SSnofxYNPyxR=W7X-QmaxxGNO5g@mail.gmail.com>
Subject: Re: [PATCH 2/2] MIPS: implement pcibios_get_phb_of_node
To: Gabor Juhos <juhosg@openwrt.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 11:32 AM, Gabor Juhos <juhosg@openwrt.org> wrote:
> 2013.04.10. 18:31 keltezéssel, Bjorn Helgaas írta:
>> On Thu, Apr 4, 2013 at 12:01 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
>>> The of_node field of the device assigned to a
>>> PCI bus is used during scanning of the PCI bus.
>>> However on MIPS, the of_node field is assigned
>>> only after the bus has been scanned.
>>>
>>> Implement the architecture specific version of
>>> 'pcibios_get_phb_of_node'. Which ensures that the
>>> PCI driver core will initialize the of_node field
>>> before starting the scan.
>>>
>>> Also remove the local assignment of bus->dev.of_node,
>>> it is not needed after the patch.
>>>
>>> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
>>
>> I removed the __weak annotation from include/linux/pci.h and applied
>> this patch to my pci/gabor-get-of-node.
>
> Thank you!
>
>> Give it a try and make sure
>> it solves your problem.  If so, and Ralph approves, I can push both
>> for v3.10.  It should appear at
>> http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/gabor-get-of-node
>> soon.
>
> I have tried your patch on top of 3.9-rc6. The resulting kernel uses the
> architecture specific implementation, and it runs fine.
>
>   $ mipsel-openwrt-linux-readelf -s arch/mips/pci/built-in.o \
>     drivers/pci/built-in.o vmlinux.o | grep pcibios_get_phb_of_node
>       93: 0000046c    12 FUNC    GLOBAL DEFAULT    2 pcibios_get_phb_of_node
>     1433: 00012a2c   104 FUNC    WEAK   DEFAULT    2 pcibios_get_phb_of_node
>    31863: 001d4dbc    12 FUNC    GLOBAL DEFAULT    2 pcibios_get_phb_of_node
>   $
>
> For completeness, I have compiled it for X64 and for powerpc as well. I did not
> try to run these kernels, but the output of readelf seems to be ok:
>
>   $ readelf -s arch/x86/kernel/built-in.o drivers/pci/built-in.o vmlinux.o | \
>     grep pcibios_get_phb_of_node
>     2761: 000273a0    86 FUNC    GLOBAL DEFAULT    1 pcibios_get_phb_of_node
>     1705: 00018770    77 FUNC    WEAK   DEFAULT    1 pcibios_get_phb_of_node
>    60364: 000278a0    86 FUNC    GLOBAL DEFAULT    1 pcibios_get_phb_of_node
>   $
>
>   $ powerpc-openwrt-linux-readelf -s arch/powerpc/kernel/built-in.o \
>     drivers/pci/built-in.o  vmlinux.o | grep pcibios_get_phb_of_node
>     1002: 0000ca28    12 FUNC    GLOBAL DEFAULT    1 pcibios_get_phb_of_node
>     1485: 0001453c    88 FUNC    WEAK   DEFAULT    1 pcibios_get_phb_of_node
>    28959: 0000d598    12 FUNC    GLOBAL DEFAULT    1 pcibios_get_phb_of_node
>   $
>
>> Or if you prefer, you can take them through the MIPS tree.
>
> Either is fine.

Thanks for checking these out!  I put them in my "next" branch and
pushed it, so they should appear in v3.10.

Bjorn
