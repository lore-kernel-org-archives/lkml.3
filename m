Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbaJCPDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:03:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687AbaJCPDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:03:19 -0400
Message-ID: <1412348517.5410.13.camel@deneb.redhat.com>
Subject: Re: [PATCH] rtc: Disable EFI rtc for x86
From: Mark Salter <msalter@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>, Dave Young <dyoung@redhat.com>
Date: Fri, 03 Oct 2014 11:01:57 -0400
In-Reply-To: <1412339576-17972-1-git-send-email-matt@console-pimps.org>
References: <1412339576-17972-1-git-send-email-matt@console-pimps.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-03 at 13:32 +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> commit da167ad7638759 ("rtc: ia64: allow other architectures to use EFI
> RTC") inadvertently introduced a regression for x86. We've been careful
> not to enable the EFI rtc driver for x86 due to the generally buggy
> implementations of the time-related EFI runtime services.
> 
> Previous attempts have been made to us the time EFI services, but all
> have eventually been reverted due to crashes inside the firmware code.
> 
> In fact, since the above commit was merged we've seen reports of crashes
> on 32-bit tablets,
> 
>   https://bugzilla.kernel.org/show_bug.cgi?id=84241#c21
> 
> Disable it explicitly for x86 so that we don't give users false hope
> that this driver will work - it won't, and your machine is likely to
> crash.
> 
> Cc: Mark Salter <msalter@redhat.com>
> Cc: Dave Young <dyoung@redhat.com>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---

Acked-by: Mark Salter <msalter@redhat.com>

> 
> Unless anyone objects, I'm happy to take this through the EFI tree.
> 
>  drivers/rtc/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index a168e96142b9..54ef393b0def 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -806,7 +806,7 @@ config RTC_DRV_DA9063
>  
>  config RTC_DRV_EFI
>  	tristate "EFI RTC"
> -	depends on EFI
> +	depends on EFI && !X86
>  	help
>  	  If you say yes here you will get support for the EFI
>  	  Real Time Clock.


