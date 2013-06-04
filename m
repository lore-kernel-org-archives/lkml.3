Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068Ab3FDHZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 03:25:06 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:47745 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759966Ab3FDHZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 03:25:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130531170437.GA17591@core.coreip.homeip.net>
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
	<20130531170437.GA17591@core.coreip.homeip.net>
Date: Tue, 4 Jun 2013 09:25:02 +0200
Message-ID: <CACRpkdYnhjpFp1CM=P_hddBe4qVigtE0c+CN9NKvk3nFgJS-ig@mail.gmail.com>
Subject: Re: [PATCH 00/11] drivers: Add Pinctrl PM support
From: Linus Walleij <linus.walleij@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vaibhav Bedia <vaibhav.bedia@ti.com>, sudhakar.raj@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 7:04 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:

> As with the original introduction of pinctrl states my question is: "Can
> all of this be handled in the driver/bus core instead of adding a lot
> of boilerplate code to the individual drivers".

It can. Per the suggestion in 2/11:

- Adding pins_sleep and pins_idle to struct dev_pin_info
  in include/linux/pinctrl/devinfo.h

- Modify drivers/base/pinctrl.c to optionally look up
  sleep and idle states, you can make that code
  #ifdef CONFIG_PM I think.

- Add something like static inline functions to
  include/linux/pinctrl/consumer.h
  with names like pinctrl_select_pm_idle(struct device *)
  pinctrl_select_pm_sleep(struct device *) to switch states
  using the device core containers, and includes
  checking IS_ERR() on the handles etc.

I think this will save a *lot* of identical code in all the
drivers, that will just have to call
pinctrl_select_pm_sleep(), pinctrl_select_pm_default()
pinctrl_select_pm_idle() instead of all the complex code.

This is what I planned to do but never got around to.

Yours,
Linus Walleij
