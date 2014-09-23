Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbaIWKow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:44:52 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56406 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbaIWKou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:44:50 -0400
Message-ID: <1411469087.32524.6.camel@lp-lvrv.comap.cz>
Subject: Re: [PATCH v2] watchdog: omap_wdt: Add 'early_disable' module
 parameter
From: Rostislav Lisovy <lisovy@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, sojkam1@fel.cvut.cz,
        michal.vokac@comap.cz, Rostislav Lisovy <lisovy@merica.cz>
Date: Tue, 23 Sep 2014 12:44:47 +0200
In-Reply-To: <541BAD2C.8080902@roeck-us.net>
References: <1410877228-20925-1-git-send-email-lisovy@merica.cz>
		 <20140916154921.GA14725@roeck-us.net>
	 <1410967369.5542.2.camel@lp-lvrv.comap.cz> <541BAD2C.8080902@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Čt, 2014-09-18 at 21:12 -0700, Guenter Roeck wrote:
> How about reading the OMAP_WATCHDOG_SPR register ?

Unfortunately this would be not only extremely fragile (someone writes
correct start sequence followed by some garbage -- WD is running and we
are reading garbage) but according to some experiments seems not to work
at all (I am reading "0" even for a running WD probably as a result to
the pm_runtime_get_sync() call).

One of the TI employees on the TI forum confirmed (I know this is not a
rock-solid information) that it is not possible to safely determine if
the WD is running or not.


> Either case, you can not issue a message about the watchdog being
> stopped or started if you don't know if it was actually stopped
> or started. Also, if you don't really know if the watchdog was
> stopped or started, all you can do is to either stop or start it,
> without judgment about its previous condition.

You are right. I was blinded by our use case where the watchdog is
always started by the bootloader.
I will wait to see if the WATCHDOG_KEEP_ON will be integrated and then I
will add the feature for the omap_wdt.

Best regards;
Rostislav


