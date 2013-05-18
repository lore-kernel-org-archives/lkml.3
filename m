Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab3EROtc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 10:49:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:16824 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab3EROta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 10:49:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,700,1363158000"; 
   d="scan'208";a="336280002"
Date: Sat, 18 May 2013 07:49:20 -0700
From: Jon Mason <jon.mason@intel.com>
To: Jonghwan Choi <jhbird.choi@gmail.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: Re: [PATCH 3.9-stable] NTB: Multiple NTB client fix
Message-ID: <20130518144920.GH29066@jonmason-lab>
References: <1368845849-4360-1-git-send-email-jhbird.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368845849-4360-1-git-send-email-jhbird.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 18, 2013 at 11:57:29AM +0900, Jonghwan Choi wrote:
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
> commit 8b19d450ad188d402a183ff4a4d40f31c3916fbf upstream
> 
> Fix issue with adding multiple ntb client devices to the ntb virtual
> bus.  Previously, multiple devices would be added with the same name,
> resulting in crashes.  To get around this issue, add a unique number to
> the device when it is added.
> 
> Cc: <stable@vger.kernel.org> # 3.9.x: ad3e2751: ntb: off by one
> Cc: <stable@vger.kernel.org> # 3.9.x: cc0f868d: NTB: fix pointer math
> Cc: <stable@vger.kernel.org> # 3.9.x: 113fc505: NTB: Handle 64bit BAR
> Cc: <stable@vger.kernel.org> # 3.9.x: b77b2637: NTB: Link toggle memory
> Cc: <stable@vger.kernel.org> # 3.9.x: 90f9e934: NTB: reset tx_index on
> Cc: <stable@vger.kernel.org> # 3.9.x: c9d534c8: NTB: Correctly handle receive
> Cc: <stable@vger.kernel.org> # 3.9.x: c336acd3: NTB: memcpy lockup workaround
> Cc: <stable@vger.kernel.org> # 3.9.x: 904435cf: ntb_netdev: remove from list
> Signed-off-by: Jon Mason <jon.mason@intel.com>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/ntb/ntb_transport.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
> index 0f66daa..f365b2f 100644
> --- a/drivers/ntb/ntb_transport.c
> +++ b/drivers/ntb/ntb_transport.c
> @@ -300,7 +300,7 @@ int ntb_register_client_dev(char *device_name)
>  {
>  	struct ntb_transport_client_dev *client_dev;
>  	struct ntb_transport *nt;
> -	int rc;
> +	int rc, i = 0;
>  
>  	if (list_empty(&ntb_transport_list))
>  		return -ENODEV;
> @@ -318,7 +318,7 @@ int ntb_register_client_dev(char *device_name)
>  		dev = &client_dev->dev;
>  
>  		/* setup and register client devices */
> -		dev_set_name(dev, "%s", device_name);
> +		dev_set_name(dev, "%s%d", device_name, i);
>  		dev->bus = &ntb_bus_type;
>  		dev->release = ntb_client_release;
>  		dev->parent = &ntb_query_pdev(nt->ndev)->dev;
> @@ -330,6 +330,7 @@ int ntb_register_client_dev(char *device_name)
>  		}
>  
>  		list_add_tail(&client_dev->entry, &nt->client_devs);
> +		i++;
>  	}
>  
>  	return 0;
> -- 
> 1.8.1.2
> 
