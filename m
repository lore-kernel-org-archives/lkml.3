Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab3EROtF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 10:49:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:32541 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304Ab3EROtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 10:49:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,700,1363158000"; 
   d="scan'208";a="315796415"
Date: Sat, 18 May 2013 07:49:01 -0700
From: Jon Mason <jon.mason@intel.com>
To: Jonghwan Choi <jhbird.choi@gmail.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: Re: [PATCH 3.9-stable] ntb_netdev: remove from list on exit
Message-ID: <20130518144901.GG29066@jonmason-lab>
References: <1368845706-4300-1-git-send-email-jhbird.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368845706-4300-1-git-send-email-jhbird.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 18, 2013 at 11:55:06AM +0900, Jonghwan Choi wrote:
> From: Jon Mason <jon.mason@intel.com>
> 
> This patch looks like it should be in the 3.9-stable tree, should we apply
> it?

Yes, thanks.

> 
> ------------------
> 
> From: "Jon Mason <jon.mason@intel.com>"
> 
> commit 904435cf76a9bdd5eb41b1c4e049d5a64f3a8400 upstream
> 
> The ntb_netdev device is not removed from the global list of devices
> upon device removal.  If the device is re-added, the removal code would
> find the first instance and try to remove an already removed device.
> 
> Cc: <stable@vger.kernel.org> # 3.9.x: ad3e2751: ntb: off by one
> Cc: <stable@vger.kernel.org> # 3.9.x: cc0f868d: NTB: fix pointer math
> Cc: <stable@vger.kernel.org> # 3.9.x: 113fc505: NTB: Handle 64bit BAR
> Cc: <stable@vger.kernel.org> # 3.9.x: b77b2637: NTB: Link toggle memory
> Cc: <stable@vger.kernel.org> # 3.9.x: 90f9e934: NTB: reset tx_index on
> Cc: <stable@vger.kernel.org> # 3.9.x: c9d534c8: NTB: Correctly handle receive
> Cc: <stable@vger.kernel.org> # 3.9.x: c336acd3: NTB: memcpy lockup workaround
> Signed-off-by: Jon Mason <jon.mason@intel.com>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/net/ntb_netdev.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
> index ed947dd..f3cdf64 100644
> --- a/drivers/net/ntb_netdev.c
> +++ b/drivers/net/ntb_netdev.c
> @@ -375,6 +375,8 @@ static void ntb_netdev_remove(struct pci_dev *pdev)
>  	if (dev == NULL)
>  		return;
>  
> +	list_del(&dev->list);
> +
>  	ndev = dev->ndev;
>  
>  	unregister_netdev(ndev);
> -- 
> 1.8.1.2
> 
