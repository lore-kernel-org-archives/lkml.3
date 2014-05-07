Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467AbaEGJpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:45:44 -0400
Received: from mailapp01.imgtec.com ([195.89.28.114]:28895 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932169AbaEGJpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:45:42 -0400
Message-ID: <536A00C3.9020701@imgtec.com>
Date: Wed, 7 May 2014 10:45:39 +0100
From: Markos Chandras <Markos.Chandras@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>, <ralf@linux-mips.org>,
        <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
CC: <julia.lawall@lip6.fr>
Subject: Re: [PATCH] MIPS: Introduce the use of the managed version of kzalloc
References: <20140507044211.GA3158@himangi-Dell>
In-Reply-To: <20140507044211.GA3158@himangi-Dell>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.35]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/07/2014 05:43 AM, Himangi Saraogi wrote:
> This patch moves data allocated using kzalloc to managed data allocated
> using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
> functions.The labels out and out_mem are also removed as they are no
> longer required.
> 
> The following Coccinelle semantic patch was used for making the change:
> [..]
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> ---
>  arch/mips/mti-sead3/sead3-i2c-drv.c | 37 ++++++++++++++-----------------------
>  1 file changed, 14 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/mips/mti-sead3/sead3-i2c-drv.c b/arch/mips/mti-sead3/sead3-i2c-drv.c
> index 1f787a6..4d72e0e 100644
> --- a/arch/mips/mti-sead3/sead3-i2c-drv.c
> +++ b/arch/mips/mti-sead3/sead3-i2c-drv.c
> @@ -304,22 +304,18 @@ static int sead3_i2c_platform_probe(struct platform_device *pdev)
>  	int ret;
>[...]
> -	return ret;
> +	if (ret)
> +		return ret;
> +	
     ^^^^ trailing whitespace

Apart from that, the patch seems to be ok. Thanks!

Tested-by: Markos Chandras <markos.chandras@imgtec.com>
Reviewed-by: Markos Chandras <markos.chandras@imgtec.com>

-- 
markos
