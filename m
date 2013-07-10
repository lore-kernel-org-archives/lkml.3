Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab3GJHF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 03:05:27 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2166 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab3GJHF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 03:05:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 10 Jul 2013 00:04:50 -0700
Message-ID: <51DD09B7.50604@nvidia.com>
Date: Wed, 10 Jul 2013 12:43:59 +0530
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
References: <1373436959-32444-1-git-send-email-ldewangan@nvidia.com> <1373436959-32444-5-git-send-email-ldewangan@nvidia.com> <51DD0578.6090804@samsung.com>
In-Reply-To: <51DD0578.6090804@samsung.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 July 2013 12:25 PM, Chanwoo Choi wrote:
> Hi Laxman,
>
> On 07/10/2013 03:15 PM, Laxman Dewangan wrote:
>> Should you define duplicate meaning variables in each other structure?
>> - disable_vbus_detection - enable_vbus_detection
>> - disable_id_detection - enable_id_detection
>>
>> I think that it isn' efficient code. I'd like you to simplify this patch
>> by using only one variable instead of duplicate meaning variables.

Originally this patch came form TI and not sure that they are using the 
both cable detection or only single type.
For Nvidia Tegra platform, on some design, we are using only ID 
detection and hence this option get added.

I did not like to break the TI design/code and hence added the option 
such that if there is no initialisation of this member or dts entry then 
assume it as the cable detection is enabled. Hence it need explicitly 
entry for disable the cable type detction. This is what for platform 
data structure.

On other structure, I use as other way to use in rest of code to make 
logic as

if (palmas_usb->enable_id_detction)
    xxx.

rathar than

if (!palmas_usb->disable_id_detction)
    xxx.


On rest of code, do now wan to use the pdata.

