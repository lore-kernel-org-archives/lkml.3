Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414Ab3LEFoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 00:44:21 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:54427 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab3LEFoT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 00:44:19 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 1/2] usb: chipidea: fix mistake in device tree binding of nspire-usb to use vendor name 'lsi' instead of SoC name 'zevio'
From: Daniel Tang <dt.tangr@gmail.com>
In-Reply-To: <20131204134433.GD1573@shlinux1.ap.freescale.net>
Date: Thu, 5 Dec 2013 16:44:13 +1100
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <38AC4BA3-DE10-47A6-B3EF-26872A88AABD@gmail.com>
References: <1386148808-15065-1-git-send-email-dt.tangr@gmail.com> <20131204134433.GD1573@shlinux1.ap.freescale.net>
To: Peter Chen <Peter.Chen@freescale.com>
X-Mailer: Apple Mail (2.1510)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/12/2013, at 12:44 AM, Peter Chen <Peter.Chen@freescale.com> wrote:

> 
> lsi is vendor name, what are zevio and nspire?
> Usually, the compatible string should be "vendor_name,soc_name-module_name"
> 

Because this port uses documentation from reverse engineering, it's difficult to work out what is SoC specific and what is device specific. The SoC is Zevio but the driver is written for the TI-Nspire.

If it's usually "vendor_name,soc_name-module_name", I'll fix up this patch with zevio instead of nspire (and it'll be more consistent with the other drivers).

>> - reg: Should contain registers location and length
>> - interrupts: Should contain controller interrupt
>> 
>> @@ -11,7 +11,7 @@ Recommended properies:
>> Examples:
>> 		usb0: usb@B0000000 {
>> 			reg = <0xB0000000 0x1000>;
>> -			compatible = "zevio,nspire-usb";
>> +			compatible = "lsi,nspire-usb";
>> 			interrupts = <8>;
>> 			vbus-supply = <&vbus_reg>;
>> 		};
>> diff --git a/drivers/usb/chipidea/ci_hdrc_nspire.c b/drivers/usb/chipidea/ci_hdrc_nspire.c
>> index 517ce41..c5c2dde 100644
>> --- a/drivers/usb/chipidea/ci_hdrc_nspire.c
>> +++ b/drivers/usb/chipidea/ci_hdrc_nspire.c
>> @@ -52,7 +52,7 @@ static int ci_hdrc_nspire_remove(struct platform_device *pdev)
>> }
>> 
>> static const struct of_device_id ci_hdrc_nspire_dt_ids[] = {
>> -	{ .compatible = "zevio,nspire-usb", },
>> +	{ .compatible = "lsi,nspire-usb", },
>> 	{ /* sentinel */ }
>> };
>> 
>> -- 
>> 1.7.10.4
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
> 
> -- 
> 
> Best Regards,
> Peter Chen
> 

Cheers,
Daniel Tang