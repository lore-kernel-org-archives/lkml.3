Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab3HUXW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 19:22:27 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:41753 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3HUXW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 19:22:26 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <CACRpkdasMSCfdhzrW+7kHM8UUxxQ5UMAcc5bOogc-9RwXE9RVg@mail.gmail.com>
References: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
	<1374243229-8585-6-git-send-email-lee.jones@linaro.org>
	<CAOesGMgd51g7WAkQu+ckT-=skKuMyj19nJkHxh+YmGSBhSL+Vg@mail.gmail.com>
	<CACRpkdasMSCfdhzrW+7kHM8UUxxQ5UMAcc5bOogc-9RwXE9RVg@mail.gmail.com>
Date: Wed, 21 Aug 2013 16:22:26 -0700
Message-ID: <CAOesGMgZYFgwAhVCc-ObnxcmGTLTM-Zk27Dh7r1_p646ULWHeg@mail.gmail.com>
Subject: Re: [PATCH 05/13] ARM: ux500: Apply a ste-* prefix onto snowball.dts
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 3:37 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Aug 21, 2013 at 2:31 AM, Olof Johansson <olof@lixom.net> wrote:
>
>>> diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/ste-snowball.dts
>>> similarity index 100%
>>> rename from arch/arm/boot/dts/snowball.dts
>>> rename to arch/arm/boot/dts/ste-snowball.dts
>>
>> Grmbl, grmbl, grmbl. This now breaks any script that knows to use
>> snowball.dtb. :(
>>
>> It's good to get the prefixes added, but it's annoying to have to deal
>> with both during an overlap period. Maybe generate both dtb filenames
>> for a while but rename the source?
>
> Hm I had the same problem but changed my Makefile
> (scripts are too simple for me) like this:
>
>  dtb            := $(build_dir)/arch/arm/boot/dts/ste-hrefv60plus.dtb
> +fallbackdtb    := $(build_dir)/arch/arm/boot/dts/hrefv60plus.dtb
> (...)
> -       cat $(dtb) >> $(output_dir)/zImage
> +       if [ -f arch/arm/boot/dts/hrefv60plus.dts ] ; then \
> +           cat $(fallbackdtb) >> $(output_dir)/zImage ; echo "fallback" ; \
> +       else \
> +           cat $(dtb) >> $(output_dir)/zImage ; \
> +       fi

Sure, working around it is trivial. I just did a:
   -@cp $</arch/arm/boot/dts/ste-snowball.dtb $</arch/arm/boot/dts/snowball.dtb

But the point is that everybody needs to do something like that now,
which is unfortunate.


-Olof
