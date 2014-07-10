Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaGJODG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:03:06 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15065 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaGJODE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:03:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 10 Jul 2014 06:52:09 -0700
Message-ID: <53BE9D13.6000102@nvidia.com>
Date: Thu, 10 Jul 2014 17:02:59 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "balbi@ti.com" <balbi@ti.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] USB: PHY: tegra: Call tegra_usb_phy_close only
 on device removal
References: <1404436179-10745-1-git-send-email-ttynkkynen@nvidia.com> <1404436179-10745-5-git-send-email-ttynkkynen@nvidia.com> <20140710134859.GM15340@saruman.home>
In-Reply-To: <20140710134859.GM15340@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/07/14 16:48, Felipe Balbi wrote:
> * PGP Signed by an unknown key
>
> Hi,
>
> On Fri, Jul 04, 2014 at 04:09:39AM +0300, Tuomas Tynkkynen wrote:
>> tegra_usb_phy_close() is supposed to undo the effects of
>> tegra_usb_phy_init(). It is also currently added as the USB PHY shutdown
>> callback, which is wrong, since tegra_usb_phy_init() is only called
>
> you could just make tegra_usb_phy_init() be called as u_phy->init().

Apart from enabling pll_u and vbus, that function mostly fetches clocks 
etc. from the device tree and as such should preferably fail the probe() 
and not when the EHCI driver enables the PHY. (Renaming it would 
probably be a good idea.)

> That way you even delay enabling clocks and regulators to the point
> where they are more likely to be needed. Also, if EHCI is never loaded,
> you won't power up the PHY for no reason.
>

That's true, but due to the above that'd be a bigger refactoring.

>> during probing wheras the shutdown callback can get called multiple
>> times. This then leads to warnings about unbalanced regulator_disable if
>> the EHCI driver is unbound and bound again at runtime.
>>
>> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
>
> I suppose this has no dependencies with the rest of the series ?
>

No. But Greg apparently applied these to his tree earlier today.

Thanks,
Tuomas.

-- 
nvpublic
