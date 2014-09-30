Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaI3N21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 09:28:27 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:44885 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaI3N2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 09:28:25 -0400
MIME-Version: 1.0
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D174A1012@AcuExch.aculab.com>
References: <1411667317-1163-1-git-send-email-santosh.shilimkar@ti.com>
	<1411667317-1163-3-git-send-email-santosh.shilimkar@ti.com>
	<20140929.155200.2231132602322345812.davem@davemloft.net>
	<063D6719AE5E284EB5DD2968C1650D6D174A1012@AcuExch.aculab.com>
Date: Tue, 30 Sep 2014 15:28:23 +0200
X-Google-Sender-Auth: sdNce71XPQ94vFoT2gqvKFk0evw
Message-ID: <CAMuHMdXe2H4qfX4X4GDzJSgoWzu-BrvRL6KoZagepY1GYEA4Ag@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] net: Add Keystone NetCP ethernet driver
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Laight <David.Laight@aculab.com>
Cc: David Miller <davem@davemloft.net>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "sandeep_n@ti.com" <sandeep_n@ti.com>,
        "joe@perches.com" <joe@perches.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 3:09 PM, David Laight <David.Laight@aculab.com> wrote:
>> > +static inline int gbe_phy_link_status(struct gbe_slave *slave)
>> > +{
>> > +   if (!slave->phy)
>> > +           return 1;
>> > +
>> > +   if (slave->phy->link)
>> > +           return 1;
>> > +
>> > +   return 0;
>> > +}
>>
>> Please use 'bool' as the return type and return 'true' or 'false'.
>
> That function body could also be just:
>         return !slave->phy && slave->phy->link;
> which might be more readable if directly coded.

return !slave->phy || slave->phy->link;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
