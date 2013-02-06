Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3BFLnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:43:16 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10784 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3BFLnN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 06:43:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 06 Feb 2013 03:42:34 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "a.zummo@towertech.it" <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Date: Wed, 6 Feb 2013 17:12:55 +0530
Subject: RE: [PATCH] rtc: Modify leap year test for more simpler way
Thread-Topic: [PATCH] rtc: Modify leap year test for more simpler way
Thread-Index: Ac4EXIG3VE8HfBPhSyeOlrlp6+mFqwAAjQrA
Message-ID: <D958900912E20642BCBC71664EFECE3E6E1B6C6A52@BGMAIL02.nvidia.com>
References: <1360149775-19606-1-git-send-email-jonghwa3.lee@samsung.com>
In-Reply-To: <1360149775-19606-1-git-send-email-jonghwa3.lee@samsung.com>
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

By definition, leap year is one, which is a divisible by 4 & 400, excluding multiples of 100s.
Hence I feel this patch is not correct.

Thanks,
Venu


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Jonghwa Lee
> Sent: Wednesday, February 06, 2013 4:53 PM
> To: linux-kernel@vger.kernel.org
> Cc: a.zummo@towertech.it; Andrew Morton; rtc-linux@googlegroups.com;
> Jonghwa Lee
> Subject: [PATCH] rtc: Modify leap year test for more simpler way
> 
> Leap year which is multiple of 4, just needed 2 LSB for verifying.
> A year with zero for all thease two bits means that it is leap year.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> ---
>  include/linux/rtc.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/rtc.h b/include/linux/rtc.h
> index 9531845..d662b8d 100644
> --- a/include/linux/rtc.h
> +++ b/include/linux/rtc.h
> @@ -181,7 +181,7 @@ void rtc_timer_do_work(struct work_struct *work);
> 
>  static inline bool is_leap_year(unsigned int year)
>  {
> -	return (!(year % 4) && (year % 100)) || !(year % 400);
> +	return !(year & 0x3);
>  }
> 
>  #ifdef CONFIG_RTC_HCTOSYS_DEVICE
> --
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
