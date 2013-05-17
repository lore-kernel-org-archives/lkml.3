Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab3EQJ25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 05:28:57 -0400
Received: from nbd.name ([46.4.11.11]:58272 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab3EQJ24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 05:28:56 -0400
Message-ID: <5195F730.6080103@phrozen.org>
Date: Fri, 17 May 2013 11:24:00 +0200
From: John Crispin <john@phrozen.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Libo Chen <clbchenlibo.chen@huawei.com>
CC: ralf@linux-mips.org, grant.likely@linaro.org, rob.herring@calxeda.com,
        linux-mips@linux-mips.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] MIPS: drivers: fix clk leak
References: <5195CC6B.1000607@huawei.com>
In-Reply-To: <5195CC6B.1000607@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/05/13 08:21, Libo Chen wrote:
>
> when gptu_r32 fail, we should put clk before return
>
> Signed-off-by: Libo Chen<libo.chen@huawei.com>

Acked-by: John Crispin <blogic@openwrt.org>



> ---
>   arch/mips/lantiq/xway/gptu.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/mips/lantiq/xway/gptu.c b/arch/mips/lantiq/xway/gptu.c
> index 9861c86..4fa577c 100644
> --- a/arch/mips/lantiq/xway/gptu.c
> +++ b/arch/mips/lantiq/xway/gptu.c
> @@ -169,6 +169,8 @@ static int gptu_probe(struct platform_device *pdev)
>   	if (((gptu_r32(GPTU_ID)>>  8)&  0xff) != GPTU_MAGIC) {
>   		dev_err(&pdev->dev, "Failed to find magic\n");
>   		gptu_hwexit();
> +		clk_disable(clk);
> +		clk_put(clk);
>   		return -ENAVAIL;
>   	}
>

