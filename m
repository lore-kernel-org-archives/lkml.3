Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab3HLKdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:33:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53662 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab3HLKdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:33:40 -0400
X-AuditID: cbfee691-b7fef6d000002d62-3f-5208ba02ca99
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Derek Basehore'" <dbasehore@chromium.org>
Cc: "'Chris Ball'" <cjb@laptop.org>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <rob.herring@calxeda.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <1375846138-15839-1-git-send-email-dbasehore@chromium.org>
In-reply-to: <1375846138-15839-1-git-send-email-dbasehore@chromium.org>
Subject: RE: [PATCH] mmc: dw_mmc: Don't disable vmmc if keeping power in suspend
Date: Mon, 12 Aug 2013 19:33:38 +0900
Message-id: <000001ce9747$680a9800$381fc800$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6THkXRLhCzjm9TR9ixc+ypb7DaZAEFCkOA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zY12mXRxBBnM/aFpsf72RzeLV5j1s
	FvOPnGO1OPBnB6PF5V1z2CyO/O9ntDi84gCTA7vHgs9X2D1mN1xk8Th0ZS2jx51re9g8Pm+S
	C2CN4rJJSc3JLEst0rdL4MpouXKHqWACT8XHP4fYGhjvc3YxcnJICJhIHG/ZwQhhi0lcuLee
	rYuRi0NIYBmjxO/fj1i7GDnAivY2eIPUCAksYpRY/8oBouYPo8SbLW/YQRJsAloSf9+8YQax
	RQR0JY4cO8gEUsQscJZRYuKuIywQ3W4SL65tASviFHCXOL/+LzPIAmGBAIlV04tAwiwCqhIb
	l5xnA7F5BWwlrs5cxQJhC0r8mHwPzGYWMJB4P6uPFcKWl9i85i0zxJ3qEo/+6kKcYCRx5Np+
	NogSEYl9L94xgpwjIfCWXWLitd8sELsEJL5NPsQC0SsrsekAMyQcJCUOrrjBMoFRYhaSzbOQ
	bJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAiJ3Yk7GO8fsD7EmAy0fiKz
	lGhyPjD280riDY3NjCxMTUyNjcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTB
	KdXAyDp1y3nF+24HD+utVpk3vU6bJY3nTE/O/qLZvBtkVXZIl1RVZU3weDAn2rS19conq0i5
	+Q9uF2ax3HyoMedmbrl8teSWGfGbJ94KXMRV7umUOXFWcV+KQUbXsVPLlVYrqLxx2bsiTZr9
	5PucOS0RzslPhSaFvz9vaFDTxPTwl8Wk0JAXus43lFiKMxINtZiLihMBD49E5/MCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jAV2mXRxBBr8OqFhsf72RzeLV5j1s
	FvOPnGO1OPBnB6PF5V1z2CyO/O9ntDi84gCTA7vHgs9X2D1mN1xk8Th0ZS2jx51re9g8Pm+S
	C2CNamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6
	Q0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY0XLlDlPBBJ6Kj38OsTUw
	3ufsYuTgkBAwkdjb4N3FyAlkiklcuLeeDcQWEljEKLH+lUMXIxeQ/YdR4s2WN+wgCTYBLYm/
	b94wg9giAroSR44dZAIpYhY4yygxcdcRFohuN4kX17aAFXEKuEucX/+XGWSZsECAxKrpRSBh
	FgFViY1LzoMt4xWwlbg6cxULhC0o8WPyPTCbWcBA4v2sPlYIW15i85q3zBA3q0s8+qsLcYKR
	xJFr+9kgSkQk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXr
	JefnbmIEJ4Zn0jsYVzVYHGIU4GBU4uH1+MIeJMSaWFZcmXuIUYKDWUmEV20eR5AQb0piZVVq
	UX58UWlOavEhxmSgRycyS4km5wOTVl5JvKGxiZmRpZGZhZGJuTlpwkrivAdbrQOFBNITS1Kz
	U1MLUotgtjBxcEo1MC7g55YtfpD4omhOUCrrq+mvmvcveHTocCqHT7DLJonw+z2q/3fnB8/f
	Mk2rK8yGb93NhaUSYruuTpXP82CoYnUx+RxUkrCwt/3ZgSnW1tO0LnJmB+zY9frmjgkaItf7
	95Spn5TligswKcxaXsWVXMnWWT5phky/6XM3g8DJDasPlb3yF47RVmIpzkg01GIuKk4EAKRU
	wbpQAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, August 07, 2013, Derek Basehore
> If we keep power for suspend on a host for dw_mmc, don't disable vmmc-supply
> regulator when suspending the host.

I have a trivial comment.
It would be better to add some macro for checking MMC_PM_KEEP_POWER.
And I just wonder how the problem is silent. Origin code has stood up somewhat long.
Did you see?

Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

Thanks,
Seungwon Jeon

> 
> Signed-off-by: Derek Basehore <dbasehore@chromium.org>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mmc/host/dw_mmc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index ee5f167..bf82d7c 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -2474,7 +2474,7 @@ int dw_mci_suspend(struct dw_mci *host)
>  		}
>  	}
> 
> -	if (host->vmmc)
> +	if (host->vmmc && !(host->pdata->pm_caps & MMC_PM_KEEP_POWER))
>  		regulator_disable(host->vmmc);
> 
>  	return 0;
> @@ -2485,7 +2485,7 @@ int dw_mci_resume(struct dw_mci *host)
>  {
>  	int i, ret;
> 
> -	if (host->vmmc) {
> +	if (host->vmmc && !(host->pdata->pm_caps & MMC_PM_KEEP_POWER)) {
>  		ret = regulator_enable(host->vmmc);
>  		if (ret) {
>  			dev_err(host->dev,
> --
> 1.8.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

