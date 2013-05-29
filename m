Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965539Ab3E2S0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 14:26:39 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:53813 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965160Ab3E2S0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 14:26:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130528211420.GG5065@oc6784271780.ibm.com>
References: <20130528211420.GG5065@oc6784271780.ibm.com>
Date: Wed, 29 May 2013 21:26:30 +0300
Message-ID: <CAHp75Ve73bLosxtKNA71WDo10_pxXYj_rhFOd+A-VwO7bxduaA@mail.gmail.com>
Subject: Re: [PATCH 7/8] rsxx: Adding EEH check inside cregs timeout.
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 12:14 AM, Philip J. Kelleher
<pjk1939@linux.vnet.ibm.com> wrote:
> From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
>
> Unfortunaly, our CPU register path does not do any kind of
> EEH error checking. So to fix this issue, an ioread32 was
> added to the CPU register timeout code. This way, the
> driver can check to see if the timeout was caused by an EEH
> error or not.


> +++ linux-block/drivers/block/rsxx/cregs.c      2013-05-01 18:59:57.596197150 -0500
> @@ -431,6 +431,15 @@ static int __issue_creg_rw(struct rsxx_c
>         *hw_stat = completion.creg_status;
>
>         if (completion.st) {
> +               /*
> +                * This read is needed to verify that there has not been any
> +                * extreme errors that might have occurred, i.e. EEH. The
> +                * function iowrite32 will not detect EEH errors, so it is
> +                * necessary that we recover if such an error is the reason
> +                * for the timeout.
> +                */
> +               ioread32(card->regmap + SCRATCH);

This is just a dummy read, right? Perhaps you may add this word to the
explanation.

--
With Best Regards,
Andy Shevchenko
