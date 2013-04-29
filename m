Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329Ab3D2SJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:09:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60095 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab3D2SJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:09:35 -0400
Date: Mon, 29 Apr 2013 14:09:32 -0400 (EDT)
Message-Id: <20130429.140932.1477434738582260564.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH net-next] hyperv: Fix a compiler warning in
 netvsc_send()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1367000755-2571-1-git-send-email-haiyangz@microsoft.com>
References: <1367000755-2571-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 29 Apr 2013 11:09:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Fri, 26 Apr 2013 11:25:55 -0700

> Fixed: warning: cast from pointer to integer of different size
> 
> The Hyper-V hosts always use 64 bit request id. The guests can have 32 or 64
> bit pointers which equal to the ulong type size. So we cast it to ulong type.
> And, assigning 32bit integer to 64 bit variable works fine.
> 
> The VMBus returns the same id in the completion packet. But the value has no
> effect on the host side.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied, but:

> -		req_id = (u64)packet;
> +		req_id = (ulong)packet;

I really do not like these shorthands for fundamental C types, we
generally do not use "ulong", "uint" etc.  Please expand them out
explicitly to "unsigned long", "unsigned int", etc.
