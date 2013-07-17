Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab3GQL6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:58:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43252 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251Ab3GQL6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:58:22 -0400
Message-ID: <51E686C1.8020801@ti.com>
Date: Wed, 17 Jul 2013 14:57:53 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 0/3] ARM: OMAP2+: omap_device: add dynamic pinctrl handling
References: <1374061312-25469-1-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1374061312-25469-1-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grygorii,

On 07/17/2013 02:41 PM, Grygorii Strashko wrote:
> Hi Tony, Kevin
> 
> This patch series introduces dynamic pinctrl handling in OMAP device framework
> in the same way as it was before switching to DT. 
> This allow OMAP devices driver's developers to simply add dynamic pinctrl
> handling for "default", "active", "idle", "sleep" PIN states in their drivers
> by modifying DT definitions only - no modifications in drivers code are not needed.
> 

Overall I like the idea but can we make a provision for device drivers to override
this default pin state handling?

The OMAP EHCI driver is one such special case where the wakeup mechanism is tied to pinctrl states
as it uses IO daisy chaining to implement wakeup.
So depending on whether wakeup needs to be enabled or not I must be able to chose whether
I put the pin in just "sleep" state or "sleep with wakeup" state.

cheers,
-roger
