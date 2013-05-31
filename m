Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab3EaSIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 14:08:13 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:64691 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab3EaSIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 14:08:09 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hebbar Gururaja <gururaja.hebbar@ti.com>, grant.likely@linaro.org,
        linus.walleij@linaro.org, rob.herring@calxeda.com,
        davinci-linux-open-source@linux.davincidsp.com,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, vaibhav.bedia@ti.com,
        sudhakar.raj@ti.com, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 00/11] drivers: Add Pinctrl PM support
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
	<20130531170437.GA17591@core.coreip.homeip.net>
Date: Fri, 31 May 2013 11:08:06 -0700
In-Reply-To: <20130531170437.GA17591@core.coreip.homeip.net> (Dmitry
	Torokhov's message of "Fri, 31 May 2013 10:04:37 -0700")
Message-ID: <8761xz10qh.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Linus W. (pinctrl maintainer)

Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:

> Hi Hebbar,
>
> On Fri, May 31, 2013 at 03:43:00PM +0530, Hebbar Gururaja wrote:
>> By optionally putting the pins into sleep state in the suspend [or in
>> runtime_suspend] callback we can accomplish two things.
>> - One is to minimize current leakage from pins and thus save power,
>> - second, we can prevent the IP from driving pins output in an
>> uncontrolled manner, which may happen if the power domain drops the
>> domain regulator.
>> 
>> These states can be specified in the DT blob and corresponding driver
>> can pick these states during probe & set the related values during
>> idle/suspend.
>> 
>> Not all drivers support/has idle state. Drivers like i2c, spi, mmc has
>> idle states and hence these drivers are updated to support all the
>> three states
>> - default  : during regular operation
>> - idle : when the module is in idle state
>> - sleep : when the module is in suspend state
>> 
>> For those drivers which doesn't support/have idle state (at least at
>> the moment), only default & sleep state is added.
>
> As with the original introduction of pinctrl states my question is: "Can
> all of this be handled in the driver/bus core instead of adding a lot
> of boilerplate code to the individual drivers".

Yes, I had the same thought.

What's being handled here are either events related to runtime PM
(runtime suspend, runtime resume) or system PM (suspend/resume) so seems
appropriat to handle them in the PM core.

Kevin
