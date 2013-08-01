Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab3HAPPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 11:15:53 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12695 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab3HAPPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 11:15:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 01 Aug 2013 08:15:51 -0700
Message-ID: <51FA7BA4.8010301@nvidia.com>
Date: Thu, 1 Aug 2013 18:15:48 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: DTS: tegra: Add USB entries for Tegra30
References: <1375292543-7896-1-git-send-email-ttynkkynen@nvidia.com> <1375292543-7896-2-git-send-email-ttynkkynen@nvidia.com> <51F98C27.40904@wwwdotorg.org>
In-Reply-To: <51F98C27.40904@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 01:13 AM, Stephen Warren wrote:
> On 07/31/2013 11:42 AM, Tuomas Tynkkynen wrote:
>> Add device tree entries for the 3 USB controllers and PHYs and
>> enable the third controller on Cardhu and Beaver boards.
>>
>> Fix VBUS regulator entries on Beaver. The GPIO pins were wrong.
> 
> That much is correct.
> 
>> Also, a third GPIO is required to power the pullup resistors that drive
>> the VBUS voltage switches, so add an regulator entry for that.
> 
> That is not true. GMI_AD13 / PH5 / 61 is a signal that pulls up all of
> USB1 VBUS, USB3 VBUS, and GMI_AD15, which as far as I can tell is
> entirely unrelated to USB in any way.

I sent a v2 that enables the internal pullups on those pins.

> This part of the change should be removed. I know you mentioned that
> downstream does this, but that means very little; there are many
> mistakes there.

It looks like the pullup resistor from PH5 to GMI_AD15 was added in a later board revision,
so the HW guys are to blame this time.
