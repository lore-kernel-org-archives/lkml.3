Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab3FAOj5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 10:39:57 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:42098 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab3FAOjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 10:39:49 -0400
Message-ID: <51AA07B7.4020901@cogentembedded.com>
Date: Sat, 01 Jun 2013 18:39:51 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "B, Ravi" <ravibabu@ti.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: Re: [PATCH v1 8/9] usb: phy: dts: Adding usbphy DT bindings for am33xx
References: <1369288888-8614-1-git-send-email-ravibabu@ti.com> <1369288888-8614-9-git-send-email-ravibabu@ti.com> <519E275A.5020200@cogentembedded.com> <6C6B28D4DC342643927BEAFCE8707BF63EAE3EBF@DBDE04.ent.ti.com> <519E5D58.5020002@cogentembedded.com> <6C6B28D4DC342643927BEAFCE8707BF63EAE52A3@DBDE04.ent.ti.com>
In-Reply-To: <6C6B28D4DC342643927BEAFCE8707BF63EAE52A3@DBDE04.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 24-05-2013 9:34, B, Ravi wrote:

>>>> +		phy1: usbphy-gs70@44e10620 {
>>>> +			compatible = "ti,dsps-usbphy";
>>>> +			reg = <0x44e10620 0x8
>>>> +			       0x44e10648 0x4>;
>>>> +			reg-names = "phy_ctrl","phy_wkup";
>>>> +			id = <0>;
>>>> +		};
>>>> +
>>>> +		phy2: usbphy-gs70@44e10628 {
>>>> +			compatible = "ti,dsps-usbphy";
>>>> +			reg = <0x44e10628 0x8
>>>> +			       0x44e10648 0x4>;
>>> The second register conflicts with phy1.

>> The two instances of phy uses common phy wakeup register.

>>>      That's why there is a resource conflict. Have you actually tried to instantiate the devices out of such tree?
>>> This register should be declared somewhere above the PHYs I think...

> I did not face any problem with this, I have tested both instances of phy used by dual instance controller, worked fine.

    How your /proc/iomem looks like with that?

> What do you suggest, in case of common register which both phy have to use this for wakeup functionality.
> The DT should support this.  What do you suggest in such case?

    I'd probably have to create a third device for this shared register...

> --
> Ravi B

WBR, Sergei


