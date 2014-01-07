Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaAGRuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:50:05 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:52301 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbaAGRuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:50:00 -0500
MIME-Version: 1.0
In-Reply-To: <1385460350-17543-5-git-send-email-mika.westerberg@linux.intel.com>
References: <1385460350-17543-1-git-send-email-mika.westerberg@linux.intel.com>
	<1385460350-17543-5-git-send-email-mika.westerberg@linux.intel.com>
Date: Tue, 7 Jan 2014 18:50:00 +0100
Message-ID: <CACRpkdZhw5At_X-mNkb3TmQ2n1hXc0FGWYAbkAVgxvzCw=xgtw@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] gpio / ACPI: register to ACPI events automatically
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 11:05 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> Instead of asking each driver to register to ACPI events we can just call
> acpi_gpiochip_register_interrupts() for each chip that has an ACPI handle.
> The function checks chip->to_irq and if it is set to NULL (a GPIO driver
> that doesn't do interrupts) the function does nothing.
>
> We also add the a new header drivers/gpio/gpiolib.h that is used for
> functions internal to gpiolib and add ACPI GPIO chip registering functions
> to that header.
>
> Once that is done we can remove call to acpi_gpiochip_register_interrupts()
> from its only user, pinctrl-baytrail.c
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Two questions:

- Can you please rebase patches 3-6 on my GPIO tree "devel" branch?

- Can this patch be placed first? It does not seem to depend on the
  others, to to push dependent patches to the end of the series.

Yours,
Linus Walleij
