Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab3GJIeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 04:34:15 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5675 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab3GJIeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 04:34:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 10 Jul 2013 01:35:07 -0700
Message-ID: <51DD1E85.1070906@nvidia.com>
Date: Wed, 10 Jul 2013 14:12:45 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Subject: Re: [PATCH V2 4/4] extcon: palmas: Option to disable ID/VBUS detection
 based on platform
References: <1373436959-32444-1-git-send-email-ldewangan@nvidia.com> <1373436959-32444-5-git-send-email-ldewangan@nvidia.com> <51DD0578.6090804@samsung.com> <51DD09B7.50604@nvidia.com> <51DD0E9F.1030305@samsung.com>
In-Reply-To: <51DD0E9F.1030305@samsung.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 July 2013 01:04 PM, Chanwoo Choi wrote:
> On 07/10/2013 04:13 PM, Laxman Dewangan wrote:
>> On Wednesday 10 July 2013 12:25 PM, Chanwoo Choi wrote:
>> I did not like to break the TI design/code and hence added the option such that if there is no initialisation of this member or dts entry then assume it as the cable detection is enabled. Hence it need explicitly entry for disable the cable type detction. This is what for platform data structure.
>>
>> On other structure, I use as other way to use in rest of code to make logic as
>>
>> if (palmas_usb->enable_id_detction)
>>     xxx.
>>
>> rathar than
>>
>> if (!palmas_usb->disable_id_detction)
>>     xxx.
>>
>>
>> On rest of code, do now wan to use the pdata.
> This patch store same meaning to two different variables which are included in different structure.
> If we try to change the state of vbus/id detection on runtime, we have to modify two variables.
> I think it isn't right.
>
> struct palmas_platform_data {
> 	....
> 	bool disable_vbus_detection;
> 	bool disable_id_detection;
> };
>
> struct palmas_usb {
> 	...
> 	bool enable_vbus_detection;
> 	bool enable_id_detection;
> };
>
> You could only use the variables in struct palmas_usb without variables in struct palmas_platform_data
> because extcon-palmas driver store only the pointer of 'struct palmas_usb' to dev->p->driver_data
> by using platform_set_drvdata().
>
> It is meaning to use 'struct palmas_usb' on other function except for palmas_usb_probe() in extcon-palmas.c.
>
>
> if (node && !pdata) {
> 	...
> 	palmas_usb->wakeup = of_property_red_bool(node, "ti,wakeup);
> 	palmas_usb->enable_vbus_detection = of_property_red_bool(node, "ti,enable_vbus_detection);
> 	palmas_usb->enable_id_detection = of_property_red_bool(node, "ti,enable_id_detection);
> } else (!pdata) {
> 	palmas_usb->wakeup = true;
> 	palmas_usb->enable_vbus_detection = true;
> 	palmas_usb->enable_id_detection = true;
> }
>

Thanks for detail explanation.

I agree with you on this code. This code support the option if driver is 
invoked from DT and assume true always if it is from board file.

As all Tegra platforms have been moved to the DTS, I do not see any 
issue on this change.

I will post  the new version of this change (patch 4/4) as all others 
are already merged.

