Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaIXKGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:06:22 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:59215 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaIXKGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:06:20 -0400
Date: Wed, 24 Sep 2014 11:06:05 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [PATCH] rtc: pm8xxx: rework to support pm8941 rtc
Message-ID: <20140924100604.GC19999@lee--X1>
References: <1410515044-31689-1-git-send-email-svarbanov@mm-sol.com>
 <1411462245.20236.17.camel@x220>
 <542143B2.1090707@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <542143B2.1090707@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014, Stanimir Varbanov wrote:

> Hi Paul,
> 
> On 09/23/2014 11:50 AM, Paul Bolle wrote:
> > Hi Stanimar,
> > 
> > On Fri, 2014-09-12 at 12:44 +0300, Stanimir Varbanov wrote:
> >> Adds support for RTC device inside PM8941 PMIC. The RTC
> >> in this PMIC have two register spaces. Thus the rtc-pm8xxx
> >> is slightly reworked to reflect these differences.
> >>
> >> The register set for different PMIC chips are selected
> >> on DT compatible string base.
> >>
> >> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> > 
> > This patch just landed in next-20140923 as commit 99abd227988a
> > ("drivers/rtc/rtc-pm8xxx.c: rework to support pm8941 rtc").
> > 
> >> --- a/drivers/rtc/Kconfig
> >> +++ b/drivers/rtc/Kconfig
> >> @@ -1283,7 +1283,7 @@ config RTC_DRV_LPC32XX
> >>  
> >>  config RTC_DRV_PM8XXX
> >>  	tristate "Qualcomm PMIC8XXX RTC"
> >> -	depends on MFD_PM8XXX
> >> +	depends on MFD_PM8XXX || MFD_SPMI_PMIC
> > 
> > There's currently no Kconfig symbol MFD_SPMI_PMIC in linux-next. I guess
> > it's currently queued somewhere. Is that correct?
> 
> The MFD driver which adds MFD_SPMI_PMIC symbol is still pending in the
> mailing list. I will ask Lee Jones to add it to the MFD queue for 3.18.

MFD_SPMI_PMIC has now been merged.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
