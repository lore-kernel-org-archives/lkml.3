Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaEPC5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 22:57:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38815 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaEPC5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 22:57:21 -0400
Date: Thu, 15 May 2014 22:57:15 -0400 (EDT)
Message-Id: <20140515.225715.1311338998569156758.davem@davemloft.net>
To: linux@roeck-us.net
Cc: f.fainelli@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: Don't call phy_resume if phy_init_hw failed
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400098369-13985-1-git-send-email-linux@roeck-us.net>
References: <1400098369-13985-1-git-send-email-linux@roeck-us.net>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 May 2014 19:57:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>
Date: Wed, 14 May 2014 13:12:49 -0700

> After the call to phy_init_hw failed in phy_attach_direct, phy_detach is called
> to detach the phy device from its network device. If the attached driver is a
> generic phy driver, this also detaches the driver. Subsequently phy_resume
> is called, which assumes without checking that a driver is attached to the
> device. This will result in a crash such as
> 
> Unable to handle kernel paging request for data at address 0xffffffffffffff90
> Faulting instruction address: 0xc0000000003a0e18
> Oops: Kernel access of bad area, sig: 11 [#1]
> ...
> NIP [c0000000003a0e18] .phy_attach_direct+0x68/0x17c
> LR [c0000000003a0e6c] .phy_attach_direct+0xbc/0x17c
> Call Trace:
> [c0000003fc0475d0] [c0000000003a0e6c] .phy_attach_direct+0xbc/0x17c (unreliable)
> [c0000003fc047670] [c0000000003a0ff8] .phy_connect_direct+0x28/0x98
> [c0000003fc047700] [c0000000003f0074] .of_phy_connect+0x4c/0xa4
> 
> Only call phy_resume if phy_init_hw was successful.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Applied and queued up for -stable, thanks.
