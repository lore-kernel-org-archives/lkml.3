Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaIWJ4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 05:56:10 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:51371 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424AbaIWJ4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 05:56:08 -0400
Message-ID: <542143B2.1090707@mm-sol.com>
Date: Tue, 23 Sep 2014 12:56:02 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Lee Jones <lee.jones@linaro.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [PATCH] rtc: pm8xxx: rework to support pm8941 rtc
References: <1410515044-31689-1-git-send-email-svarbanov@mm-sol.com> <1411462245.20236.17.camel@x220>
In-Reply-To: <1411462245.20236.17.camel@x220>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 09/23/2014 11:50 AM, Paul Bolle wrote:
> Hi Stanimar,
> 
> On Fri, 2014-09-12 at 12:44 +0300, Stanimir Varbanov wrote:
>> Adds support for RTC device inside PM8941 PMIC. The RTC
>> in this PMIC have two register spaces. Thus the rtc-pm8xxx
>> is slightly reworked to reflect these differences.
>>
>> The register set for different PMIC chips are selected
>> on DT compatible string base.
>>
>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> 
> This patch just landed in next-20140923 as commit 99abd227988a
> ("drivers/rtc/rtc-pm8xxx.c: rework to support pm8941 rtc").
> 
>> --- a/drivers/rtc/Kconfig
>> +++ b/drivers/rtc/Kconfig
>> @@ -1283,7 +1283,7 @@ config RTC_DRV_LPC32XX
>>  
>>  config RTC_DRV_PM8XXX
>>  	tristate "Qualcomm PMIC8XXX RTC"
>> -	depends on MFD_PM8XXX
>> +	depends on MFD_PM8XXX || MFD_SPMI_PMIC
> 
> There's currently no Kconfig symbol MFD_SPMI_PMIC in linux-next. I guess
> it's currently queued somewhere. Is that correct?

The MFD driver which adds MFD_SPMI_PMIC symbol is still pending in the
mailing list. I will ask Lee Jones to add it to the MFD queue for 3.18.

-- 
regards,
Stan
