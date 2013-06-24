Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3FXMHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:07:41 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:64887 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab3FXMGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:06:52 -0400
MIME-Version: 1.0
In-Reply-To: <1371826990-25820-1-git-send-email-grygorii.strashko@ti.com>
References: <1371826990-25820-1-git-send-email-grygorii.strashko@ti.com>
Date: Mon, 24 Jun 2013 14:06:52 +0200
Message-ID: <CACRpkdY=m1b9Lh27+wHP8FQ4SbVZKmAOCGhxe59aP+TcuR9QaA@mail.gmail.com>
Subject: Re: [RFC] ARM: OMAP2+: omap_device: add pinctrl handling
From: Linus Walleij <linus.walleij@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Kevin Hilman <khilman@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 5:03 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:

> Hence, add pinctrl handling in omap_device core:
> 1) on PM runtime resume
> - switch pinctrl state to "default" (todo: "active")
> 2) on PM runtime suspend
> - switch pinctrl state to "idle"
> 3) during system wide suspend
> - switch pinctrl state to "sleep" or "idle" if omap_device core disables device
> - switch pinctrl state to "sleep" if device is disabled already
> 4) during system wide resume
> - switch pinctrl state to "default" (todo: "active") if omap_device core has
>   disabled  device during suspend
> - switch pinctrl state to "idle" if device was already disabled before suspend

I don't understand step 4.

I get the creeps about whether the system is runtime suspended
or runtime resumed when we come to resume proper, so I need
Kevin to have a look at this.

Apart from that it looks good.

Stephen and Tony are trying to figure out the details of whether "active"
is necessary or not in a related thread I think.

Yours,
Linus Walleij
