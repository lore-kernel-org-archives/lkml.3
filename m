Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab3FLShV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 14:37:21 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:45401 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998Ab3FLShT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 14:37:19 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/H41/UN0gYw9FE6Cie4Odn
Date: Wed, 12 Jun 2013 11:37:16 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] pinctrl: document the pinctrl PM states
Message-ID: <20130612183716.GW8164@atomide.com>
References: <1370980749-15383-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370980749-15383-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@stericsson.com> [130611 13:05]:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This document snippet tries to be helpful and define the pin
> PM states and helpers, and how they should be used to create
> some kind of common ontology around this.
> 
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  Documentation/pinctrl.txt | 118 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 118 insertions(+)
> 
> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> index f6e664b..a34ea92 100644
> --- a/Documentation/pinctrl.txt
> +++ b/Documentation/pinctrl.txt
> @@ -1196,6 +1196,124 @@ registered. Thus make sure that the error path in your driver gracefully
>  cleans up and is ready to retry the probing later in the startup process.
>  
>  
> +Default and power management related states
> +===========================================
> +
> +As mentioned earlier the device core will automatically try to obtain a
> +pinctrl handle and activate the "default" state on all drivers.
> +
> +However, for power management and power saving, it is sometimes necessary
> +to switch pin states at runtime. Electrically speaking this involves
> +for example reconfigure some pins to be grounded or pulled-down when the
> +system as a whole goes to sleep, or a pull-up could be turned off when pins
> +are idle, reducing leak current.
> +
> +To help out with this, if CONFIG_PM is selected in the Kconfig, three
> +additional states will also be obtained by the driver core and cached
> +there:
> +
> +"active"   this is indended as an explicit active state, if the "default"
> +           state is not synonymous with the active one.
> +
> +"idle"     this is a state that is relaxing the pins when the system as a
> +           whole is up and running, but these particular pins are unused.
> +
> +"sleep"    this is a state that is used when the whole system goes to
> +           suspend, becomes uninteractive, unresponsive to anything but
> +           specific wake-up events.

In the cases I've seen "idle" and "sleep" are the same. But it sounds like
other people's hardware have different needs and it's optional so:

Acked-by: Tony Lindgren <tony@atomide.com>
