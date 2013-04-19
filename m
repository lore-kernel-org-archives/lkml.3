Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab3DSUuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 16:50:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47800 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab3DSUuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 16:50:08 -0400
Date: Fri, 19 Apr 2013 16:50:06 -0400 (EDT)
Message-Id: <20130419.165006.1200833792933507239.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH net] hyperv: Fix a compiler warning in netvsc_send()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1366151150-14859-1-git-send-email-haiyangz@microsoft.com>
References: <1366151150-14859-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 19 Apr 2013 13:50:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Tue, 16 Apr 2013 15:25:50 -0700

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

Such build warning fixes are not appropriate for 'net' at this time, and
this patch does not apply to 'net-next', so I'm dropping this entirely.
