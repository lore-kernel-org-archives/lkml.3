Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbaEHPQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:16:34 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:55290 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaEHPQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:16:32 -0400
MIME-Version: 1.0
In-Reply-To: <536B9D78.5000602@codethink.co.uk>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
	<1399560990-1402858-1-git-send-email-arnd@arndb.de>
	<1399560990-1402858-14-git-send-email-arnd@arndb.de>
	<536B9D78.5000602@codethink.co.uk>
Date: Thu, 8 May 2014 17:16:32 +0200
X-Google-Sender-Auth: ApCGvElSj-ptY5JxeLSxb8Z-jew
Message-ID: <CAMuHMdWBzBneDqyDxK5HU3Bt_5CyRfTM_f_6YGJHokG_v17_sw@mail.gmail.com>
Subject: Re: [PATCH] pci: rcar host needs OF
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Magnus Damm <damm@opensource.se>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2014 at 5:06 PM, Ben Dooks <ben.dooks@codethink.co.uk> wrote:
> On 08/05/14 15:56, Arnd Bergmann wrote:
>>
>> The pci-rcar driver is enabled for compile tests, and this has
>> now shown that the driver cannot build without CONFIG_OF,
>> following the inclusion of f8f2fe7355fb "PCI: rcar: Use new OF
>> interrupt mapping when possible":
>>
>> drivers/built-in.o: In function `rcar_pci_map_irq':
>> :(.text+0x1cc7c): undefined reference to `of_irq_parse_and_map_pci'
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> Cc: Magnus Damm <damm@opensource.se>
>> Cc: linux-pci@vger.kernel.org
>> Cc: linux-sh@vger.kernel.org
>> ---
>>   drivers/pci/host/Kconfig | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
>> index fbbef0b..4675f47 100644
>> --- a/drivers/pci/host/Kconfig
>> +++ b/drivers/pci/host/Kconfig
>> @@ -27,7 +27,7 @@ config PCI_TEGRA
>>
>>   config PCI_RCAR_GEN2
>>         bool "Renesas R-Car Gen2 Internal PCI controller"
>> -       depends on ARCH_SHMOBILE || (ARM && COMPILE_TEST)
>> +       depends on ARCH_SHMOBILE || (ARM && OF && COMPILE_TEST)
>>         help
>>           Say Y here if you want internal PCI support on R-Car Gen2 SoC.
>>           There are 3 internal PCI controllers available with a single
>>
>
> This driver /should/ be able to be built for just the platform case
> so it sounds like f8f2fe7355fb stopped this but no-one has yet to
> notice.

You mean include/linux/of_pci.h should provide a dummy version of
of_irq_parse_and_map_pci() returning 0 in case OF=n?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
