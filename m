Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147AbaDICNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 22:13:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10499 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246AbaDICNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 22:13:45 -0400
X-AuditID: cbfee690-b7f266d00000287c-7f-5344accdcde9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Alan Stern'" <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, kgene.kim@samsung.com,
        "'Manjunath Goudar'" <csmanjuvijay@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1396968035-32286-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1396968035-32286-1-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH RESEND] usb: ohci-exynos: Remove locks for 'ohci' in
 suspend callback
Date: Wed, 09 Apr 2014 11:13:32 +0900
Message-id: <003a01cf5399$4e7e8590$eb7b90b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9TOT5FAkaxw8MaSI6xpw5D9unzPwAX5eXg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t8zfd2za1yCDb6t5bTYeeAau0XblYPs
	Fs2L17NZXF54idWid8FVNotNj6+xWlzeNYfNYsb5fUwWi5a1MltM+H2BzYHLY+esu+we++eu
	YffYvKTeY/bdH4wefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlbGjfxd7wU3eisdX9jE1ME7n
	7mLk5JAQMJF417KCHcIWk7hwbz1bFyMXh5DAMkaJhsef2GGK9jU+YIVILGKUeDT9AVTVb0aJ
	i28XsYBUsQmoSXz5chisQ0QgUmLP3YPsIEXMAn1MEre+bgQrEhLwkLhz/wOYzSngKXF3ZxMz
	iC0sEC0xc/sSJhCbRUBV4uaSe2wgNq+ArcSS+SeYIWxBiR+T74H1MgtoSazfeZwJwpaX2Lzm
	LVANB9Cp6hKP/upC3GAkcWjHOjaIEhGJfS/eMYLcIyHQySHx5fNpZohdAhLfJh9igeiVldh0
	gBniY0mJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT0otM9IoTc4tL89L1kvNz
	NzFC4nzCDsZ7B6wPMSYDrZ/ILCWanA9ME3kl8YbGZkYWpiamxkbmlmakCSuJ86o9SgoSEkhP
	LEnNTk0tSC2KLyrNSS0+xMjEwSnVwKhw0e1dz/WZuytFFKOTnnL8i13T+MpX5s8ynW7e+pen
	SnuDnG/6ec+dbrDbw2n6QYu5XyYeurB06dl5jTXXY584n1ktEX1j6pnO3R2/321dWCF+LPek
	ys+PkwWqGZp1BV5EJh3IUGX6oH3hQpuuiFVxP0/Oh1LvyUyN29gu2VVkdfvOF1edYaHEUpyR
	aKjFXFScCACWuT8iCQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMKsWRmVeSWpSXmKPExsVy+t9jAd2za1yCDXqbWCx2HrjGbtF25SC7
	RfPi9WwWlxdeYrXoXXCVzWLT42usFpd3zWGzmHF+H5PFomWtzBYTfl9gc+Dy2DnrLrvH/rlr
	2D02L6n3mH33B6NH35ZVjB6fN8kFsEU1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoa
	WlqYKynkJeam2iq5+AToumXmAJ2mpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gA
	DSSsY8zY0b+LveAmb8XjK/uYGhinc3cxcnJICJhI7Gt8wAphi0lcuLeerYuRi0NIYBGjxKPp
	D6Cc34wSF98uYgGpYhNQk/jy5TA7iC0iECmx5+5BdpAiZoE+JolbXzeCFQkJeEjcuf8BzOYU
	8JS4u7OJGcQWFoiWmLl9CROIzSKgKnFzyT02EJtXwFZiyfwTzBC2oMSPyffAepkFtCTW7zzO
	BGHLS2xe8xaohgPoVHWJR391IW4wkji0Yx0bRImIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEj
	yypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4CTyTHoH46oGi0OMAhyMSjy8CpYuwUKsiWXF
	lbmHGCU4mJVEeJ9nA4V4UxIrq1KL8uOLSnNSiw8xJgM9OpFZSjQ5H5jg8kriDY1NzIwsjcws
	jEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBMdvhebaGxrHy7odel25dujOZ9/Bs
	86UL1l7ki0iamWlgtC91u/9i4+NT+zneOvFqOvLLdk9LUbKy9Z6U2L5o0pvybb/z7dZ6RN36
	+1H+ZuvMSoF9TO1bxRY+3Nivn7bXJ/z4Uq7Hn1MtKx2b3KqCzjaWi+QwpZ+2PX9hQvm2+3p/
	Lx8uWNdyQYmlOCPRUIu5qDgRACvEcVJmAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 08, 2014 11:41 PM, Vivek Gautam wrote:
> 
> Patch : 14982e3 USB: OHCI: Properly handle ohci-exynos suspend
> has already removed 'ohci_hcd' settings from exynos glue layer
> as a part of streamlining the ohci controller's suspend.
> So we don't need the locks for 'ohci_hcd' anymore.

Right, this spin_lock/unlock is unnecessary, because it is
already used in ohci_suspend().

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Cc: Manjunath Goudar <csmanjuvijay@gmail.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> ---
>  drivers/usb/host/ohci-exynos.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
> index 68588d8..9cf80cb 100644
> --- a/drivers/usb/host/ohci-exynos.c
> +++ b/drivers/usb/host/ohci-exynos.c
> @@ -190,17 +190,13 @@ static int exynos_ohci_suspend(struct device *dev)
>  {
>  	struct usb_hcd *hcd = dev_get_drvdata(dev);
>  	struct exynos_ohci_hcd *exynos_ohci = to_exynos_ohci(hcd);
> -	struct ohci_hcd *ohci = hcd_to_ohci(hcd);
>  	struct platform_device *pdev = to_platform_device(dev);
>  	bool do_wakeup = device_may_wakeup(dev);
> -	unsigned long flags;
>  	int rc = ohci_suspend(hcd, do_wakeup);
> 
>  	if (rc)
>  		return rc;
> 
> -	spin_lock_irqsave(&ohci->lock, flags);
> -
>  	if (exynos_ohci->otg)
>  		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
> 
> @@ -208,8 +204,6 @@ static int exynos_ohci_suspend(struct device *dev)
> 
>  	clk_disable_unprepare(exynos_ohci->clk);
> 
> -	spin_unlock_irqrestore(&ohci->lock, flags);
> -
>  	return 0;
>  }
> 
> --
> 1.7.10.4

