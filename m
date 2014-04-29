Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbaD2IW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:22:28 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35513 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaD2IWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:22:25 -0400
MIME-Version: 1.0
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825E1F7CD@P3PWEX4MB008.ex4.secureserver.net>
References: <1398562558-5354-1-git-send-email-chase.southwood@gmail.com>
	<1398562636-5900-1-git-send-email-chase.southwood@gmail.com>
	<DC148C5AA1CEBA4E87973D432B1C2D8825E1F7CD@P3PWEX4MB008.ex4.secureserver.net>
Date: Tue, 29 Apr 2014 03:22:25 -0500
Message-ID: <CA+jnaaWncaLVkW0BZup6cNkGmc39msXe2SiP=CmY2df2yc6ZAg@mail.gmail.com>
Subject: Re: [PATCH 4/6] staging: comedi: addi_apci_1564: simplify the PCI bar
 reading and don't read the unused bars
From: Chase Southwood <chase.southwood@gmail.com>
To: Hartley Sweeten <HartleyS@visionengravers.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hartley and Ian,

Yes, I had a feeling I should have gone with what was present, but my
desire to follow the documentation I wasn't too familiar with won out
:P

I'll spin a new revision of this patchset ASAP with this changed back
and all of my bad titles (oof...) fixed as well and I'll make sure to
be more careful in the future.

Thanks your all of the assistance and patience,
Chase

On Mon, Apr 28, 2014 at 1:09 PM, Hartley Sweeten
<HartleyS@visionengravers.com> wrote:
> On Saturday, April 26, 2014 6:37 PM, Chase Southwood wrote:
>> This driver only uses PCI bar 1 (devpriv->i_IobaseAmcc), and PCI bar 2
>> (dev->iobase) doon't bother reading the unused PCI bars.
>>
>> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
>> Cc: Ian Abbott <abbotti@mev.co.uk>
>> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
>> ---
>>
>> Hartley,
>>
>> As far as I can tell from reading the I/O Mapping you sent me, these bar
>> numbers are correct, but it seems a bit odd, so please offer correction
>> if I am interpreting the document incorrectly.
>>
>> Thanks,
>> Chase
>>
>>  drivers/staging/comedi/drivers/addi_apci_1564.c | 11 ++---------
>>  1 file changed, 2 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
>> index fe42f9d..7e42d47 100644
>> --- a/drivers/staging/comedi/drivers/addi_apci_1564.c
>> +++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
>> @@ -65,15 +65,8 @@ static int apci1564_auto_attach(struct comedi_device *dev,
>>       if (ret)
>>               return ret;
>>
>> -     if (this_board->i_IorangeBase1)
>> -             dev->iobase = pci_resource_start(pcidev, 1);
>> -     else
>> -             dev->iobase = pci_resource_start(pcidev, 0);
>> -
>> -     devpriv->iobase = dev->iobase;
>> -     devpriv->i_IobaseAmcc = pci_resource_start(pcidev, 0);
>> -     devpriv->i_IobaseAddon = pci_resource_start(pcidev, 2);
>> -     devpriv->i_IobaseReserved = pci_resource_start(pcidev, 3);
>> +     dev->iobase = pci_resource_start(pcidev, 2);
>> +     devpriv->i_IobaseAmcc = pci_resource_start(pcidev, 1);
>>
>>       /* Initialize parameters that can be overridden in EEPROM */
>>       devpriv->s_EeParameters.i_NbrAiChannel = this_board->i_NbrAiChannel;
>
> The document I sent you from ADDI-DATA does show that the I/O map revision can
> be determined by reading the "Header EEPROM" at BAR1 + 0x00. This seems to
> verify Ian's comment about earlier versions of the board having a different mapping.
>
> As Ian already mentioned. It's probably best to leave the PCI bar resource mapping
> as it currently is. If anyone reports an issue it can be addressed later.
>
> Regards,
> Hartley
>
