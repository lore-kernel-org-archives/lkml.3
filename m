Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab3JDWa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 18:30:28 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54183 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab3JDWaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 18:30:25 -0400
Date: Fri, 4 Oct 2013 15:30:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Wim Van Sebroeck <wim@iguana.be>,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Guenter Roeck <groeck7@gmail.com>, Yang Wenyou <wenyou.yang@atmel.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v5 1/4] watchdog: at91sam9_wdt: better watchdog support
Message-ID: <20131004223018.GA3685@roeck-us.net>
References: <1380871455-7324-1-git-send-email-b.brezillon@overkiz.com>
 <1380871455-7324-2-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380871455-7324-2-git-send-email-b.brezillon@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 09:24:12AM +0200, Boris BREZILLON wrote:
> The at91sam9 watchdog timer can only be configured once, and the current
> implementation tries to configure it in a static way:
> - 2 seconds timeout
> - wdt restart every 500ms
> 
> If the timer has already been configured with different values, it returns an
> error and do not create any watchdog device.
> 
> This is not critical if the watchdog is disabled, but if it has been enabled with
> different timeout values it will lead to a SoC reset.
> 
> This patch series tries to address this issue by adapting the heartbeat value
> according the WDT timer config:
> - it first tries to configure the timer as requested.
> - if it fails it fallbacks to the current config, adapting its heartbeat timer
> to the needs
> 
> This patch series also move to a dynamically allocated at91wdt device instead
> of the static instance.
> 
> It adds a new at91 wdt type: software. This new type make use of the at91 wdt
> interrupt to trigger a software reboot.
> 
> Finally it adds several properties to the device tree bindings.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
