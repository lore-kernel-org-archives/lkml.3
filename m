Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbaBLHwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 02:52:34 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:34025 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaBLHwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 02:52:32 -0500
MIME-Version: 1.0
In-Reply-To: <1392156072.14317.26.camel@x220>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	<1391971686-9517-2-git-send-email-richard@nod.at>
	<20140211213054.GA2555@kroah.com>
	<1392156072.14317.26.camel@x220>
Date: Wed, 12 Feb 2014 08:52:31 +0100
X-Google-Sender-Auth: wwFWJTtSLXqODxA8N-A14FJZo9A
Message-ID: <CAMuHMdWYaaufCRgRT81ubPYWerf0huBcGO1G57Oqa_DxvfMr3g@mail.gmail.com>
Subject: Re: [PATCH 01/28] Remove CPU_MMP3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Weinberger <richard@nod.at>, Felipe Balbi <balbi@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "open list:USB PHY LAYER" <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc Yu Xu <yuxu@marvell.com>

On Tue, Feb 11, 2014 at 11:01 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Tue, 2014-02-11 at 13:30 -0800, Greg Kroah-Hartman wrote:
>> On Sun, Feb 09, 2014 at 07:47:39PM +0100, Richard Weinberger wrote:
>> > The symbol is an orphan, get rid of it.
>> >
>> > Signed-off-by: Richard Weinberger <richard@nod.at>
>> > Acked-by: Paul Bolle <pebolle@tiscali.nl>
>> >
>> > ---
>> >  drivers/usb/phy/Kconfig      | 1 -
>> >  drivers/video/mmp/Kconfig    | 2 +-
>> >  drivers/video/mmp/hw/Kconfig | 2 +-
>> >  3 files changed, 2 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
>> > index 7d1451d..b9b1c52 100644
>> > --- a/drivers/usb/phy/Kconfig
>> > +++ b/drivers/usb/phy/Kconfig
>> > @@ -61,7 +61,6 @@ config KEYSTONE_USB_PHY
>> >
>> >  config MV_U3D_PHY
>> >     bool "Marvell USB 3.0 PHY controller Driver"
>> > -   depends on CPU_MMP3
>> >     select USB_PHY
>> >     help
>> >       Enable this to support Marvell USB 3.0 phy controller for Marvell
>>
>> Do this and the driver breaks the build so it needs to depend on
>> something:
>>
>> drivers/usb/phy/phy-mv-u3d-usb.c: In function ‘mv_u3d_phy_read’:
>> drivers/usb/phy/phy-mv-u3d-usb.c:42:2: error: implicit declaration of function ‘writel_relaxed’ [-Werror=implicit-function-declaration]
>
> This sort of proves that a driver that depends on an unknown Kconfig
> symbol gets no build coverage (and will bit rot).
>
>> Sorry, I can't take this as-is.
>
> My mistake, I should have spotted this when looking a Richard's patch.
>
> Some background (which I quickly dug up): config MV_U3D_PHY got added in
> v3.7 through commit a67e76ac904c ("usb: phy: mv_u3d: Add usb phy driver
> for mv_u3d"). It then depended on USB_MV_U3D. And that symbol depended
> on CPU_MMP3 at that time. Ie, MV_U3D_PHY was unbuildable when it was
> added.
>
> In commit 60630c2eabd4 ("usb: gadget: mv_u3d: drop ARCH dependency")
> MV_U3D_PHY was made depended directly on  CPU_MMP3. That kept it
> unbuildable, of course.
>
> Richard, assuming you agree with the above short history of MV_U3D_PHY,
> would you mind sending a v2 that removes this unbuildable driver?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
