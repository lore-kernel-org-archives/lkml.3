Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaIOP2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:28:03 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:9643 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbaIOP2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:28:01 -0400
X-IronPort-AV: E=Sophos;i="5.04,528,1406592000"; 
   d="scan'208";a="172429533"
Message-ID: <54170579.9040406@citrix.com>
Date: Mon, 15 Sep 2014 16:27:53 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, David Vrabel <david.vrabel@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <mukesh.rathor@oracle.com>
CC: <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/4] drivers/xen/xenbus/xenbus_client.c: Correct
 the comments for xenbus_grant_ring()
References: <54157282.40402@gmail.com> <541572F6.3090900@gmail.com>
In-Reply-To: <541572F6.3090900@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/09/14 11:50, Chen Gang wrote:
> Both zero and positive number can indicate success, so the original
> comments need be improved.
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  drivers/xen/xenbus/xenbus_client.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
> index 277e74d..e2cf681 100644
> --- a/drivers/xen/xenbus/xenbus_client.c
> +++ b/drivers/xen/xenbus/xenbus_client.c
> @@ -361,8 +361,8 @@ static void xenbus_switch_fatal(struct xenbus_device *dev, int depth, int err,
>   * @ring_mfn: mfn of ring to grant
>  
>   * Grant access to the given @ring_mfn to the peer of the given device.  Return
> - * 0 on success, or -errno on error.  On error, the device will switch to
> - * XenbusStateClosing, and the error will be saved in the store.
> + * 0 or positive number on success, or -errno on error.  On error, the device
> + * will switch to XenbusStateClosing, and the error will be saved in the store.

If you're going to update this comment, please state what it is actually
returning: i.e., a grant reference or -ve on error.

David
