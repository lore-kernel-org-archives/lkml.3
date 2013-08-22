Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab3HVLdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:33:46 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39521 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab3HVLdo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:33:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130822085313.2e8b1ae6@armhf>
References: <20130821202646.47af66a5@armhf>
	<20130821223605.GA6617@n2100.arm.linux.org.uk>
	<20130822085313.2e8b1ae6@armhf>
Date: Thu, 22 Aug 2013 07:33:43 -0400
Message-ID: <CAF6AEGu6aFPaOTUPMZWhDgzCvG5L5Ok3Ld4QuJM4WZMtuVw6EQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/8] drm/i2c: tda998x: prepare for video input configuration
From: Rob Clark <robdclark@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        David Airlie <airlied@linux.ie>,
        Darren Etheridge <darren.etheridge@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 2:53 AM, Jean-Francois Moine <moinejf@free.fr> wrote:
> On Wed, 21 Aug 2013 23:36:05 +0100
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>
>> > AFAIK, the TI boards have no "pin-swapped", nor has the Cubox (there is
>> > no need to set the bit CFG_GRA_SWAPRB of the register LCD_SPU_DMA_CTRL0
>> > of the Dove lcd for RGB or YUV formats).
>> >
>> > Which board needs a special VIP configuration?
>>
>> If you run the NXP driver, and then run this driver, things get messed
>> up - which has already been covered months ago when this patch was first
>> brought up.
>>
>> It's there to ensure that the TDA998x is correctly configured no matter
>> what it's previous state is, and prevent the thing being fragile as hell.
>
> The NXP driver will never go to the mainline, so, I don't see the
> problem. If you want to use it to test some other drivers, you should
> better patch it instead of adding useless code in the TDA998x driver.

I don't think it really matters for the end user if NXP isn't
mainline.  If they are jumping between vendor kernel and mainline, and
inheriting some state left over from the NXP driver in vendor kernel,
it makes debugging very confusing.  It would be less of an issue if a
warm reset actually reset the tda998x part, but that is not the case,
it is better to rely less on the hw state when the driver is loaded,
IMHO.

BR,
-R


>> No, reset doesn't restore its settings, only a power cycle does.
>
> Sorry, all VIP control registers may be changed at any time and the
> change appears immediately (thank you for the /sys i2c_read/write).
>
> --
> Ken ar c'hentañ |             ** Breizh ha Linux atav! **
> Jef             |               http://moinejf.free.fr/
