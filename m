Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaLMRzX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 12:55:23 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:60865 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaLMRzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 12:55:22 -0500
Date: Sat, 13 Dec 2014 09:55:18 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Loic Pefferkorn <loic@loicp.eu>
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com, jun.j.tian@intel.com,
        octavian.purdila@intel.com, nnk@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: goldfish: Fix minor coding style
Message-ID: <20141213175518.GA28616@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Loic Pefferkorn <loic@loicp.eu>, gregkh@linuxfoundation.org,
	alan@linux.intel.com, jun.j.tian@intel.com,
	octavian.purdila@intel.com, nnk@google.com,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <e2a3b3ccf85790c865683832698908458931be6a.1418487651.git.loic@loicp.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2a3b3ccf85790c865683832698908458931be6a.1418487651.git.loic@loicp.eu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Loic,

On Sat, Dec 13, 2014 at 05:29:26PM +0100, Loic Pefferkorn wrote:
> Hello,
> 
> The convention for checking for NULL pointers is !ptr and not ptr == NULL.
> This patch fixes such occurences in goldfish driver, it applies against next-20141212
> 
Whose convention is this?  I can't find any mention in
Documention/CodingStyle. checkpatch.pl doesn't complain about them.
And there are almost three thousand examples in staging which don't
use this convention.

  linux-next$ grep -r "== NULL" drivers/staging/* | wc -l
  2844

> 
> Signed-off-by: Loic Pefferkorn <loic@loicp.eu>
> ---
>  drivers/staging/goldfish/goldfish_audio.c |  8 ++++----
>  drivers/staging/goldfish/goldfish_nand.c  | 10 +++++-----
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/goldfish/goldfish_audio.c b/drivers/staging/goldfish/goldfish_audio.c
> index f200359..7ab034b 100644
> --- a/drivers/staging/goldfish/goldfish_audio.c
> +++ b/drivers/staging/goldfish/goldfish_audio.c
> @@ -273,19 +273,19 @@ static int goldfish_audio_probe(struct platform_device *pdev)
>  	dma_addr_t buf_addr;
>  
>  	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
> -	if (data == NULL)
> +	if (!data)
>  		return -ENOMEM;
>  	spin_lock_init(&data->lock);
>  	init_waitqueue_head(&data->wait);
>  	platform_set_drvdata(pdev, data);
>  
>  	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (r == NULL) {
> +	if (!r) {
>  		dev_err(&pdev->dev, "platform_get_resource failed\n");
>  		return -ENODEV;
>  	}
>  	data->reg_base = devm_ioremap(&pdev->dev, r->start, PAGE_SIZE);
> -	if (data->reg_base == NULL)
> +	if (!data->reg_base)
>  		return -ENOMEM;
>  
[...]

-- 
- Jeremiah Mahler
