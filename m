Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab3EGL3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 07:29:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45112 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab3EGL3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 07:29:01 -0400
Date: Tue, 07 May 2013 07:31:01 -0400 (EDT)
Message-Id: <20130507.073101.877164997428477669.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: torvalds@linux-foundation.org, bruce.w.allan@intel.com,
        netdev@vger.kernel.org, gospo@redhat.com, sassmann@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [net] e1000e: fix scheduling while atomic bug
From: David Miller <davem@davemloft.net>
In-Reply-To: <1367905967-12824-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1367905967-12824-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 07 May 2013 04:29:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Mon,  6 May 2013 22:52:47 -0700

> From: Bruce Allan <bruce.w.allan@intel.com>
> 
> A scheduling while atomic bug was introduced recently (by commit ce43a216
> e1000e: cleanup USLEEP_RANGE checkpatch checks).  Revert the particular
> instance of usleep_range() which causes the bug.
> 
> Reported-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
> Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Linus, please apply this directly, thanks:

Acked-by: David S. Miller <davem@davemloft.net>

> ---
>  drivers/net/ethernet/intel/e1000e/e1000.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
> index 82f1c84..ffbc08f 100644
> --- a/drivers/net/ethernet/intel/e1000e/e1000.h
> +++ b/drivers/net/ethernet/intel/e1000e/e1000.h
> @@ -600,7 +600,7 @@ static inline s32 __ew32_prepare(struct e1000_hw *hw)
>  	s32 i = E1000_ICH_FWSM_PCIM2PCI_COUNT;
>  
>  	while ((er32(FWSM) & E1000_ICH_FWSM_PCIM2PCI) && --i)
> -		usleep_range(50, 100);
> +		udelay(50);
>  
>  	return i;
>  }
> -- 
> 1.7.11.7
> 
