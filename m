Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbaIWIuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:50:50 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:53470 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751533AbaIWIus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:50:48 -0400
Message-ID: <1411462245.20236.17.camel@x220>
Subject: Re: [PATCH] rtc: pm8xxx: rework to support pm8941 rtc
From: Paul Bolle <pebolle@tiscali.nl>
To: Stanimir Varbanov <svarbanov@mm-sol.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>
Date: Tue, 23 Sep 2014 10:50:45 +0200
In-Reply-To: <1410515044-31689-1-git-send-email-svarbanov@mm-sol.com>
References: <1410515044-31689-1-git-send-email-svarbanov@mm-sol.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Sep 2014 08:50:45.0786 (UTC) FILETIME=[76FBCFA0:01CFD70B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stanimar,

On Fri, 2014-09-12 at 12:44 +0300, Stanimir Varbanov wrote:
> Adds support for RTC device inside PM8941 PMIC. The RTC
> in this PMIC have two register spaces. Thus the rtc-pm8xxx
> is slightly reworked to reflect these differences.
> 
> The register set for different PMIC chips are selected
> on DT compatible string base.
> 
> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>

This patch just landed in next-20140923 as commit 99abd227988a
("drivers/rtc/rtc-pm8xxx.c: rework to support pm8941 rtc").

> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -1283,7 +1283,7 @@ config RTC_DRV_LPC32XX
>  
>  config RTC_DRV_PM8XXX
>  	tristate "Qualcomm PMIC8XXX RTC"
> -	depends on MFD_PM8XXX
> +	depends on MFD_PM8XXX || MFD_SPMI_PMIC

There's currently no Kconfig symbol MFD_SPMI_PMIC in linux-next. I guess
it's currently queued somewhere. Is that correct?

>  	help
>  	  If you say yes here you get support for the
>  	  Qualcomm PMIC8XXX RTC.

Thanks,


Paul Bolle

