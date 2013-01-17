Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab3AQFdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 00:33:15 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54574 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab3AQFdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 00:33:14 -0500
X-Greylist: delayed 956 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jan 2013 00:33:14 EST
Message-ID: <50F7894D.3070901@cs.wisc.edu>
Date: Wed, 16 Jan 2013 23:17:01 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
CC: linux-scsi@vger.kernel.org, JBottomley@parallels.com,
        linux-kernel@vger.kernel.org, kxie@chelsio.com,
        Divy La Rey <divy@chelsio.com>
Subject: Re: [PATCH] cxgb4i: Remove the scsi host device when removing device
References: <1357931529-10248-1-git-send-email-cascardo@linux.vnet.ibm.com>
In-Reply-To: <1357931529-10248-1-git-send-email-cascardo@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 01:12 PM, Thadeu Lima de Souza Cascardo wrote:
> When doing a hotplug remove of a cxgb4 device, there are still dandling
> symlinks at /sys/class/scsi_host/hostX to the removed PCI device. The
> upper layer device may also try to send data, which may crash the
> system.
> 
> The DETACH message from the lower level driver is sent to the ULD when
> the device is removed, when the scsi host should be removed from the
> system, avoiding any problems.
> 
> After this patch, there are no more dangling symlinks and many attempts
> to crash the system while there is SCSI activity and removing the device
> have failed. Adding the device back again works as expected, with the
> scsi hosts showing up again.
> 
> Based on a patch by Karen Xie.
> 
> Cc: Karen Xie <kxie@chelsio.com>
> Cc: Divy La Rey <divy@chelsio.com>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
> ---
>  drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
> index f924b3c..3fecf35 100644
> --- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
> +++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
> @@ -1564,6 +1564,7 @@ static int t4_uld_state_change(void *handle, enum cxgb4_state state)
>  		break;
>  	case CXGB4_STATE_DETACH:
>  		pr_info("cdev 0x%p, DETACH.\n", cdev);
> +		cxgbi_device_unregister(cdev);
>  		break;
>  	default:
>  		pr_info("cdev 0x%p, unknown state %d.\n", cdev, state);
> 

Patch looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

