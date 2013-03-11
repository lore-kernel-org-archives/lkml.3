Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab3CKNjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:39:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52975 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab3CKNjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:39:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dong Aisheng <b29396@freescale.com>
Subject: Re: [PATCH v6 2/2] mfd: syscon: Add non-DT support
Date: Mon, 11 Mar 2013 13:38:56 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Alexander Shiyan <shc_work@mail.ru>, linux-kernel@vger.kernel.org,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
References: <1362063434-8318-1-git-send-email-shc_work@mail.ru> <1362997004.885485377@f319.mail.ru> <20130311103541.GC6280@b29396-Latitude-E6410>
In-Reply-To: <20130311103541.GC6280@b29396-Latitude-E6410>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303111338.56679.arnd@arndb.de>
X-Provags-ID: V02:K0:KKkUFkqWZlcfaWvAdXXKWpIpQRLWYqAFbAb3sOUtXSt
 XC1th7Kc1FC5AkW/gAst7iNpbCR7UjO9IIuvSAjPrVEakR1cDU
 PFSy0hRd3CiUJUqIIBETXlCXJLOZO/OchNZ+nilESA0173Wznx
 al1Qfegnarjqzd78xBreoyz2FQDyOcZ+8ogrR9KqZ1qHFISKFh
 CoqWoPiA5UAjl5TgsXG/+Wjy9+WoIRQrCjvyBfXnntKXaZZogb
 dXpqj83UaXH3JqVxjOgD1WdwOEmdp7VWNMZkJnDY6MNApsNXvp
 Tz/NgP7fN+FBOCf2AsxuNuiR+SZGwJVYjz31KxlV2JLKkX9K01
 1wDColllPy9H1ZYMmqpM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 March 2013, Dong Aisheng wrote:
> > > > + dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
> > > > +                          syscon_match_pdevname);
> > > > + if (!dev)
> > > > +         return ERR_PTR(-ENODEV);
> > > 
> > > Should it be ERR_PTR(-EPROBE_DEFER)?
> > 
> > I have no idea what better using here. Think that is not so important
> > since we may have only one possible error code here.
> 
> I'm not quite understand your meaning.
> Since the syscon device may be still not registered,
> so it may be better to return a EPROBE_DERFER which is the same
> as dt version.

I'm guessing that Alexander has not encountered deferred probing yet.
Alexander, the point here is that returning -EPROBE_DEFER has the
advantage that a probe() callback calling this function can
simply return that error code to the driver core. If the driver
core sees -EPROBE_DEFER, it will retry the same probe function
later, after all other device probe functions have been called
and at least one of them was successful. This way you can load the
syscon driver after loading a driver depending on it and everything
will still work.

	Arnd
