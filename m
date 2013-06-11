Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab3FKQdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:33:17 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46571 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3FKQdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:33:15 -0400
Message-ID: <51B75148.5080701@wwwdotorg.org>
Date: Tue, 11 Jun 2013 10:33:12 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        Tony Lindgren <tony@atomide.com>, Wolfram Sang <wsa@the-dreams.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] drivers: pinctrl: add active state to core
References: <1370938616-5952-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1370938616-5952-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 02:16 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> In addition to the recently introduced pinctrl core
> control, the PM runtime pin control for the OMAP platforms
> require a fourth state in addtition to the default, idle and
> sleep states already handled by the core: an explicit "active"
> state. Let's introduce this to the core in addition to the
> other states already defined.

Surely "default" /is/ "active"? That's what it's meant so far.

Since the pinctrl states are represented in DT, the DT bindings of all
devices potentially get affected by changes like this. They'd need to be
documented in a DT binding document, and the exact semantics of the
different states clearly explained.

It may be better for struct device, struct platform_driver, or similar,
to contain a list of the states that are required by the driver or its
binding. That way, the list of states (or states beyond the basic
default) is driver-/DT-binding- specific, and custom stuff like this for
OMAP wouldn't require explicit code in drivers/base/pinctrl.c, but
rather simply iterating over a custom list.

Related to that, I'm not sure we should be deriving what we put into DT
based on the runtime PM requirements of drivers; DT is supposed to be
driven by HW definitions, although I suppose you could argue that the
drivers implement what they do because they're implementing the HW
requirements.
