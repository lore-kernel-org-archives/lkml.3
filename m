Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbaKSKOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:14:30 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:40826 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767AbaKSKOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:14:24 -0500
MIME-Version: 1.0
In-Reply-To: <20141107234628.4923.60525.stgit@notabene.brown>
References: <20141107234628.4923.60525.stgit@notabene.brown>
Date: Wed, 19 Nov 2014 11:14:24 +0100
Message-ID: <CAPDyKFr=vjh5UOzkrbn7Fpm8j97sqf6xxD7tm+HydOKtyeYKoQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] mmc: omap_hsmmc: make more use of mmc library functionality
From: Ulf Hansson <ulf.hansson@linaro.org>
To: NeilBrown <neilb@suse.de>
Cc: Chris Ball <chris@printf.net>, Balaji T K <balajitk@ti.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        GTA04 owners <gta04-owner@goldelico.com>,
        Venkatraman S <svenkatr@ti.com>, Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 November 2014 00:52, NeilBrown <neilb@suse.de> wrote:
> omap_hsmmc currently duplicates some work that can be done for
> it by common code, and consequently does not benefit from extra
> functionality in that common code.
>
> In particular, mmc_of_parse and the slot-gpio library are not used.
>
> This set of patches allows omap_hsmmc to use that common
> functionality, and benefit from any extra devicetree parsing
> that it performs.
>
> The one awkward part of this change is that omap_hsmmc has an
> interrupt handler for 'card detect' which does more than the
> common code.
> I see three options:
>  1 - move that functionality into common code
>  2 - discard that functionality
>  3 - allow the common code to be configured to use a device-specific
>      card detect interrupt.
>
> This series implements '3'.  I suspect a mix of '1' and '2' would
> be a better choice but I know no of the history or justification
> for those differences.
>
> My preference would be for this series to be applied (if there are
> no other issues) and if there are opinions about effecting '1' or '2',
> they can be done with subsequent patches.
>
> Thanks,
> NeilBrown
>

I like the looks of this patchset, but it needs a rebase.

Kind regards
Uffe

>
> ---
>
> NeilBrown (3):
>       mmc: omap_hsmmc: remove prepare/complete system suspend support.
>       mmc: omap_hsmmc: use slot-gpio library for gpio support.
>       mmc: omap_hsmmc: use mmc_of_parse to parse common mmc configuration.
>
>
>  drivers/mmc/core/slot-gpio.c           |   21 ++++
>  drivers/mmc/host/omap_hsmmc.c          |  158 +++++---------------------------
>  include/linux/mmc/slot-gpio.h          |    2
>  include/linux/platform_data/mmc-omap.h |    4 -
>  4 files changed, 47 insertions(+), 138 deletions(-)
>
> --
> Signature
>
