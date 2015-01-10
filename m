Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbbAJNyi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 08:54:38 -0500
Received: from lucky1.263xmail.com ([211.157.147.130]:36036 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbbAJNyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 08:54:36 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: lyz@rock-chips.com
X-FST-TO: paul.zimmerman@synopsys.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: lyz@rock-chips.com
X-UNIQUE-TAG: <351bdcf541e8ec1de8f710f1ec393cc5>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <54B12F10.6050903@rock-chips.com>
Date: Sat, 10 Jan 2015 21:54:24 +0800
From: Yunzhi Li <lyz@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        "Dinh Nguyen (dinguyen@opensource.altera.com)" 
	<dinguyen@opensource.altera.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "jwerner@chromium.org" <jwerner@chromium.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        "zyw@rock-chips.com" <zyw@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "linux-rockchip@lists.infradead.org" 
	<linux-rockchip@lists.infradead.org>
Subject: Re: [PATCH v7 3/5] usb: dwc2: add generic PHY framework support for
 dwc2 usb controler platform driver.
References: <1418396413-27937-1-git-send-email-lyz@rock-chips.com> <1418396972-32686-1-git-send-email-lyz@rock-chips.com> <A2CA0424C0A6F04399FB9E1CD98E03048450635E@US01WEMBX2.internal.synopsys.com>
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E03048450635E@US01WEMBX2.internal.synopsys.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul:

On 2015/1/9 10:15, Paul Zimmerman wrote:
>>   	/*
>> -	 * Attempt to find a generic PHY, then look for an old style
>> -	 * USB PHY, finally fall back to pdata
>> +	 * If platform probe couldn't find a generic PHY or an old style
>> +	 * USB PHY, fall back to pdata
>>   	 */
>> -	phy = devm_phy_get(dev, "usb2-phy");
>> -	if (IS_ERR(phy)) {
>> -		uphy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
>> -		if (IS_ERR(uphy)) {
>> -			/* Fallback for pdata */
>> -			plat = dev_get_platdata(dev);
>> -			if (!plat) {
>> -				dev_err(dev,
>> -				"no platform data or transceiver defined\n");
>> -				return -EPROBE_DEFER;
>> -			}
>> -			hsotg->plat = plat;
>> -		} else
>> -			hsotg->uphy = uphy;
>> -	} else {
>> -		hsotg->phy = phy;
>> +	if (IS_ERR_OR_NULL(hsotg->phy) && IS_ERR_OR_NULL(hsotg->uphy)) {
>> +		plat = dev_get_platdata(dev);
>> +		if (!plat) {
>> +			dev_err(dev,
>> +			"no platform data or transceiver defined\n");
>> +			return -EPROBE_DEFER;
> Hi Yunzhi,
>
> Testing Felipe's testing/next branch on an Altera SOCFPGA platform,
> the driver never loads because it always returns -EPROBE_DEFER here.
> Apparently the SOCFPGA platform does not have any platform data
> defined, because dev_get_platdata() always returns NULL.
>
> If I remove the -EPROBE_DEFER return and have it continue on, the
> driver works. Reverting the patch also makes it work.
>
> I am testing with the driver built-in. I haven't tried it as a module
> yet.
>
> Any ideas? Is the -EPROBE_DEFER return really needed here?
>
     Yeah, I agree -EPROBE_DEFER is no need here, because the phy driver 
is optional, it shouldn't
break the usb controller driver probe procedure. I will fix it then 
resend this patch. Thank you
for testing .

