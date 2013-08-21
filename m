Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab3HUIRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 04:17:33 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36187 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab3HUIRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 04:17:30 -0400
Date: Wed, 21 Aug 2013 09:17:20 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH 28/33] ARM: ux500: Remove AUXDATA relating to MSP (Audio)
 clock-name bindings
Message-ID: <20130821081720.GA29850@lee--X1>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
 <1370521041-32318-29-git-send-email-lee.jones@linaro.org>
 <CACRpkdYE7SgJiacneBq=cZ=7dAO2x3sBscFW075cDODxesYUWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYE7SgJiacneBq=cZ=7dAO2x3sBscFW075cDODxesYUWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013, Linus Walleij wrote:

> On Thu, Jun 6, 2013 at 2:17 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > @@ -232,15 +232,6 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
> >         /* Requires device name bindings. */
> >         OF_DEV_AUXDATA("stericsson,db8500-pinctrl", U8500_PRCMU_BASE,
> >                 "pinctrl-db8500", NULL),
> > -       /* Requires clock name and DMA bindings. */
> 
> The comment is just wrong.
> 
> > -       OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80123000,
> > -               "ux500-msp-i2s.0", &msp0_platform_data),
> 
> Look, it also adds &msp0_platform_data, which is vital.
> 
> Result after boot:
> ALSA device list:
>   No soundcards found.
> 
> Before the patch set we had audio and I kind of liked it :-)
> 
> I think you're able to set the device name as NULL though so
> we only add this platform data, try it out.

Makes sense. Although, I don't think there is a need to change the
device name. I'll just put it under the a different heading of
"Requires DMA bindings".

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
