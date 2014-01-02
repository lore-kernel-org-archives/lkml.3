Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaABNxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 08:53:13 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:61328 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaABNxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 08:53:12 -0500
X-IronPort-AV: E=Sophos;i="4.95,590,1384300800"; 
   d="scan'208";a="87034223"
Message-ID: <52C56F43.6030804@citrix.com>
Date: Thu, 2 Jan 2014 13:53:07 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Levente Kurusa <levex@linux.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Vrabel <david.vrabel@citrix.com>,
        <xen-devel@lists.xenproject.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH 26/38] xen: xenbus: add missing put_device
 call
References: <1387465429-3568-2-git-send-email-levex@linux.com> <1387465429-3568-27-git-send-email-levex@linux.com>
In-Reply-To: <1387465429-3568-27-git-send-email-levex@linux.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/12/13 15:03, Levente Kurusa wrote:
> This is required so that we give up the last reference to the device.
> 
> Signed-off-by: Levente Kurusa <levex@linux.com>
> ---
>  drivers/xen/xenbus/xenbus_probe.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
> index 3c0a74b..4abb9ee 100644
> --- a/drivers/xen/xenbus/xenbus_probe.c
> +++ b/drivers/xen/xenbus/xenbus_probe.c
> @@ -465,8 +465,10 @@ int xenbus_probe_node(struct xen_bus_type *bus,
>  
>  	/* Register with generic device framework. */
>  	err = device_register(&xendev->dev);
> -	if (err)
> +	if (err) {
> +		put_device(&xendev->dev);
>  		goto fail;
> +	}
>  
>  	return 0;
>  fail:

There is a kfree(xendev) here so this introduces a double-free.

David

