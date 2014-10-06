Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaJFJfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 05:35:36 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:52383 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751482AbaJFJfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 05:35:32 -0400
Message-ID: <1412588130.4054.49.camel@x220>
Subject: Re: [PATCH 3/4] [media] Remove optional dependency on PLAT_S5P
From: Paul Bolle <pebolle@tiscali.nl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valentin Rothberg <valentinrothberg@gmail.com>
Date: Mon, 06 Oct 2014 11:35:30 +0200
In-Reply-To: <4788945.SoI4OqN9Zu@wuerfel>
References: <1412586626.4054.42.camel@x220> <4788945.SoI4OqN9Zu@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2014 09:35:30.0977 (UTC) FILETIME=[DEDA3110:01CFE148]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-06 at 11:26 +0200, Arnd Bergmann wrote:
> On Monday 06 October 2014 11:10:26 Paul Bolle wrote:
> >  config VIDEO_SAMSUNG_S5P_TV
> >         bool "Samsung TV driver for S5P platform"
> >         depends on PM_RUNTIME
> > -       depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
> > +       depends on ARCH_EXYNOS || COMPILE_TEST
> >         default n
> >         ---help---
> >           Say Y here to enable selecting the TV output devices for
> > 
> 
> I wonder if it should now allow being built for ARCH_S5PV210.

That was what Tomasz Figa claimed in
http://lkml.kernel.org/r/53C676DB.6070002@samsung.com

> Maybe it was a mistake to remove the PLAT_S5P symbol without changing
> the use here?

At least it was a bit sloppy to remove the symbol without touching this
(and six other) dependencies. But after nearly three months I lost
patience waiting for a fix to be submitted.

My cleanup doesn't really change a thing. And a proper fix, if needed,
is still possible after this has landed.

> Does S5PV210 have this device?


Paul Bolle

