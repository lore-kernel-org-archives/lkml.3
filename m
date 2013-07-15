Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab3GOR3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:29:49 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7012 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab3GOR3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:29:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 15 Jul 2013 10:28:59 -0700
Message-ID: <51E43189.5050805@nvidia.com>
Date: Mon, 15 Jul 2013 13:29:45 -0400
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] ARM: tegra: enable palmas device for dalmore
References: <1373441852-27176-1-git-send-email-ldewangan@nvidia.com> <51E427D6.7090702@wwwdotorg.org> <51E43129.7080602@nvidia.com>
In-Reply-To: <51E43129.7080602@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/15/2013 1:28 PM, Laxman Dewangan wrote:
> On Monday 15 July 2013 10:18 PM, Stephen Warren wrote:
>> On 07/10/2013 01:37 AM, Laxman Dewangan wrote:
>>> Make the entry of Dalmore Power Management Unit device TPS65913
>>> in dalmore DTS file. The Palma driver support this device.
>>>
>>> Enable following submodule of the TPS65913:
>>> - GPIO driver
>>> - RTC driver.
>>> - Power regulator driver.
>> If I apply this, (at least) the SD card no longer works. I assume the
>> regulator for it is being turned off somehow.
> 
> As per downstream power tree, smps9 is feeding power to sd slot and I 
> make this rail as always ON. So there should not be any issue.
> 
> Rhyland,
> Do you see any differences on this power tree with your power tree with 
> DT? There was discussion sometime ago on the sdcard. Am I missing 
> anything here?
> 
> Thanks,
> Laxman
> 


I noticed a couple differences between this and what we are using...

Yours:
+			    ldo8-in-supply = <&tps65090_dcdc3_reg>;
+			    ldo9-in-supply = <&palmas_smps9_reg>;
Ours:
                            ldo8-in-supply = <&tps65090_dcdc2_reg>;
                            ldo9-in-supply = <&tps65090_dcdc2_reg>;

We also specify supplies (floating) for smps6 and smps10.  I don't think
that matters though.

Also we have the vmmc-supply and sd-slot-supply propeties set for the sd
card slot, like so:

                vmmc-supply = <&palmas_smps3_reg>;
                sd-slot-supply = <&palmas_smps9_reg>;

Also, we have the interrupt trigger mode different for the palmas:

Yours:
+			interrupts = <0 86 0x4>;
Ours:
                        interrupts = <0 86 0x8>;


I think other than that they should be the same.

-Rhyland

-- 
nvpublic
