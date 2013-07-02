Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab3GBJQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 05:16:20 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:35436 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257Ab3GBJQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 05:16:18 -0400
MIME-Version: 1.0
In-Reply-To: <51CADA58.2030602@ti.com>
References: <1368688257-18705-1-git-send-email-prabhakar.csengg@gmail.com>
 <1368688257-18705-3-git-send-email-prabhakar.csengg@gmail.com>
 <51CAD305.30407@ti.com> <CA+V-a8uhK5-QJKifkiSUN6Nz0aBc2moraWQUJPCmZg9zaFX0eg@mail.gmail.com>
 <51CAD7E4.2000403@ti.com> <CA+V-a8u6vjSc5EV3z4FCQ8LEHxL79bUXtHzX8svhQwqVtj6w=g@mail.gmail.com>
 <51CADA58.2030602@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 2 Jul 2013 14:45:57 +0530
Message-ID: <CA+V-a8vij-4s1FsePmSZrdUTBZJPWZV6Wq9s=uurOHh2k47JNA@mail.gmail.com>
Subject: Re: [PATCH 2/2] video:da8xx-fb: Convert to devm_* api
To: "Etheridge, Darren" <detheridge@ti.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darren,

On Wed, Jun 26, 2013 at 5:41 PM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 26/06/13 15:06, Prabhakar Lad wrote:
>> Hi Tomi,
>>
>> On Wed, Jun 26, 2013 at 5:30 PM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
>>> On 26/06/13 14:56, Prabhakar Lad wrote:
>>>> Hi Tomi,
>>>>
>>>> On Wed, Jun 26, 2013 at 5:09 PM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
>>>>> On 16/05/13 10:10, Lad Prabhakar wrote:
>>>>>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>>>>
>>>>>> Use devm_ioremap_resource instead of reques_mem_region()/ioremap() and
>>>>>> devm_request_irq() instead of request_irq().
>>>>>>
>>>>>> This ensures more consistent error values and simplifies error paths.
>>>>>>
>>>>>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>>>> ---
>>>>>>  drivers/video/da8xx-fb.c |   39 +++++++--------------------------------
>>>>>>  1 files changed, 7 insertions(+), 32 deletions(-)
>>>>>
>>>>> There's something similar in Darren's da8xx-fb series. Can you check if
>>>>> there are differences?
>>>>>
>>>> I don't see similar changes in his patch series.
>>>
>>> [PATCH 14/23] video: da8xx-fb: use devres
>>>
>> Oops missed it out :), patch is almost similar except
>> for following block,
>>
>> -       fb_clk = clk_get(&device->dev, "fck");
>> +       fb_clk = devm_clk_get(&device->dev, "fck");
>>         if (IS_ERR(fb_clk)) {
>>                 dev_err(&device->dev, "Can not get device clock\n");
>> -               ret = -ENODEV;
>> -               goto err_ioremap;
>> +               return -ENODEV;
>>         }
>>
>> How do you suggest to handle it ?
>
> I think it's easiest if Darren handles the da8xx-fb series for 3.11. So
> if there's something missing from Darren's series, please discuss with him.
>
Either you merge this patch with yours or rebase your patch on top of my patch.
Let me know how you would like to handle it ?

Regards,
--Prabhakar Lad
