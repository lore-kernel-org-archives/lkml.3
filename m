Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaLCSaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:30:08 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:32806 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaLCSaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:30:06 -0500
MIME-Version: 1.0
In-Reply-To: <547EF8CC.9030502@ti.com>
References: <1417039645-5313-1-git-send-email-prabhakar.csengg@gmail.com> <547EF8CC.9030502@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 3 Dec 2014 18:29:34 +0000
Message-ID: <CA+V-a8vnv4B77XvbzwNkJk=vqGCFWoXxFoyUf0ZNiKwa+gY2ug@mail.gmail.com>
Subject: Re: [PATCH 1/3] video: fbdev: vt8623fb: suppress build warning
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 11:49 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 27/11/14 00:07, Lad, Prabhakar wrote:
>> this patch fixes following build warning:
>> drivers/video/fbdev/vt8623fb.c: In function ‘vt8623_pci_probe’:
>> drivers/video/fbdev/vt8623fb.c:734:23: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>>   par->state.vgabase = (void __iomem *) vga_res.start;
>>                        ^
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  drivers/video/fbdev/vt8623fb.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/video/fbdev/vt8623fb.c b/drivers/video/fbdev/vt8623fb.c
>> index 5c7cbc6..ea7f056 100644
>> --- a/drivers/video/fbdev/vt8623fb.c
>> +++ b/drivers/video/fbdev/vt8623fb.c
>> @@ -731,7 +731,7 @@ static int vt8623_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
>>
>>       pcibios_bus_to_resource(dev->bus, &vga_res, &bus_reg);
>>
>> -     par->state.vgabase = (void __iomem *) vga_res.start;
>> +     par->state.vgabase = (void __iomem *) (unsigned long) vga_res.start;
>
> This does look quite ugly... Where does the warning come from in the
> first place. Isn't vga_res.start (resource_size_t) the size of a pointer?
>
Yes looks ugly, I am not sure what you meant from 'where does this warning
come from' its in the commit message.

Thanks,
--Prabhakar Lad
