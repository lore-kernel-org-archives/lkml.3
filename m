Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab3HVHSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:18:51 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:44356 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab3HVHSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:18:49 -0400
Date: Thu, 22 Aug 2013 08:18:43 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 05/13] ARM: ux500: Apply a ste-* prefix onto snowball.dts
Message-ID: <20130822071843.GA22023@lee--X1>
References: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
 <1374243229-8585-6-git-send-email-lee.jones@linaro.org>
 <CAOesGMgd51g7WAkQu+ckT-=skKuMyj19nJkHxh+YmGSBhSL+Vg@mail.gmail.com>
 <CACRpkdasMSCfdhzrW+7kHM8UUxxQ5UMAcc5bOogc-9RwXE9RVg@mail.gmail.com>
 <CAOesGMgZYFgwAhVCc-ObnxcmGTLTM-Zk27Dh7r1_p646ULWHeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOesGMgZYFgwAhVCc-ObnxcmGTLTM-Zk27Dh7r1_p646ULWHeg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013, Olof Johansson wrote:

> On Wed, Aug 21, 2013 at 3:37 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Wed, Aug 21, 2013 at 2:31 AM, Olof Johansson <olof@lixom.net> wrote:
> >
> >>> diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/ste-snowball.dts
> >>> similarity index 100%
> >>> rename from arch/arm/boot/dts/snowball.dts
> >>> rename to arch/arm/boot/dts/ste-snowball.dts
> >>
> >> Grmbl, grmbl, grmbl. This now breaks any script that knows to use
> >> snowball.dtb. :(
> >>
> >> It's good to get the prefixes added, but it's annoying to have to deal
> >> with both during an overlap period. Maybe generate both dtb filenames
> >> for a while but rename the source?
> >
> > Hm I had the same problem but changed my Makefile
> > (scripts are too simple for me) like this:
> >
> >  dtb            := $(build_dir)/arch/arm/boot/dts/ste-hrefv60plus.dtb
> > +fallbackdtb    := $(build_dir)/arch/arm/boot/dts/hrefv60plus.dtb
> > (...)
> > -       cat $(dtb) >> $(output_dir)/zImage
> > +       if [ -f arch/arm/boot/dts/hrefv60plus.dts ] ; then \
> > +           cat $(fallbackdtb) >> $(output_dir)/zImage ; echo "fallback" ; \
> > +       else \
> > +           cat $(dtb) >> $(output_dir)/zImage ; \
> > +       fi
> 
> Sure, working around it is trivial. I just did a:
>    -@cp $</arch/arm/boot/dts/ste-snowball.dtb $</arch/arm/boot/dts/snowball.dtb
> 
> But the point is that everybody needs to do something like that now,
> which is unfortunate.

Well with only ~5 active users it's probably not that much of a big
deal anyway, but I'm still interested to know what the alternative is?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
