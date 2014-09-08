Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbaIHVuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:50:23 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:35077 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbaIHVuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:50:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140908141035.GK22290@redhat.com>
References: <cover.1408051536.git.luto@amacapital.net> <59f55d679cc596731589516a71075b6059fcaaa5.1408051536.git.luto@amacapital.net>
 <20140908141035.GK22290@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 8 Sep 2014 14:49:59 -0700
Message-ID: <CALCETrX3KO=1T1m4Qwn+j7vqqhEuNb8Xdkf_c2Ne4P9AbpwOoA@mail.gmail.com>
Subject: Re: [PATCH 2/2] sb_edac: Claim a different PCI device
To: Aristeu Rozanski <aris@redhat.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Borislav Petkov <bp@alien8.de>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-edac@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rui Wang <ruiv.wang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2014 at 7:10 AM, Aristeu Rozanski <aris@redhat.com> wrote:
> On Thu, Aug 14, 2014 at 02:45:41PM -0700, Andy Lutomirski wrote:
>> sb_edac controls a large number of different PCI functions.  Rather
>> than registering as a normal PCI driver for all of them, it
>> registers for just one so that it gets probed and, at probe time, it
>> looks for all the others.
>>
>> Coincidentally, the device it registers for also contains the SMBUS
>> registers, so the PCI core will refuse to probe both sb_edac and a
>> future iMC SMBUS driver.  The drivers don't actually conflict, so
>> just change sb_edac's device table to probe a different device.
>>
>> An alternative fix would be to merge the two drivers, but sb_edac
>> will also refuse to load on non-ECC systems, whereas i2c_imc would
>> still be useful without ECC.
>>
>> The only user-visible change should be that sb_edac appears to bind
>> a different device.
>>
>> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
>> Cc: Rui Wang <ruiv.wang@gmail.com>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>  drivers/edac/sb_edac.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
>> index a2597e9313c6..e3bc2cced580 100644
>> --- a/drivers/edac/sb_edac.c
>> +++ b/drivers/edac/sb_edac.c
>> @@ -432,7 +432,7 @@ static const struct pci_id_table pci_dev_descr_ibridge_table[] = {
>>   *   pci_device_id   table for which devices we are looking for
>>   */
>>  static const struct pci_device_id sbridge_pci_tbl[] = {
>> -     {PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TA)},
>> +     {PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_HA0)},
>>       {PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IBRIDGE_IMC_HA0_TA)},
>>       {0,}                    /* 0 terminated list. */
>>  };
>
> Acked-by: Aristeu Rozanski <aris@redhat.com>
>

Whose tree will this go through?

FWIW, this git am can't apply this to 3.17-rc4, but git am --3way can,
and it's a one-liner in any case.  Should I send a trivially rebased
version?

--Andy

> --
> Aristeu
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
