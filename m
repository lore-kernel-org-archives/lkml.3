Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab3JUTGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 15:06:35 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:59453 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3JUTGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 15:06:34 -0400
Date: Mon, 21 Oct 2013 12:06:25 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-watchdog@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mike Frysinger <vapier.adi@gmail.com>,
        Wan ZongShun <mcuos.com@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        Jim Cromie <jim.cromie@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] watchdog: Get rid of MODULE_ALIAS_MISCDEV statements
Message-ID: <20131021190625.GA19242@roeck-us.net>
References: <20131021173849.2d8be882@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131021173849.2d8be882@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 05:38:49PM +0200, Jean Delvare wrote:
> I just can't find any value in MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR)
> and MODULE_ALIAS_MISCDEV(TEMP_MINOR) statements.
> 
> Either the device is enumerated and the driver already has a module
> alias (e.g. PCI, USB etc.) that will get the right driver loaded
> automatically.
> 
> Or the device is not enumerated and loading its driver will lead to
> more or less intrusive hardware poking. Such hardware poking should be
> limited to a bare minimum, so the user should really decide which
> drivers should be tried and in what order. Trying them all in
> arbitrary order can't do any good.
> 
> On top of that, loading that many drivers at once bloats the kernel
> log. Also many drivers will stay loaded afterward, bloating the output
> of "lsmod" and wasting memory. Some modules (cs5535_mfgpt which gets
> loaded as a dependency) can't even be unloaded!
> 
> If defining char-major-10-130 is needed then it should happen in
> user-space.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Mike Frysinger <vapier.adi@gmail.com>
> Cc: Wan ZongShun <mcuos.com@gmail.com>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Zwane Mwaikambo <zwane@arm.linux.org.uk>
> Cc: Jim Cromie <jim.cromie@gmail.com>
> Cc: Guenter Roeck <linux@roeck-us.net>

Makes sense to me.

Acked-by: Guenter Roeck <linux@roeck-us.net>
