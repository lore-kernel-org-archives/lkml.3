Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaJ0LY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:24:29 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:51176 "EHLO sipsolutions.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752347AbaJ0LY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:24:27 -0400
Message-ID: <1414409035.3836.4.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] net: rfkill: gpio: Add default GPIO driver mappings for
 ACPI
From: Johannes Berg <johannes@sipsolutions.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alexandre Courbot <gnurou@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 27 Oct 2014 12:23:55 +0100
In-Reply-To: <1414404914-163837-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1414404914-163837-1-git-send-email-mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 12:15 +0200, Mika Westerberg wrote:
> The driver uses devm_gpiod_get_index(..., index) so that the index refers
> directly to the GpioIo resource under the ACPI device. The problem with
> this is that if the ordering changes we get wrong GPIOs.
> 
> With ACPI 5.1 _DSD we can now use names instead to reference GPIOs
> analogous to Device Tree. However, we still have systems out there that do
> not provide _DSD at all. These systems must be supported as well.
> 
> Luckily we now have acpi_dev_add_driver_gpios() that can be used to provide
> mappings for systems where _DSD is not provided and still take advantage of
> _DSD if it exists.
> 
> This patch changes the driver to create default GPIO mappings if we are
> running on ACPI system.
> 
> While there we can drop the indices completely and use devm_gpiod_get()
> with name instead.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
> Hi,
> 
> This patch is based on top of linux-pm/device-properties [1] and following
> patch from Rafael [2].
> 
> Johannes, John,
> 
> If you are happy with the patch, can you ACK it so that we can merge it
> with the rest of the device-properties patches. Thanks.

Acked-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

