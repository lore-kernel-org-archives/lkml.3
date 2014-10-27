Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaJ0PaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:30:23 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42966 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaJ0PaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:30:20 -0400
Date: Mon, 27 Oct 2014 11:21:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alexandre Courbot <gnurou@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: rfkill: gpio: Add default GPIO driver mappings for
 ACPI
Message-ID: <20141027152158.GC19976@tuxdriver.com>
References: <1414404914-163837-1-git-send-email-mika.westerberg@linux.intel.com>
 <1414409035.3836.4.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414409035.3836.4.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 12:23:55PM +0100, Johannes Berg wrote:
> On Mon, 2014-10-27 at 12:15 +0200, Mika Westerberg wrote:
> > The driver uses devm_gpiod_get_index(..., index) so that the index refers
> > directly to the GpioIo resource under the ACPI device. The problem with
> > this is that if the ordering changes we get wrong GPIOs.
> > 
> > With ACPI 5.1 _DSD we can now use names instead to reference GPIOs
> > analogous to Device Tree. However, we still have systems out there that do
> > not provide _DSD at all. These systems must be supported as well.
> > 
> > Luckily we now have acpi_dev_add_driver_gpios() that can be used to provide
> > mappings for systems where _DSD is not provided and still take advantage of
> > _DSD if it exists.
> > 
> > This patch changes the driver to create default GPIO mappings if we are
> > running on ACPI system.
> > 
> > While there we can drop the indices completely and use devm_gpiod_get()
> > with name instead.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> > Hi,
> > 
> > This patch is based on top of linux-pm/device-properties [1] and following
> > patch from Rafael [2].
> > 
> > Johannes, John,
> > 
> > If you are happy with the patch, can you ACK it so that we can merge it
> > with the rest of the device-properties patches. Thanks.
> 
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
