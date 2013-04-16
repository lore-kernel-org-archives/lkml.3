Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964981Ab3DPTLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 15:11:47 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48704 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab3DPTLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 15:11:46 -0400
Date: Tue, 16 Apr 2013 15:11:41 -0400 (EDT)
Message-Id: <20130416.151141.1928940532005718606.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH net] hyperv: Fix a compiler warning in netvsc_send()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1366139031-12518-1-git-send-email-haiyangz@microsoft.com>
References: <1366139031-12518-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 16 Apr 2013 12:11:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Tue, 16 Apr 2013 12:03:51 -0700

> Fixed: warning: cast from pointer to integer of different size
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

If you're coding pointers into request IDs you better make that
explicit and add lots of comments explaining why that's OK and
why it's going to work fine in these circumstances.

I'm not applying this patch, it just makes a bad situation even
worse.  Either your request IDs are 64-bit or they are not, it
can't be both.
