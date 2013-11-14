Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab3KNTZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 14:25:28 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:63445 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab3KNTZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 14:25:19 -0500
X-AuditID: cbfec373-b7f356d000006018-a1-5285239fd4e4
Date: Thu, 14 Nov 2013 17:25:13 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: dougthompson@xmission.com, linux-edac@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, mchehab@redhat.com,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] edac: cell_edac: fix missing of_node_put
Message-id: <20131114172513.6f1b1e7b@samsung.com>
In-reply-to: <521AFB77.9080401@huawei.com>
References: <521AFB77.9080401@huawei.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/hIN35yq1BBps2cVhMvrWXzeLqsrNM
	Fs2L17NZXDjVwGRxedccNotJHb3sFnuOHmZ3YPdoOfKW1WP/3DXsHu/3XWXz+LxJzmPKoXaW
	ANYoLpuU1JzMstQifbsEroxJF76xFvxlq+iZfYG9gfEGaxcjJ4eEgInE2dlt7BC2mMSFe+vZ
	uhi5OIQEljBKnLsxmwXC6WaSeLxkF1gVi4CqxJSPv8BsNgEjiVeNLWCTRAS0JRr/L2IDsZkF
	djNKtC5gBrGFBWwlNh14xghi8woYSqw8uBgszimgJTHl3g0mEFtIQFPi/eZOoJkcQFc4Sew+
	IAVRLijxY/I9FoiRWhKbtzWxQtjyEpvXvGWewCgwC0nZLCRls5CULWBkXsUoWlqcXFCclJ5r
	pFecmFtcmpeul5yfu4kREuTFOxhfbLA6xCjAwajEw8sg2RokxJpYVlyZe4hRgoNZSYT3AhNQ
	iDclsbIqtSg/vqg0J7X4ECMTB6dUA6Pg1BMbcvTC7zUKvFi/MNuocL5B99F3s7a1yFfrvfg5
	/d6P9mbftT12CbNOHT5zNKtk0dK9iRxT4zN3qJaypE5sjGi7/M5kRWqVcZ2Hec8MXcWorbr3
	+b792HSG/8OdPXNe+Kcadn2bwa5rqXSAq0UwUy/MjqtbV+yugOiVHa92VPPX/XgcO0+JpTgj
	0VCLuag4EQD/fpGwUAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 26 Aug 2013 14:53:43 +0800
Libo Chen <clbchenlibo.chen@huawei.com> escreveu:

> 
> decrease device_node refcount np after task completion
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>


Applied.

Patch is at:
	http://git.infradead.org/users/mchehab/edac.git
and
	http://git.kernel.org/cgit/linux/kernel/git/mchehab/linux-edac.git

> ---
>  drivers/edac/cell_edac.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
> index c2eaf33..493dc30 100644
> --- a/drivers/edac/cell_edac.c
> +++ b/drivers/edac/cell_edac.c
> @@ -162,6 +162,7 @@ static void cell_edac_init_csrows(struct mem_ctl_info *mci)
>  			csrow->first_page, nr_pages);
>  		break;
>  	}
> +	of_node_put(np);
>  }
> 
>  static int cell_edac_probe(struct platform_device *pdev)


-- 

Cheers,
Mauro
