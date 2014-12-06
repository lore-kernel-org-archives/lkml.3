Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaLFF35 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 00:29:57 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60284 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaLFF3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 00:29:54 -0500
Date: Fri, 05 Dec 2014 21:34:24 -0800 (PST)
Message-Id: <20141205.213424.884566076200225454.davem@davemloft.net>
To: LinoSanfilippo@gmx.de
Cc: stephen@networkplumber.org, mlindner@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sky2: avoid pci write posting after disabling irqs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1417348611-1752-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1417348611-1752-1-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Dec 2014 21:29:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Date: Sun, 30 Nov 2014 12:56:51 +0100

> In sky2_change_mtu setting B0_IMSK to 0 may be delayed due to PCI write posting
> which could result in irqs being still active when synchronize_irq is called.
> Since we are not prepared to handle any further irqs after synchronize_irq
> (our resources are freed after that) force the write by a consecutive read from
> the same register.
> Similar situation in sky2_all_down: Here we disabled irqs by a write to B0_IMSK
> but did not ensure that this write took place before synchronize_irq. Fix that
> too.
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>

Applied.
