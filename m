Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbaJJFB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 01:01:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45732 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaJJFBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 01:01:23 -0400
Date: Fri, 10 Oct 2014 01:01:21 -0400 (EDT)
Message-Id: <20141010.010121.1739918681035567554.davem@davemloft.net>
To: bobby.prani@gmail.com
Cc: jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
        bruce.w.allan@intel.com, carolyn.wyborny@intel.com,
        donald.c.skidmore@intel.com, gregory.v.rose@intel.com,
        matthew.vick@intel.com, john.ronciak@intel.com,
        mitch.a.williams@intel.com, linux.nics@intel.com,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] networking: fm10k: Fix build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412916929-21592-1-git-send-email-bobby.prani@gmail.com>
References: <1412916929-21592-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Oct 2014 22:01:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>
Date: Fri, 10 Oct 2014 00:55:29 -0400

> The latest linus git tip (3.18-rc1) fails with the following build failure. Fix
> this by making PTP support explicit for fm10k driver.
> 
> rivers/built-in.o: In function `fm10k_ptp_register':
> (.text+0x12e760): undefined reference to `ptp_clock_registER'
> drivers/built-in.o: In function `fm10k_ptp_unregister':
> (.text+0x12e7dc): undefined reference to `ptp_clock_unregister'
> Makefile:930: recipe for target 'vmlinux' failed
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Please follow what other drivers do, which is to use "select" on this
Kconfig symbol.

Thanks.
