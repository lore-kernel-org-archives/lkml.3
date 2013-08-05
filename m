Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab3HEBvt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 21:51:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37695 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab3HEBvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 21:51:48 -0400
Date: Sun, 04 Aug 2013 18:51:46 -0700 (PDT)
Message-Id: <20130804.185146.1621476659301936865.davem@davemloft.net>
To: hpa@zytor.com
Cc: dh.herrmann@gmail.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, santiago@crfreenet.org
Subject: Re: [PATCH] fbdev: suppress warning when assigning
 vga-save/restore base
From: David Miller <davem@davemloft.net>
In-Reply-To: <51FE907A.2090201@zytor.com>
References: <1375637141-2878-1-git-send-email-dh.herrmann@gmail.com>
	<51FE907A.2090201@zytor.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sun, 04 Aug 2013 18:51:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 04 Aug 2013 10:33:46 -0700

> Anyone who can dig backwards and summarize?  In other words:
> 
> Where in the current code do we stuff a physical address in a pointer,
> or a virtual address into a non-pointer?

The VGA register accessors try to accomodate iomem and ioport
accesses.

If they are given a non-NULL iomem pointer 'regbase' they use
iomem accesses, otherwise they do direct ISA port poking.

And yes the drivers in question are making some brash assumptions.
I suspect they should be using ioremap() or similar.
