Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab3CPO5M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 10:57:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61216 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab3CPO5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 10:57:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] clk: add DT test clock consumer driver
Date: Sat, 16 Mar 2013 14:56:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1363439376-21294-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1363439376-21294-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303161456.54246.arnd@arndb.de>
X-Provags-ID: V02:K0:ONoZWeMQbtiaB55ujuchC/OTWCn0k0SpiqyKmGNJ0Wo
 WVjq3kgMbnoi7zk5MZUQRzAwjbC5OwQiLJuwppAVJDFZLaMenY
 FKM+ydGaiqyx+mVcZrqd7V7D3pqiXFW6P1LfaJorDK0HywPTWG
 FN/6YMv8q2XRSwSwY0+R8HwD2wXgWfVbncQWr+kegdj18GtXMH
 ouhaxw5iuIH/UuBxPEL7OwrY1H2OfDBeKqHwF59vb/w5gJFyfk
 lIbJErojDQqdQswXYNM+xnYXBSNRbXlz0VUPXP/XgfE1JbKpex
 9N4K0oBh+otAjpReKKcWUqnOhttakp7hInN2g9VNRpTzF4Yi4R
 ze029IlHTuLuJEsUVO/Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 March 2013, Sebastian Hesselbarth wrote:
> This driver adds a DT test clock consumer that exposes debugfs files to
> enable/disable and set/get rate of the attached programmable clock.
> During development of a i2c-attached clock generator I found it useful
> to debug the clock generator's internal pll settings by enforcing clock
> rates through debugfs.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

It sounds a little clumsy to have a device driver to match a device that
you create just for matching the driver.

Would it be possible to separate the debugging logic from the platform
device logic? I think it may be useful to have a debugfs or sysfs
inteface for all clocks in the system, even if that is disabled by
default or only available after manually loading a module implementing
that functionality.

	Arnd
