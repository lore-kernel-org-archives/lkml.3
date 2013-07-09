Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab3GIHta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:49:30 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3817 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab3GIHt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:49:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 09 Jul 2013 00:49:22 -0700
Message-ID: <51DBC058.2040904@nvidia.com>
Date: Tue, 9 Jul 2013 15:48:40 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Alex Courbot <acourbot@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [lm-sensors] [PATCH 1/2] ARM: dt: t30 cardhu: add dt entry for
 lm90
References: <1372928979-26938-1-git-send-email-wni@nvidia.com> <1372928979-26938-2-git-send-email-wni@nvidia.com> <51D70483.70203@wwwdotorg.org> <51DA6BD4.1040300@nvidia.com> <20130708095024.041a6d57@endymion.delvare> <51DA8805.50709@nvidia.com> <20130708131421.GB21638@roeck-us.net> <20130709062112.GC17499@mithrandir>
In-Reply-To: <20130709062112.GC17499@mithrandir>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 02:21 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Mon, Jul 08, 2013 at 06:14:21AM -0700, Guenter Roeck wrote:
>> On Mon, Jul 08, 2013 at 05:36:05PM +0800, Wei Ni wrote:
>>> On 07/08/2013 03:50 PM, Jean Delvare wrote:
>>>> On Mon, 8 Jul 2013 15:35:48 +0800, Wei Ni wrote:
>>>>> On 07/06/2013 01:38 AM, Stephen Warren wrote:
>>>>>> On 07/04/2013 03:09 AM, Wei Ni wrote:
>>>>>>> Enable thermal sensor lm90 for t30 cardhu.
>>>>>>
>>>>>>> diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
>>>>>>
>>>>>>> +		nct1008: nct1008 {
>>>>>>> +			compatible = "lm90,nct1008";
>>>>>>
>>>>>> "lm90" isn't a valid vendor prefix. I believe the value you want is
>>>>>> "onnn,nct1008". Same comment for patch 2/2.
>>>>>
>>>>> The lm90 doesn't support device tree very well.
>>>>
>>>> I doubt it, but if this is the case, then please fix it, instead of
>>>> working the problem around in a different place.
>>>>
>>>>> In the DT, we need to
>>>>> named as "lm90" so that the lm90 driver can be loaded,
>>>>
>>>> Not that I am an expert with regards to DT, but this doesn't make any
>>>> sense to me. AFAIK DT is about devices, not which drivers handle them.
>>>>
>>>>> and we also need
>>>>> to add "nct1008" to indicate this is the nct1008 device, so that the
>>>>> lm90 driver can be loaded with the right i2c_device_id->driver_data.
>>>>>
>>>>> I set the " compatible = "lm90,nct1008" ", this is the simplest way, and
>>>>> we doesn't need to change the lm90.c.
>>>>
>>>> There's no problem with changing the lm90 driver, if this is the right
>>>> thing to do.
>>>
>>> Ok, I will add DT support in the lm90.c in my next version patch.
>>>
>> Only if you can show that it is necessary.
> 
> It should work out of the box. As a matter of fact the same chip is used
> on Tamonten and the DTS files use "onnn,nct1008". That used to work. If
> it no longer does then that's a regression.

I synced the linux-next from:
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
and use the tag v3.10-rc7, but in the lm90.c it doesn't have DT support,
such as "onnn,nct1008".
I googled it and found there has patch:
[PATCH] hwmon: (lm90) Add device tree support , which is in:
http://lists.lm-sensors.org/pipermail/lm-sensors/2013-February/038099.html
, but it didn't be merged into the linux-next.

which git repository and branch should I use ?

Thanks.
Wei.

> 
> Thierry
> 
> * Unknown Key
> * 0x7F3EB3A1
> 

