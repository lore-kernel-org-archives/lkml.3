Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaJRDq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 23:46:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44337 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbaJRDqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 23:46:55 -0400
Date: Fri, 17 Oct 2014 23:46:53 -0400 (EDT)
Message-Id: <20141017.234653.505926640053533707.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net] r8152: return -EBUSY for runtime suspend
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-65-Taiwan-albertk@realtek.com>
References: <87zjcvgn1x.fsf@nemi.mork.no>
	<1394712342-15778-65-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Oct 2014 20:46:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Fri, 17 Oct 2014 16:55:08 +0800

> Remove calling cancel_delayed_work_sync() for runtime suspend,
> because it would cause dead lock. Instead, return -EBUSY to
> avoid the device enters suspending if the net is running and
> the delayed work is pending or running. The delayed work would
> try to wake up the device later, so the suspending is not
> necessary.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied.
