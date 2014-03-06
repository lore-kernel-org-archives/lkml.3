Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaCFQgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 11:36:37 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:45714 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaCFQgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 11:36:36 -0500
Message-ID: <5318A3C8.2020903@mm-sol.com>
Date: Thu, 06 Mar 2014 18:35:20 +0200
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Felipe Balbi <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v5 10/14] usb: phy: msm: Use reset framework for LINK
 and PHY resets
References: <1394014430-26485-1-git-send-email-iivanov@mm-sol.com> <1394014430-26485-11-git-send-email-iivanov@mm-sol.com> <531719C2.3070708@cogentembedded.com>
In-Reply-To: <531719C2.3070708@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/05/14 14:34, Sergei Shtylyov wrote:
> Hello.
> 

>> --- a/drivers/usb/phy/phy-msm-usb.c
>> +++ b/drivers/usb/phy/phy-msm-usb.c
> [...]
>> @@ -235,12 +236,16 @@ static void ulpi_init(struct msm_otg *motg)
>>
>>   static int msm_otg_link_clk_reset(struct msm_otg *motg, bool assert)
>>   {
>> -    int ret = 0;
>> +    int ret;
>>
>> -    if (!motg->pdata->link_clk_reset)
>> -        return ret;
>> +    if (motg->pdata->link_clk_reset)
>> +        ret = motg->pdata->link_clk_reset(motg->clk, assert);
>> +    else
>> +        if (assert)
> 
>    Kernel style assumes:
> 
>     else if (assert)

Thanks. will fix it.

Regards,
Ivan

> 
>> +            ret = reset_control_assert(motg->link_rst);
>> +        else
>> +            ret = reset_control_deassert(motg->link_rst);
>>
> [...]
> 
> WBR, Sergei
> 
>
