Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab3CKQUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:20:44 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33581 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab3CKQUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:20:43 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:fd1c:91af:8cf4:88c4:7a10]
In-Reply-To: <1363016099.3348.47.camel@sauron.fi.intel.com>
References: <1363016099.3348.47.camel@sauron.fi.intel.com>
Date: Mon, 11 Mar 2013 09:20:41 -0700
Message-ID: <CAOesGMhy6YceRr3T4ZALhYeSQfEuASO+ajJy1Htwws=OMtvrTg@mail.gmail.com>
Subject: Re: Dead mappings and drivers in MTD
From: Olof Johansson <olof@lixom.net>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 8:34 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> Hi MTD folks,
>
> we have huge amount of drivers, espacially mapping drives in
> 'drivers/mtd', and for sure may of them are for ancient devices which
> are long dead and not supported by modern kernels anyway. I would like
> to do a small clean-up. It is difficult to judge which ones are dead for
> me, so I am asking the community to help. Thanks!
>
> There are few easy cases - some drivers depend on Kconfig symbols which
> are not defined anywhere - I guess these are clear candidates for
> removal. For example this one:
>
> config MTD_DBOX2
>         tristate "CFI Flash device mapped on D-Box2"
>         depends on DBOX2 && MTD_CFI_INTELSTD && MTD_CFI_INTELEXT && MTD_CFI_AMDSTD
>         help
>           This enables access routines for the flash chips on the Nokia/Sagem
>           D-Box 2 board. If you have one of these boards and would like to use
>
> Grepping for "DBOX2" gives nothing.

In 2.6.14, it dropped two dependencies that used to be there for PPC32
and 8xx. There still was no DBOX2 symbol to fulfill that dependency
back then.

Take it out, if someone finds a user later on it can always be
reverted. Seems very very unlikely in this case.


-Olof
