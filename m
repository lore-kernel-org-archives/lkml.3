Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab3GQRFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:05:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52944 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab3GQRFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:05:13 -0400
Message-ID: <51E6CEC5.7050402@wwwdotorg.org>
Date: Wed, 17 Jul 2013 11:05:09 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] Enable lm90 in Tegra30 and Tegra114.
References: <1373615364-18559-1-git-send-email-wni@nvidia.com> <51E427F1.9010106@wwwdotorg.org> <51E42DB0.8090006@wwwdotorg.org> <51E52B28.9090708@nvidia.com> <51E65309.6000101@nvidia.com>
In-Reply-To: <51E65309.6000101@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 02:17 AM, Wei Ni wrote:
> On 07/16/2013 07:14 PM, Wei Ni wrote:
>> On 07/16/2013 01:13 AM, Stephen Warren wrote:
>>> On 07/15/2013 10:48 AM, Stephen Warren wrote:
>>>> On 07/12/2013 01:49 AM, Wei Ni wrote:
>>>>> Enable thermal sensor lm90 for Tegra30 Cardhu and Tegra114 Dalmore.
>>>>
>>>> I have applied the series to Tegra's for-3.12/dt branch.
>>>
>>> Actually, I see the following on Dalmore (although Cardhu works):
>>>
>>> [   29.448539] lm90 0-004c: Register 0x4 read failed (-121)
>>> [   29.453930] lm90 0-004c: Failed to read convrate register!
>>> [   29.460034] lm90 0-004c: Register 0x3 read failed (-121)
>>> [   29.465408] lm90 0-004c: Initialization failed!
>>>
>>> So, there's something wrong here, and I've dropped the patch for
>>> Dalmore. Does this patch actually work for you?
>>>
>> I test it with the Chrome u-boot, the lm90 works fine.
>> But today, if I tried to use the uboot from
>> git://git.denx.de/u-boot-tegra.git, I can repo your errors, it seems the
>> i2c can't work, the lm90 driver read register failed.
>> I traced it, but can't find the root cause yet.
> 
> Hi, Stephen
> I found the root cause.
> In the Chrome u-boot, it will turn on the regulator for the lm90, but in
> the upstream u-boot, it didn't do it.

> I think this regulator should be handled in the kernel driver, but it
> seems the regulator palmas tps65913 didn't be supported on the dalmore yet.
> So may be we have to wait the palmas ready on dalmore.

Yes, I agree. (although Laxman's regulator patch caused the SD card to
stop working, so that needs to be fixed up, but hopefully it's a simple
issue).
