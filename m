Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbaE1HTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:19:05 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:59854 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaE1HTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:19:02 -0400
Date: Wed, 28 May 2014 08:18:55 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Rob Herring <robh@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>, Grant Likely <grant.likely@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, LKML <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v1] of/irq: do irq resolution in platform_get_irq_byname()
Message-ID: <20140528071855.GJ4227@lee--X1>
References: <1400582523-22684-1-git-send-email-grygorii.strashko@ti.com>
 <20140523080333.66720C4176E@trevor.secretlab.ca>
 <CAGa+x85mOHtNAj-UHgK2_z8zWAF=qwFcRcUgHTR-byNiX7heHA@mail.gmail.com>
 <CAL_JsqLm3wfVS+au+JUbhBhxz=LuVpepH6GxabCQhPowhbw77g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqLm3wfVS+au+JUbhBhxz=LuVpepH6GxabCQhPowhbw77g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014, Rob Herring wrote:

> On Tue, May 27, 2014 at 3:23 PM, Kevin Hilman <khilman@linaro.org> wrote:
> > On Fri, May 23, 2014 at 1:03 AM, Grant Likely <grant.likely@linaro.org> wrote:
> >> On Tue, 20 May 2014 13:42:02 +0300, Grygorii Strashko <grygorii.strashko@ti.com> wrote:
> >>> The commit 9ec36cafe43bf835f8f29273597a5b0cbc8267ef
> >>> "of/irq: do irq resolution in platform_get_irq" from Rob Herring -
> >>> moves resolving of the interrupt resources in platform_get_irq().
> >>> But this solution isn't complete because platform_get_irq_byname()
> >>> need to be modified the same way.
> >>>
> >>> Hence, fix it by adding interrupt resolution code at the
> >>> platform_get_irq_byname() function too.
> >>>
> >>> Cc: Russell King <linux@arm.linux.org.uk>
> >>> Cc: Rob Herring <robh@kernel.org>
> >>> Cc: Tony Lindgren <tony@atomide.com>
> >>> Cc: Grant Likely <grant.likely@linaro.org>
> >>> Cc: Thierry Reding <thierry.reding@gmail.com>
> >>>
> >>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> >>
> >> Applied, Thanks.
> >
> > As of next-20150526, the ST u8500 Snowball board has been failing boot
> > in linux-next, and was bisected down to this patch (commit
> > ad69674e73a1 in -next).   Full boot failure attached.
> >
> > I have not dug any deeper, but can confirm that next-20140526 with
> > this patch reverted boots again on the snowball board.
> 
> There's a patch on the list which fixes it. The problem is stmmac
> driver was expecting only one error code.

Does Snowball even use stmmac?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
