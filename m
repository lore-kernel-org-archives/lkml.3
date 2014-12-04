Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaLDN3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:29:46 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:63159 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbaLDN3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:29:44 -0500
MIME-Version: 1.0
In-Reply-To: <548013B0.4080108@ti.com>
References: <1417039645-5313-1-git-send-email-prabhakar.csengg@gmail.com>
	<547EF8CC.9030502@ti.com>
	<CA+V-a8vnv4B77XvbzwNkJk=vqGCFWoXxFoyUf0ZNiKwa+gY2ug@mail.gmail.com>
	<548007CA.7010900@ti.com>
	<20141204074641.GB4311@sudip-PC>
	<548013B0.4080108@ti.com>
Date: Thu, 4 Dec 2014 14:29:42 +0100
X-Google-Sender-Auth: w23sdLn3ReTxZrzGyM6zteQIkOk
Message-ID: <CAMuHMdX6rbaPYFpSR7nGf6Di0G=cGL9yFZLLpjUDi7TLyu1wmw@mail.gmail.com>
Subject: Re: [PATCH 1/3] video: fbdev: vt8623fb: suppress build warning
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 8:56 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 04/12/14 09:46, Sudip Mukherjee wrote:
>> On Thu, Dec 04, 2014 at 09:05:46AM +0200, Tomi Valkeinen wrote:
>>> On 03/12/14 20:29, Prabhakar Lad wrote:
>>>> On Wed, Dec 3, 2014 at 11:49 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
>>>>> On 27/11/14 00:07, Lad, Prabhakar wrote:
>>>>>> this patch fixes following build warning:
>>>>>> drivers/video/fbdev/vt8623fb.c: In function ‘vt8623_pci_probe’:
>>>>>> drivers/video/fbdev/vt8623fb.c:734:23: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>>>>>>   par->state.vgabase = (void __iomem *) vga_res.start;
>>>>>>                        ^
>>>>>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>>>> ---
>>>>>>  drivers/video/fbdev/vt8623fb.c | 2 +-
>>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/drivers/video/fbdev/vt8623fb.c b/drivers/video/fbdev/vt8623fb.c
>>>>>> index 5c7cbc6..ea7f056 100644
>>>>>> --- a/drivers/video/fbdev/vt8623fb.c
>>>>>> +++ b/drivers/video/fbdev/vt8623fb.c
>>>>>> @@ -731,7 +731,7 @@ static int vt8623_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
>>>>>>
>>>>>>       pcibios_bus_to_resource(dev->bus, &vga_res, &bus_reg);
>>>>>>
>>>>>> -     par->state.vgabase = (void __iomem *) vga_res.start;
>>>>>> +     par->state.vgabase = (void __iomem *) (unsigned long) vga_res.start;
>>>>>
>>>>> This does look quite ugly... Where does the warning come from in the
>>>>> first place. Isn't vga_res.start (resource_size_t) the size of a pointer?
>>>>>
>>>> Yes looks ugly, I am not sure what you meant from 'where does this warning
>>>> come from' its in the commit message.
>>>
>>> I meant why is there a warning at all. With a quick glance,
>>> vga_res.start is the size of a pointer. So the sizes of the integer and
>>> the pointer should be the same. But the warning still says "of different
>>> size".
>>
>> poking my nose into your discussion.
>> I tried to see the warning, and I re-compiled like make W=1 M=drivers/video/fbdev/ (before that make clean M=drivers/video/fbdev was done)
>> I can see warning with many other files, but drivers/video/fbdev/vt8623fb.o was quiet and there was no warning.
>> I tested with next=20141203.
>> did i miss something in checking the warning ?
>
> I don't see the warning either when compiling for arm or x86_64. On what
> architecture do you see the warning?

On 32-bit systems with PHYS_ADDR_T_64BIT=y, resource_size_t is u64,
while pointers are still 32-bit.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
