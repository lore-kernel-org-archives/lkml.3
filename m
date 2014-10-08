Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbaJHTpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:45:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57063 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745AbaJHTpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:45:16 -0400
Date: Wed, 08 Oct 2014 15:45:13 -0400 (EDT)
Message-Id: <20141008.154513.1944594723904521723.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: use mutex for hw settings
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-58-Taiwan-albertk@realtek.com>
References: <1394712342-15778-58-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Oct 2014 12:45:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Tue, 7 Oct 2014 13:36:30 +0800

> Use mutex to avoid that the serial hw settings would be interrupted
> by other settings. Although there is no problem now, it makes the
> driver more safe.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

I think a much simpler fix is to take rtnl_lock() in the workqueue
function and suspend/resume ops.

Every other place you are adding the mutex already holds the RTNL
mutex.
