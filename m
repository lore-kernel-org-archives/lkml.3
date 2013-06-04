Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827Ab3FDHLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 03:11:03 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:39629 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759255Ab3FDHLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 03:11:00 -0400
MIME-Version: 1.0
In-Reply-To: <1369995191-20855-10-git-send-email-gururaja.hebbar@ti.com>
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
	<1369995191-20855-10-git-send-email-gururaja.hebbar@ti.com>
Date: Tue, 4 Jun 2013 09:11:00 +0200
Message-ID: <CACRpkdbiYX5q8rvtV3Xcv7VdiJo2-6rGHNtvB1V=8C_qCpc=JA@mail.gmail.com>
Subject: Re: [PATCH 09/11] mmc: omap_hsmmc: enhance pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Hebbar Gururaja <gururaja.hebbar@ti.com>
Cc: Kevin Hilman <khilman@linaro.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vaibhav Bedia <vaibhav.bedia@ti.com>, sudhakar.raj@ti.com,
        Balaji T K <balajitk@ti.com>, Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 12:13 PM, Hebbar Gururaja
<gururaja.hebbar@ti.com> wrote:

> Amend the hsmmc controller to optionally take a pin control handle and
> set the state of the pins to:
>
> - "default" on boot, resume and before performing a mmc transfer
> - "idle" after initial default, after resume default, and after each
> mmc/sd card access
> - "sleep" on suspend()
>
> By optionally putting the pins into sleep state in the suspend callback
> we can accomplish two things.
> - One is to minimize current leakage from pins and thus save power,
> - second, we can prevent the IP from driving pins output in an
> uncontrolled manner, which may happen if the power domain drops the
> domain regulator.
>
> If any of the above pin states are missing in dt, a warning message
> about the missing state is displayed.
> If certain pin-states are not available, to remove this warning message
> pass respective state name with null phandler.
>
> Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
> Cc: Balaji T K <balajitk@ti.com>
> Cc: Chris Ball <cjb@laptop.org>
> Cc: linux-mmc@vger.kernel.org
> Cc: linux-omap@vger.kernel.org

This is perfectly correct.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

As the PM code seems to be similar across platforms I have had
loose plans to move this to the device core as well, but right now
I'm too busy with other things, and it can surely be refactored later.

Yours,
Linus Walleij
