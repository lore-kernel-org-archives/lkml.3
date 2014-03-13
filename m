Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbaCMQ5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 12:57:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53529 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbaCMQ5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:57:12 -0400
Date: Thu, 13 Mar 2014 12:57:10 -0400 (EDT)
Message-Id: <20140313.125710.1893798649203550983.davem@davemloft.net>
To: arnd@arndb.de
Cc: nhorman@tuxdriver.com, sbhatewara@vmware.com, pv-drivers@vmware.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] vmxnet3: fix building without CONFIG_PCI_MSI
From: David Miller <davem@davemloft.net>
In-Reply-To: <7825453.7LB7BmvA2b@wuerfel>
References: <7825453.7LB7BmvA2b@wuerfel>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Mar 2014 09:57:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 13 Mar 2014 10:44:34 +0100

> Since commit d25f06ea466e "vmxnet3: fix netpoll race condition",
> the vmxnet3 driver fails to build when CONFIG_PCI_MSI is disabled,
> because it unconditionally references the vmxnet3_msix_rx()
> function.
> 
> To fix this, use the same #ifdef in the caller that exists around
> the function definition.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Shreyas Bhatewara <sbhatewara@vmware.com>
> Cc: "VMware, Inc." <pv-drivers@vmware.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: stable@vger.kernel.org
> ---
> Found this during randconfig testing on ARM. Most of the time when
> I report network driver problems, they get fixed in the netdev tree
> before I even find them, but since this is for a patch marked "stable",
> I made a proper patch anyway.
> 
> Please ignore if this is already a known problem, otherwise make sure
> the original patch doesn't get backported without addressing this
> issue first.

Applied, and queued up for -stable, thanks.
