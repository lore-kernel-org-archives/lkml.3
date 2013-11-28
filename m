Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130Ab3K1Opk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:45:40 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:59932 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758879Ab3K1Opi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:45:38 -0500
MIME-Version: 1.0
In-Reply-To: <1385628388-23827-1-git-send-email-acourbot@nvidia.com>
References: <1385628388-23827-1-git-send-email-acourbot@nvidia.com>
Date: Thu, 28 Nov 2013 15:45:37 +0100
Message-ID: <CACRpkda-TtKQr6hDx4corjxYv7r7f6_9sNp_2ocbvg9MHyOk7Q@mail.gmail.com>
Subject: Re: [PATCH] gpio: better lookup method for platform GPIOs
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Rhyland Klein <rklein@nvidia.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 9:46 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Change the format of the platform GPIO lookup tables to make them less
> confusing and improve lookup efficiency.
>
> The previous format was a single linked-list that required to compare
> the device name and function ID of every single GPIO defined for each
> lookup. Switch that to a list of per-device tables, so that the lookup
> can be done in two steps, omitting the GPIOs that are not relevant for a
> particular device.
>
> The matching rules are now defined as follows:
> - The device name must match *exactly*, and can be NULL for GPIOs not
>   assigned to a particular device,
> - If the function ID in the lookup table is NULL, the con_id argument of
>   gpiod_get() will not be used for lookup. However, if it is defined, it
>   must match exactly.
> - The index must always match.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
> Let's change this bad design before more users start using it. ;)

OK given that Mika has based his patches on this I'll request
that he ACK this and then I'll merge this so that he can put
this patch at the bottom of his patch stack.

Mika: requesting ACK.

Yours,
Linus Walleij
