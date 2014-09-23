Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457AbaIWQOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:14:48 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:64236 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050AbaIWQOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:14:46 -0400
Date: Tue, 23 Sep 2014 09:14:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, sojkam1@fel.cvut.cz,
        michal.vokac@comap.cz, Rostislav Lisovy <lisovy@merica.cz>
Subject: Re: [PATCH v2] watchdog: omap_wdt: Add 'early_disable' module
 parameter
Message-ID: <20140923161440.GC20591@roeck-us.net>
References: <1410877228-20925-1-git-send-email-lisovy@merica.cz>
 <20140916154921.GA14725@roeck-us.net>
 <1410967369.5542.2.camel@lp-lvrv.comap.cz>
 <541BAD2C.8080902@roeck-us.net>
 <1411469087.32524.6.camel@lp-lvrv.comap.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411469087.32524.6.camel@lp-lvrv.comap.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 12:44:47PM +0200, Rostislav Lisovy wrote:
> On Čt, 2014-09-18 at 21:12 -0700, Guenter Roeck wrote:
> > How about reading the OMAP_WATCHDOG_SPR register ?
> 
> Unfortunately this would be not only extremely fragile (someone writes
> correct start sequence followed by some garbage -- WD is running and we
> are reading garbage) but according to some experiments seems not to work
> at all (I am reading "0" even for a running WD probably as a result to
> the pm_runtime_get_sync() call).
> 
> One of the TI employees on the TI forum confirmed (I know this is not a
> rock-solid information) that it is not possible to safely determine if
> the WD is running or not.
> 
Annoying, but I guess we'll have to live with that.

> 
> > Either case, you can not issue a message about the watchdog being
> > stopped or started if you don't know if it was actually stopped
> > or started. Also, if you don't really know if the watchdog was
> > stopped or started, all you can do is to either stop or start it,
> > without judgment about its previous condition.
> 
> You are right. I was blinded by our use case where the watchdog is
> always started by the bootloader.
> I will wait to see if the WATCHDOG_KEEP_ON will be integrated and then I
> will add the feature for the omap_wdt.
> 
I would predict that it will be accepted. For my part I am not happy
with the name, though, and I'll have to find the time to thoroughly review
and, if possible, test it.

Guenter
