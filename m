Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab3IZHUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:20:35 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:43516 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab3IZHUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:20:33 -0400
Message-ID: <5243E033.7010403@gmail.com>
Date: Thu, 26 Sep 2013 09:20:19 +0200
From: Richard Genoud <richard.genoud@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: dedekind1@gmail.com, dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] UBI: Fix error path in scan_pool()
References: <1380141125-11063-1-git-send-email-richard@nod.at>
In-Reply-To: <1380141125-11063-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/09/2013 22:32, Richard Weinberger wrote:
> We have to set "ret", not "err" in case of an error.
> 
> Reported-by: Richard Genoud <richard.genoud@gmail.com>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/mtd/ubi/fastmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
> index f5aa4b0..9b42add 100644
> --- a/drivers/mtd/ubi/fastmap.c
> +++ b/drivers/mtd/ubi/fastmap.c
> @@ -428,7 +428,7 @@ static int scan_pool(struct ubi_device *ubi, struct ubi_attach_info *ai,
>  		if (be32_to_cpu(ech->image_seq) != ubi->image_seq) {
>  			ubi_err("bad image seq: 0x%x, expected: 0x%x",
>  				be32_to_cpu(ech->image_seq), ubi->image_seq);
> -			err = UBI_BAD_FASTMAP;
> +			ret = UBI_BAD_FASTMAP;
>  			goto out;
>  		}
>  
> 

Tested-by: Richard Genoud <richard.genoud@gmail.com>

It reveals another bug though.

[    0.812500] UBI: default fastmap pool size: 95
[    0.820312] UBI: default fastmap WL pool size: 25
[    0.820312] UBI: attaching mtd2 to ubi0
[    0.914062] UBI error: scan_pool: bad image seq: 0x0, expected: 0x352a9728
[    0.921875] UBI error: ubi_scan_fastmap: Attach by fastmap failed, doing a full scan!
[    0.929687] kmem_cache_destroy ubi_ainf_peb_slab: Slab cache still has objects
[    0.937500] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.1 #15
[    0.945312] [<c0012e20>] (unwind_backtrace+0x0/0xe0) from [<c0010bb8>] (show_stack+0x10/0x14)
[    0.953125] [<c0010bb8>] (show_stack+0x10/0x14) from [<c01a15e4>] (destroy_ai+0x230/0x244)
[    0.960937] [<c01a15e4>] (destroy_ai+0x230/0x244) from [<c01a2c5c>] (ubi_attach+0x1f8/0x34c)
[    0.968750] [<c01a2c5c>] (ubi_attach+0x1f8/0x34c) from [<c0197678>] (ubi_attach_mtd_dev+0x2b8/0x86c)
[    0.976562] [<c0197678>] (ubi_attach_mtd_dev+0x2b8/0x86c) from [<c0346630>] (ubi_init+0x1d8/0x29c)
[    0.984375] [<c0346630>] (ubi_init+0x1d8/0x29c) from [<c0008810>] (do_one_initcall+0x94/0x144)
[    0.992187] [<c0008810>] (do_one_initcall+0x94/0x144) from [<c0335a9c>] (kernel_init_freeable+0xe8/0x1ac)
[    1.000000] [<c0335a9c>] (kernel_init_freeable+0xe8/0x1ac) from [<c0251500>] (kernel_init+0x8/0xe4)
[    1.007812] [<c0251500>] (kernel_init+0x8/0xe4) from [<c000e590>] (ret_from_fork+0x14/0x24)
[    1.742187] UBI: scanning is finished

Thanks !

Richard.
