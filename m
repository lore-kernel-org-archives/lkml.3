Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab3JNItq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:49:46 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:40092 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab3JNItp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:49:45 -0400
Message-ID: <525BB025.8080508@suse.cz>
Date: Mon, 14 Oct 2013 10:49:41 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>, arnd@arndb.de,
        gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc: phantom: remove deprecated IRQF_DISABLED
References: <1381644967-9419-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1381644967-9419-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2013 08:16 AM, Michael Opdenacker wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Acked-by: Jiri Slaby <jslaby@suse.cz>

Thanks.

> ---
>  drivers/misc/phantom.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
> index 68b7c77..3075492 100644
> --- a/drivers/misc/phantom.c
> +++ b/drivers/misc/phantom.c
> @@ -395,7 +395,7 @@ static int phantom_probe(struct pci_dev *pdev,
>  	iowrite32(0, pht->caddr + PHN_IRQCTL);
>  	ioread32(pht->caddr + PHN_IRQCTL); /* PCI posting */
>  	retval = request_irq(pdev->irq, phantom_isr,
> -			IRQF_SHARED | IRQF_DISABLED, "phantom", pht);
> +			IRQF_SHARED, "phantom", pht);
>  	if (retval) {
>  		dev_err(&pdev->dev, "can't establish ISR\n");
>  		goto err_unmo;
> 


-- 
js
suse labs
