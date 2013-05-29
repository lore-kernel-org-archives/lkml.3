Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965524Ab3E2SXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 14:23:21 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:62015 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965160Ab3E2SXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 14:23:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130528211230.GE5065@oc6784271780.ibm.com>
References: <20130528211230.GE5065@oc6784271780.ibm.com>
Date: Wed, 29 May 2013 21:23:13 +0300
Message-ID: <CAHp75VeBhm9640BgK5OF4gxYzPaYA3Y-wAU6wTEjL8OCZn9D-A@mail.gmail.com>
Subject: Re: [PATCH 5/8] rsxx: Adding in sync_start module paramenter.
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
Cc: axboe@kernel.dk,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 12:12 AM, Philip J. Kelleher
<pjk1939@linux.vnet.ibm.com> wrote:
> From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
>
> Adding a module parameter called 'sync_start' to wait for
> the card to fully up and running before driver load is
> complete.


> +++ linux-block/drivers/block/rsxx/core.c       2013-05-02 17:32:20.341185588 -0500
> @@ -41,6 +41,8 @@
>  #include "rsxx_cfg.h"
>
>  #define NO_LEGACY 0
> +#define NO_SYNC_START 0
> +#define SYNC_START_TIMEOUT (10 * 60) /* 10 minutes */

10 minutes is indefinite time. May be you have to load timer and
create device only after successfull initialization of the device?

> @@ -874,6 +882,33 @@ static int rsxx_pci_probe(struct pci_dev
>                 if (st)
>                         dev_crit(CARD_TO_DEV(card),
>                                 "Failed issuing card startup\n");
> +               if (sync_start) {
> +                       sync_timeout = SYNC_START_TIMEOUT;
> +
> +                       dev_info(CARD_TO_DEV(card),
> +                                "Waiting for card to startup\n");
> +
> +                       do {
> +                               ssleep(1);

Why not timers?

--
With Best Regards,
Andy Shevchenko
