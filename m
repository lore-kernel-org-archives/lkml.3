Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbaAaA2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 19:28:45 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:32815 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbaAaA2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 19:28:42 -0500
Date: Thu, 30 Jan 2014 16:28:41 -0800 (PST)
Message-Id: <20140130.162841.525938031146003411.davem@davemloft.net>
To: teg@jklm.no
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephen@networkplumber.org, avi.kp.137@gmail.com, mchehab@redhat.com,
        horms@verge.net.au, marcel@holtmann.org, gregkh@linuxfoundation.org,
        kay@vrfy.org
Subject: Re: [PATCH] net: set default DEVTYPE for all ethernet based devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <1391088002-15650-1-git-send-email-teg@jklm.no>
References: <1391088002-15650-1-git-send-email-teg@jklm.no>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Gundersen <teg@jklm.no>
Date: Thu, 30 Jan 2014 14:20:02 +0100

> In systemd's networkd and udevd, we would like to give the administrator a
> simple way to filter net devices by their DEVTYPE [0][1]. Other software
> such as ConnMan and NetworkManager uses a similar filtering already.
> 
> Currently, plain ethernet devices have DEVTYPE=(null). This patch sets the
> devtype to "ethernet" instead. This avoids the need for special-casing the
> DEVTYPE=(null) case in userspace, and also avoids false positives, as there
> are several other types of netdevs that also have DEVTYPE=(null).
> 
> Notice that this is done, as suggested by Marcel, in alloc_etherdev_mqs(),
> and as best I can tell it will not give any false positives. I considered
> doing it in ether_setup() instead as that seemed more intuitive, but that
> would give a lot of false positives indeed.
> 
> [0]: <http://www.freedesktop.org/software/systemd/man/systemd-networkd.service.html#Type>
> [1]: <http://www.freedesktop.org/software/systemd/man/udev.html#Type>
> 
> Signed-off-by: Tom Gundersen <teg@jklm.no>

Assuming that all users of alloc_etherdev*() are ethernet devices is
really not going to work.
