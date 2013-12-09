Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555Ab3LINHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:07:35 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62678 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548Ab3LINHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:07:32 -0500
MIME-Version: 1.0
In-Reply-To: <1386040811-27946-1-git-send-email-acourbot@nvidia.com>
References: <CAAVeFu+LLR-EwiRskE_VBQwPrnXAdt-ahfcH08mOXsFuStFMJg@mail.gmail.com>
	<1386040811-27946-1-git-send-email-acourbot@nvidia.com>
Date: Mon, 9 Dec 2013 14:07:29 +0100
Message-ID: <CACRpkdYvN6ONNWWvxtHJC0WiuoZ8VzitsQR4bJrCoajnT0aX=A@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: better lookup method for platform GPIOs
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Rhyland Klein <rklein@nvidia.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 4:20 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

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
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> Changes since v2:
> - Removed size member of the gpiod_lookup_table struct (thanks Heikki!)
> - Added Andy's reviewed-by

Merged in v3.13-rc3 into my devel branch and applied this on top
today.

Thanks!
Linus Walleij
