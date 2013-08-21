Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab3HUWhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:37:09 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:37487 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab3HUWhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:37:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMgd51g7WAkQu+ckT-=skKuMyj19nJkHxh+YmGSBhSL+Vg@mail.gmail.com>
References: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
	<1374243229-8585-6-git-send-email-lee.jones@linaro.org>
	<CAOesGMgd51g7WAkQu+ckT-=skKuMyj19nJkHxh+YmGSBhSL+Vg@mail.gmail.com>
Date: Thu, 22 Aug 2013 00:37:05 +0200
Message-ID: <CACRpkdasMSCfdhzrW+7kHM8UUxxQ5UMAcc5bOogc-9RwXE9RVg@mail.gmail.com>
Subject: Re: [PATCH 05/13] ARM: ux500: Apply a ste-* prefix onto snowball.dts
From: Linus Walleij <linus.walleij@linaro.org>
To: Olof Johansson <olof@lixom.net>
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

On Wed, Aug 21, 2013 at 2:31 AM, Olof Johansson <olof@lixom.net> wrote:

>> diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/ste-snowball.dts
>> similarity index 100%
>> rename from arch/arm/boot/dts/snowball.dts
>> rename to arch/arm/boot/dts/ste-snowball.dts
>
> Grmbl, grmbl, grmbl. This now breaks any script that knows to use
> snowball.dtb. :(
>
> It's good to get the prefixes added, but it's annoying to have to deal
> with both during an overlap period. Maybe generate both dtb filenames
> for a while but rename the source?

Hm I had the same problem but changed my Makefile
(scripts are too simple for me) like this:

 dtb            := $(build_dir)/arch/arm/boot/dts/ste-hrefv60plus.dtb
+fallbackdtb    := $(build_dir)/arch/arm/boot/dts/hrefv60plus.dtb
(...)
-       cat $(dtb) >> $(output_dir)/zImage
+       if [ -f arch/arm/boot/dts/hrefv60plus.dts ] ; then \
+           cat $(fallbackdtb) >> $(output_dir)/zImage ; echo "fallback" ; \
+       else \
+           cat $(dtb) >> $(output_dir)/zImage ; \
+       fi

Yours,
Linus Walleij
