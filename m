Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab3FRBKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 21:10:04 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:33165 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab3FRBKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 21:10:01 -0400
MIME-Version: 1.0
In-Reply-To: <3957298.MQ5NXOY1oH@dtor-d630.eng.vmware.com>
References: <1367809448-9437-1-git-send-email-chao.xie@marvell.com>
	<1367809448-9437-5-git-send-email-chao.xie@marvell.com>
	<5701258.F0sLjHKir2@wuerfel>
	<3957298.MQ5NXOY1oH@dtor-d630.eng.vmware.com>
Date: Tue, 18 Jun 2013 09:10:00 +0800
Message-ID: <CADApbeiiTU3gMUhS_U=o0q0S_iA50ab7GX0B1JS+6dp5reUtkw@mail.gmail.com>
Subject: Re: [PATCH V2 4/5] input: pxa27x-keypad: remove the unused members at
 platform data
From: Chao Xie <xiechao.mail@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Chao Xie <chao.xie@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, Haojian Zhuang <haojian.zhuang@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 1:07 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Monday, June 17, 2013 03:10:27 PM Arnd Bergmann wrote:
>> On Sunday 05 May 2013 23:04:07 Chao Xie wrote:
>> > Now pxa27x-keypad make use matrix_keymap for matrix keyes, so
>> > remove the unused members in platform data.
>> >
>> > Signed-off-by: Chao Xie <chao.xie@marvell.com>
>> > ---
>> >
>> >  include/linux/platform_data/keypad-pxa27x.h |    2 --
>> >  1 files changed, 0 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/include/linux/platform_data/keypad-pxa27x.h
>> > b/include/linux/platform_data/keypad-pxa27x.h index 0db423b..2462556
>> > 100644
>> > --- a/include/linux/platform_data/keypad-pxa27x.h
>> > +++ b/include/linux/platform_data/keypad-pxa27x.h
>> > @@ -39,8 +39,6 @@ struct pxa27x_keypad_platform_data {
>> >
>> >         const struct matrix_keymap_data *matrix_keymap_data;
>> >         unsigned int    matrix_key_rows;
>> >         unsigned int    matrix_key_cols;
>> >
>> > -       unsigned int    *matrix_key_map;
>> > -       int             matrix_key_map_size;
>> >
>> >         /* direct keys */
>> >         int             direct_key_num;
>>
>> This just broke a number of configurations:
>>
>> em_x270_defconfig
>> ezx_defconfig
>> palmz72_defconfig
>> pxa3xx_defconfig
>>
>> You have to make sure that all these board files get converted:
>>
>> arch/arm/mach-pxa/em-x270.c
>> arch/arm/mach-pxa/ezx.c
>> arch/arm/mach-pxa/littleton.c
>> arch/arm/mach-pxa/mainstone.c
>> arch/arm/mach-pxa/mioa701.c
>> arch/arm/mach-pxa/palmld.c
>> arch/arm/mach-pxa/palmt5.c
>> arch/arm/mach-pxa/palmtreo.c
>> arch/arm/mach-pxa/palmtx.c
>> arch/arm/mach-pxa/palmz72.c
>> arch/arm/mach-pxa/tavorevb.c
>> arch/arm/mach-pxa/z2.c
>> arch/arm/mach-pxa/zylonite.c
>>
>> or leave the code to interpret that platform data in place.
>
> Sorry about this, I'll drop the patch until it gets sorted out.
>
> Thanks.
>
I am sorry that i forget mach-pxa, i only changes mach-mmp.
I will do the samething for mach-pxa, and reset the patch.

> --
> Dmitry
