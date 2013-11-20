Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab3KTFk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 00:40:29 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60504 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3KTFk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 00:40:28 -0500
Date: Wed, 20 Nov 2013 00:40:26 -0500 (EST)
Message-Id: <20131120.004026.2013972041095203460.davem@davemloft.net>
To: freddy@asix.com.tw
Cc: netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, davemloft@davemloft.net,
        louis@asix.com.tw, allan@asix.com.tw, grundler@google.com,
        daniel@asix.com.tw
Subject: Re: [PATCH 1/1] Workaround for Suspend/Resume issue of AX88772B
 under ChromeOS
From: David Miller <davem@davemloft.net>
In-Reply-To: <1384913496-26261-1-git-send-email-freddy@asix.com.tw>
References: <1384913496-26261-1-git-send-email-freddy@asix.com.tw>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Nov 2013 21:40:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: freddy@asix.com.tw
Date: Wed, 20 Nov 2013 10:11:36 +0800

> From: Freddy Xin <freddy@asix.com.tw>
> 
> This patch adds a workaroud to solve Suspend/Resume issue that AX88772B turns
> off its Ethernet PHY power in the case that REMOTE_WAKEUP feature doesn't
> be set when system suspend. In this case, the PHY power will not be turned
> on again when system resume, so the HW reset must be added in the resume function.
> 
> Signed-off-by: Freddy Xin <freddy@asix.com.tw>
> Tested-by: Grant Grundler <grundler@chromium.org>

Like many similar patches I've seen recently, you cannot do this.

Now the the configuration that software things the PHY has is no
longer accurate.

If you absolutely must reset the chip on resume, you have to reprogram
the PHY with whatever settings were existed at the time of the suspend.
