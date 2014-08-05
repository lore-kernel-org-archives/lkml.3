Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaHEUDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 16:03:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57927 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbaHEUDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 16:03:48 -0400
Date: Tue, 05 Aug 2014 13:03:46 -0700 (PDT)
Message-Id: <20140805.130346.2080401893280146356.davem@davemloft.net>
To: thomas1206@gmail.com
Cc: netdev@vger.kernel.org, haiyangz@microsoft.com, kys@microsoft.com,
        olaf@aepfle.de, jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next] hyperv: Increase the buffer length for
 netvsc_channel_cb()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1406908530-22667-1-git-send-email-haiyangz@microsoft.com>
References: <1406908530-22667-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Aug 2014 13:03:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <thomas1206@gmail.com>
Date: Fri,  1 Aug 2014 15:55:30 +0000

> When the buffer is too small for a packet from VMBus, a bigger buffer will be
> allocated in netvsc_channel_cb() and retry reading the packet from VMBus.
> Increasing this buffer size will reduce the retry overhead.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: Dexuan Cui <decui@microsoft.com>

I'm not applying this, sorry.

I said that because the structure that contains this buffer is now
larger than a page, you should allocate the CB buffer externally
via another kmalloc() or via the page allocator.
