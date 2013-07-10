Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab3GJUuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 16:50:13 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:36207 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab3GJUuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 16:50:11 -0400
MIME-Version: 1.0
In-Reply-To: <20130709124900.GG11908@titan.lakedaemon.net>
References: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
	<1373352166-10064-2-git-send-email-zhangwm@marvell.com>
	<20130709124900.GG11908@titan.lakedaemon.net>
Date: Wed, 10 Jul 2013 15:50:10 -0500
Message-ID: <CAHCPf3u=Zu2-4RsWzi17rB_FmStwcf-Pt_7oRzAEnxN_w=a7cA@mail.gmail.com>
Subject: Re: [PATCH V3 1/3] dts: change Marvell prefix to 'marvell'
From: Matt Sealey <neko@bakuhatsu.net>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Neil Zhang <zhangwm@marvell.com>, grant.likely@linaro.org,
        haojian.zhuang@gmail.com, arnd@arndb.de,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 9, 2013 at 7:49 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> Neil,
>
> I agree with the need to change, however, this has been in the binding
> documentation since v3.5.  I wish we had caught this when we decided
> against using stock ticker symbols (not all stock markets use
> alphabetical abbreviated names, not all companies are listed on any
> stock exchange).

Who decided that?

You can't just "stop using stock ticker symbols" - FDT is inherently
based on the original OpenFirmware device tree and therefore any
existing bindings which are done on real OpenFirmware solutions where
using stock ticker symbols is entirely appropriate (although, these
days, not useful) is counter-productive.

If Marvell had originally had mrvl as their ticker, and used this in
OF DTs (and it is..), then mrvl it stays. In the case where new
devices are added with marvell, this is in this case wrong. You should
keep using the old one. A good example of this; Freescale. Nobody is
saying everyone should move to "freescale,imx-this" or
"freescale,vybrid-that" - it's fsl and it stays fsl for
backwards/forwards compatibility because things exist already.

Any new companies can have a long, descriptive name; a privilege of
being late to the party, you might say :)

Having an odd mix of mrvl and marvell or moving to marvell is just
completely obtuse, whether they had that stock ticker, will have it in
the future, it is how they're defined and you can't in good conscience
change the binding after devices ship with it.

> To do this properly, the drivers are going to have to be compatible with
> the old and the new names, and the binding docs updated to reflect the
> legacy name and the preferred name.

Properly would be as above. You can stop using stock tickers for new
company names, but anything that has been defined in a device tree
before has to stay that way, and all the manufacturer prefixes to
device names should be the same. What you're proposing is purely
driver bloat and increasing the size of kernel.

--
Matt Sealey <neko@bakuhatsu.net>
