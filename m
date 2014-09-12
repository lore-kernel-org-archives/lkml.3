Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaILRZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:25:11 -0400
Received: from smtp-out-138.synserver.de ([212.40.185.138]:1193 "EHLO
	smtp-out-138.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaILRZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:25:09 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 22411
Message-ID: <54132C78.9000300@metafoo.de>
Date: Fri, 12 Sep 2014 19:25:12 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        jic23@kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: michals@xilinx.com, svemula@xilinx.com, anirudh@xilinx.com,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Subject: Re: [PATCH] iio: adc: xilinx-xadc: assign auxiliary channels address
 correctly
References: <344d9464-c489-42cd-b9c4-a63759f8f6da@BL2FFO11FD040.protection.gbl>
In-Reply-To: <344d9464-c489-42cd-b9c4-a63759f8f6da@BL2FFO11FD040.protection.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 10:55 AM, Subbaraya Sundeep Bhatta wrote:
> This patch fixes incorrect logic for assigning address
> to auxiliary channels of xilinx xadc.
>
> Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

> ---
>   drivers/iio/adc/xilinx-xadc-core.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/iio/adc/xilinx-xadc-core.c b/drivers/iio/adc/xilinx-xadc-core.c
> index fd2745c..626b397 100644
> --- a/drivers/iio/adc/xilinx-xadc-core.c
> +++ b/drivers/iio/adc/xilinx-xadc-core.c
> @@ -1126,7 +1126,7 @@ static int xadc_parse_dt(struct iio_dev *indio_dev, struct device_node *np,
>   				chan->address = XADC_REG_VPVN;
>   			} else {
>   				chan->scan_index = 15 + reg;
> -				chan->scan_index = XADC_REG_VAUX(reg - 1);
> +				chan->address = XADC_REG_VAUX(reg - 1);
>   			}
>   			num_channels++;
>   			chan++;
>

