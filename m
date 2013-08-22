Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab3HVNVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 09:21:23 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:43855 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab3HVNVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 09:21:22 -0400
MIME-Version: 1.0
Date: Thu, 22 Aug 2013 18:51:21 +0530
Message-ID: <CAHbNUh0voFRBMfTT3gZwF1t7FKpJp+VD6xw8RCS=-rx36cZvfw@mail.gmail.com>
Subject: Build failure in drivers/pinctrl/pictrl-imx.c
From: Tushar Behera <tushar.behera@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

With 'allyesconfig' on next-20130822, we are getting a build failure here.

I am not sure about the fix, hence only reporting the issue here.

drivers/pinctrl/pinctrl-imx.c: In function ‘imx_pinctrl_parse_groups’:
drivers/pinctrl/pinctrl-imx.c:35:5: error: incompatible types when
assigning to type ‘int’ from type ‘struct imx_pin’
   j = p[i];    \
     ^
drivers/pinctrl/pinctrl-imx.c:504:2: note: in expansion of macro ‘IMX_PMX_DUMP’
  IMX_PMX_DUMP(info, grp->pins, grp->mux_mode, grp->configs, grp->npins);
  ^
drivers/pinctrl/pinctrl-imx.c:504:35: error: ‘struct imx_pin_group’
has no member named ‘mux_mode’
  IMX_PMX_DUMP(info, grp->pins, grp->mux_mode, grp->configs, grp->npins);
                                   ^
drivers/pinctrl/pinctrl-imx.c:38:4: note: in definition of macro ‘IMX_PMX_DUMP’
    m[i], c[i]);   \
    ^
drivers/pinctrl/pinctrl-imx.c:504:50: error: ‘struct imx_pin_group’
has no member named ‘configs’
  IMX_PMX_DUMP(info, grp->pins, grp->mux_mode, grp->configs, grp->npins);
                                                  ^
drivers/pinctrl/pinctrl-imx.c:38:10: note: in definition of macro ‘IMX_PMX_DUMP’
    m[i], c[i]);   \
          ^
make[2]: *** [drivers/pinctrl/pinctrl-imx.o] Error 1
make[1]: *** [drivers/pinctrl] Error 2
make: *** [drivers] Error 2


-- 
Tushar Behera
