Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935398Ab3BOGEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:04:44 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9021 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab3BOGEn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:04:43 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 14 Feb 2013 22:04:17 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Jingoo Han <jg1.han@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Date: Fri, 15 Feb 2013 11:34:08 +0530
Subject: RE: [PATCH 03/11] rtc: rtc-efi: use pr_err()/pr_warn() instead of
 printk()
Thread-Topic: [PATCH 03/11] rtc: rtc-efi: use pr_err()/pr_warn() instead of
 printk()
Thread-Index: Ac4LQUiQnZ5yIGDDRaO8BQe4Zm4AfgAAChJgAAAhmmA=
Message-ID: <D958900912E20642BCBC71664EFECE3E6E1B91EC16@BGMAIL02.nvidia.com>
References: <001201ce0b41$4900c4d0$db024e70$%han@samsung.com>
 <001401ce0b41$83d7c9a0$8b875ce0$%han@samsung.com>
In-Reply-To: <001401ce0b41$83d7c9a0$8b875ce0$%han@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Jingoo Han
> Sent: Friday, February 15, 2013 11:29 AM
> To: 'Andrew Morton'
> Cc: linux-kernel@vger.kernel.org; 'Alessandro Zummo'; rtc-
> linux@googlegroups.com; 'Jingoo Han'
> Subject: [PATCH 03/11] rtc: rtc-efi: use pr_err()/pr_warn() instead of printk()
> 
> Fixed the checkpatch warnings as below:
> 
>   WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...
> to printk(KERN_ERR ...
>   WARNING: please, no space before tabs
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/rtc/rtc-efi.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
>  	eft->timezone	= EFI_UNSPECIFIED_TIMEZONE;
> @@ -142,7 +144,7 @@ static int efi_set_alarm(struct device *dev, struct
> rtc_wkalrm *wkalrm)
>  	 */
>  	status = efi.set_wakeup_time((efi_bool_t)wkalrm->enabled, &eft);
> 
> -	printk(KERN_WARNING "write status is %d\n", (int)status);
> +	pr_warn("write status is %d\n", (int)status);

Why don't you use dev_warn itself? 

> 
>  	return status == EFI_SUCCESS ? 0 : -EINVAL;
>  }
> @@ -157,7 +159,7 @@ static int efi_read_time(struct device *dev, struct
> rtc_time *tm)
> 
>  	if (status != EFI_SUCCESS) {
>  		/* should never happen */
> -		printk(KERN_ERR "efitime: can't read time\n");
> +		pr_err("can't read time\n");

Why don't you use dev_err itself?  

>  		return -EINVAL;
>  	}
> 
> --
> 1.7.2.5
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
