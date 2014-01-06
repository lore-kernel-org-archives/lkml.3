Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaAFBkD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 20:40:03 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53582 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaAFBkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 20:40:01 -0500
Date: Sun, 05 Jan 2014 20:39:59 -0500 (EST)
Message-Id: <20140105.203959.962622308205839285.davem@davemloft.net>
To: linux@roeck-us.net
Cc: isdn@linux-pingi.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] isdn: Mark build for telespci and hfc_pci as broken
 for big endian ARM
From: David Miller <davem@davemloft.net>
In-Reply-To: <1388951367-7411-1-git-send-email-linux@roeck-us.net>
References: <1388951367-7411-1-git-send-email-linux@roeck-us.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sun, 05 Jan 2014 17:40:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>
Date: Sun,  5 Jan 2014 11:49:27 -0800

> With arm:allmodconfig, building the Teles PCI driver fails with
> 
> telespci.c:294:2: error: #error "not running on big endian machines now"
> 
> Similar, building the driver for HFC PCI-Bus cards fails with
> 
> hfc_pci.c:1647:2: error: #error "not running on big endian machines now"
> 
> Mark build as broken for big endian ARM machines.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Let's not start getting into the habit of doing this, please.

The reason this isn't easy to do generically from Kconfig is
probably because it almost never makes any sense to do so.

In fact, if you look at telespci.c there are no DMA descriptors,
everything is read using MMIO acccesses via the chips FIFO.  There
really can't be any endianness problems that I see.

Please just remove the CPP checks, that's the best fix.

Thanks.
