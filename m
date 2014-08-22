Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbaHVMpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:45:23 -0400
Received: from smtp.citrix.com ([66.165.176.89]:20100 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756052AbaHVMpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:45:22 -0400
X-IronPort-AV: E=Sophos;i="5.04,380,1406592000"; 
   d="scan'208";a="164140197"
Message-ID: <53F73B5F.70009@citrix.com>
Date: Fri, 22 Aug 2014 13:45:19 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Arianna Avanzini <avanzini.arianna@gmail.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
CC: <bob.liu@oracle.com>, <felipe.franciosi@citrix.com>, <axboe@fb.com>
Subject: Re: [PATCH RFC 2/4] xen, blkfront: factor out flush-related checks
 from do_blkif_request()
References: <1408706404-6614-1-git-send-email-avanzini.arianna@gmail.com> <1408706404-6614-3-git-send-email-avanzini.arianna@gmail.com>
In-Reply-To: <1408706404-6614-3-git-send-email-avanzini.arianna@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/14 12:20, Arianna Avanzini wrote:
> This commit factors out some checks related to the request insertion
> path, which now are performed by both the multi-queue and the request-
> queue hooks. This commit introduces no functional change.
> 
> Signed-off-by: Arianna Avanzini <avanzini.arianna@gmail.com>
> ---
>  drivers/block/xen-blkfront.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 0407ad5..a047346 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -588,6 +588,14 @@ static inline void flush_requests(struct blkfront_info *info)
>  		notify_remote_via_irq(info->irq);
>  }
>  
> +static inline bool blkif_request_flush_mismatch(struct request *req,
> +						struct blkfront_info *info)

blkif_request_flush_valid() is a better name/sense, I think.

Otherwise,

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
