Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbaJRDwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 23:52:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44368 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaJRDwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 23:52:36 -0400
Date: Fri, 17 Oct 2014 23:52:34 -0400 (EDT)
Message-Id: <20141017.235234.1984288210914297505.davem@davemloft.net>
To: linux@roeck-us.net
Cc: f.fainelli@gmail.com, alexander.h.duyck@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dsa: Fix conversion from host device to mii bus
From: David Miller <davem@davemloft.net>
In-Reply-To: <1413574258-21766-1-git-send-email-linux@roeck-us.net>
References: <1413574258-21766-1-git-send-email-linux@roeck-us.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Oct 2014 20:52:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>
Date: Fri, 17 Oct 2014 12:30:58 -0700

> Commit b4d2394d01bc ("dsa: Replace mii_bus with a generic host device")
> replaces mii_bus with a generic host_dev, and introduces
> dsa_host_dev_to_mii_bus() to support conversion from host_dev to mii_bus.
> However, in some cases it uses to_mii_bus to perform that conversion.
> Since host_dev is not the phy bus device but typically a platform device,
> this fails and results in a crash with the affected drivers.
> 
> BUG: unable to handle kernel NULL pointer dereference at           (null)
> IP: [<ffffffff81781d35>] __mutex_lock_slowpath+0x75/0x100
> PGD 406783067 PUD 406784067 PMD 0
> Oops: 0002 [#1] SMP
> ...
> Call Trace:
> [<ffffffff810a538b>] ? pick_next_task_fair+0x61b/0x880
> [<ffffffff81781de3>] mutex_lock+0x23/0x37
> [<ffffffff81533244>] mdiobus_read+0x34/0x60
> [<ffffffff8153b95a>] __mv88e6xxx_reg_read+0x8a/0xa0
> [<ffffffff8153b9bc>] mv88e6xxx_reg_read+0x4c/0xa0
> 
> Fixes: b4d2394d01bc ("dsa: Replace mii_bus with a generic host device")
> Cc: Alexander Duyck <alexander.h.duyck@intel.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Applied, thanks.
