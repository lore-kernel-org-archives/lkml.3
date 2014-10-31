Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760978AbaJaHD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 03:03:59 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:65449 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758785AbaJaHD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 03:03:57 -0400
MIME-Version: 1.0
In-Reply-To: <1414434602-14263-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1414434602-14263-1-git-send-email-soren.brinkmann@xilinx.com>
Date: Fri, 31 Oct 2014 08:03:56 +0100
Message-ID: <CACRpkdaduj3MaEN=hmL54ANJiP0B5MdH9qSqWRukX4H7pFt_Hw@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: lib-sysfs: Add 'wakeup' attribute
From: Linus Walleij <linus.walleij@linaro.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>, linux-api@vger.kernel.org
Cc: Alexandre Courbot <gnurou@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 7:30 PM, Soren Brinkmann
<soren.brinkmann@xilinx.com> wrote:

> Add an attribute 'wakeup' to the GPIO sysfs interface which allows
> marking/unmarking a GPIO as wake IRQ.
> The file 'wakeup' is created in each exported GPIOs directory, if an IRQ
> is associated with that GPIO and the irqchip implements set_wake().
> Writing 'enabled' to that file will enable wake for that GPIO, while
> writing 'disabled' will disable wake.
> Reading that file will return either 'disabled' or 'enabled' depening on
> the currently set flag for the GPIO's IRQ.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
> v3:
>  - add documentation
> v2:
>  - fix error path to unlock mutex before return
(...)

Looking better!

> +       "wakeup" ... reads as either "enabled" or "disabled". Write these
> +               strings to set/clear the 'wakeup' flag of the IRQ associated
> +               with this GPIO. If the IRQ has the 'wakeup' flag set, it can
> +               wake the system from sleep states.
> +
> +               This file exists only if the pin can generate interrupts and
> +               the driver implements the required infrastructure.

Should this not be 0/1 rather than the string "enabled"/"disabled"?

I think that is the common pattern in sysfs?

Not sure, but want an indication from the ABI people.

Yours,
Linus Walleij
