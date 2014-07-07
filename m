Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbaGGUgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 16:36:40 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62991 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaGGUgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 16:36:38 -0400
MIME-Version: 1.0
In-Reply-To: <53BA66F6.9020605@tronnes.org>
References: <1404422121-11298-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140707075709.GI25934@mwanda>
	<53BA66F6.9020605@tronnes.org>
Date: Mon, 7 Jul 2014 22:36:38 +0200
Message-ID: <CAFo99gZWpzCNMAvHbibRnWhiJh+GuZXBgnx7AWq76R5fgJvLFg@mail.gmail.com>
Subject: Re: [PATCH] video: fbdev: sis: init.c: Cleaning up redundant
 condition is always true
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Noralf Tronnes <notro@tronnes.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-07 11:23 GMT+02:00 Noralf Tronnes <notro@tronnes.org>:
> Den 07.07.2014 09:57, skrev Dan Carpenter:
>
>> On Thu, Jul 03, 2014 at 11:15:21PM +0200, Rickard Strandqvist wrote:
>>>
>>> diff --git a/drivers/video/fbdev/sis/init.c
>>> b/drivers/video/fbdev/sis/init.c
>>> index bd40f5e..9e2dd96 100644
>>> --- a/drivers/video/fbdev/sis/init.c
>>> +++ b/drivers/video/fbdev/sis/init.c
>>> @@ -355,12 +355,12 @@ SiS_GetModeID(int VGAEngine, unsigned int VBFlags,
>>> int HDisplay, int VDisplay,
>>>                 }
>>>                 break;
>>>         case 400:
>>> -               if((!(VBFlags & CRT1_LCDA)) || ((LCDwidth >= 800) &&
>>> (LCDwidth >= 600))) {
>>> +               if ((!(VBFlags & CRT1_LCDA)) || (LCDwidth >= 600)) {
>>
>>
>> It might be that this was supposed to be:
>>
>>                 if((!(VBFlags & CRT1_LCDA)) || ((LCDwidth <= 800) &&
>> (LCDwidth >= 600))) {
>>
>> But why would people write a range from high to low?  That's crazy
>> people who write backwards code...
>
> The numbers 800x600 (1024x768) indicate that LCDheight is meant to be used:
>                  if((!(VBFlags & CRT1_LCDA)) || ((LCDwidth >= 800) &&
> (LCDheight >= 600))) {
>
> regards,
> Noralf Tronnes

Hi

Nice, this is what is the point of fix this type of minor errors.
Sometimes you can find something more serious :)

New patch on the way!

Kind regards
Rickard Strandqvist
