Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab3CTKkC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 06:40:02 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:45602 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab3CTKj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 06:39:59 -0400
MIME-Version: 1.0
In-Reply-To: <201303201020.14654.arnd@arndb.de>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
 <201303191759.27762.arnd@arndb.de> <CAHkwnC-3_dDM3JO8y3yeNFz7=fpP=MtZ9D-3cMH8rNF9C1NZBA@mail.gmail.com>
 <201303201020.14654.arnd@arndb.de>
From: Fabio Porcedda <fabio.porcedda@gmail.com>
Date: Wed, 20 Mar 2013 11:39:38 +0100
Message-ID: <CAHkwnC-8FH0nyJ+eT=+7doP+fSdZjNYUW4zzs_r6e9wt3Yt4Fg@mail.gmail.com>
Subject: Re: [PATCH 10/10] drivers: misc: use module_platform_driver_probe()
To: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 11:20 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 20 March 2013, Fabio Porcedda wrote:
>> I think we can check inside the  deferred_probe_work_func()
>> if the dev->probe function pointer is equal to platform_drv_probe_fail().
>
> I think it's too late by then, because that would only warn if we try to probe
> it again, but when platform_driver_probe() does not succeed immediately, it

Maybe you mean "does succeed immediately" ?

> unregisters the driver again, so we never get there.

--
Fabio Porcedda
