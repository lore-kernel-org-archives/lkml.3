Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161501Ab3FUOGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:06:50 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45916 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422676Ab3FUOGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:06:49 -0400
Date: Fri, 21 Jun 2013 09:05:51 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: josh.h.morris@us.ibm.com, axboe@kernel.dk, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] rsxx: fix error return code in rsxx_pci_probe()
Message-ID: <20130621140551.GO6492@oc6784271780.ibm.com>
References: <CAPgLHd8cSqV_+bqNq7d8HedKL5BXdqC5-sqqkOM7kVZJK7cumg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd8cSqV_+bqNq7d8HedKL5BXdqC5-sqqkOM7kVZJK7cumg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062114-3620-0000-0000-0000033B4792
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 10:46:38AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return -ENOMEM in the create_singlethread_workqueue() error handling
> case instead of 0, as done elsewhere in this function.
> 
> Introduced by commit a3299ab18591d36ad5622f5064619123c439b779.
> (rsxx: Individual workqueues for interruptible events.)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/block/rsxx/core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
> index 6e85e21..11eb897 100644
> --- a/drivers/block/rsxx/core.c
> +++ b/drivers/block/rsxx/core.c
> @@ -946,6 +946,7 @@ static int rsxx_pci_probe(struct pci_dev *dev,
>  	card->event_wq = create_singlethread_workqueue(DRIVER_NAME"_event");
>  	if (!card->event_wq) {
>  		dev_err(CARD_TO_DEV(card), "Failed card event setup.\n");
> +		st = -ENOMEM;
>  		goto failed_event_handler;
>  	}

Thank You for fixing that.

> 
> 

