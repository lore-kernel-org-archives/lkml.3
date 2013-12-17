Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab3LQBLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 20:11:34 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43204 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab3LQBLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 20:11:33 -0500
Date: Mon, 16 Dec 2013 20:11:27 -0500 (EST)
Message-Id: <20131216.201127.533912619440960142.davem@davemloft.net>
To: speiro@ai2.upv.es
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org, jpr@f6fbb.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] hamradio/yam: fix info leak in ioctl
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386920767-27962-1-git-send-email-speiro@ai2.upv.es>
References: <1386920767-27962-1-git-send-email-speiro@ai2.upv.es>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 16 Dec 2013 17:11:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Salva Peiró <speiro@ai2.upv.es>
Date: Fri, 13 Dec 2013 08:46:07 +0100

> The yam_ioctl() code fails to initialise the cmd field
> of the struct yamdrv_ioctl_cfg. Add an explicit memset(0)
> before filling the structure to avoid the 4-byte info leak.
> 
> Signed-off-by: Salva Peiró <speiro@ai2.upv.es>

Put this into the SIOCYAMGCFG case statement, which is where the
problem actually exists.
