Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab3LMG13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 01:27:29 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14566 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab3LMG11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 01:27:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 Dec 2013 22:30:02 -0800
Message-ID: <52AAA80A.7010905@nvidia.com>
Date: Fri, 13 Dec 2013 11:54:10 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: tegra: enable ams AS3722 drivers
References: <1386855064-10993-1-git-send-email-ldewangan@nvidia.com> <52AA2891.2020502@wwwdotorg.org> <52AA2FD1.3020000@wwwdotorg.org>
In-Reply-To: <52AA2FD1.3020000@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 December 2013 03:21 AM, Stephen Warren wrote:
> On 12/12/2013 02:20 PM, Stephen Warren wrote:
>> On 12/12/2013 06:31 AM, Laxman Dewangan wrote:
>>> ams AS3722 is the system power manager module IC for the Tegra124 based
>>> Venice2 platform. Enable configs for gpio, pincontrol, rtc, regulator
>>> support from this device.
>> I've squashed patch 1/2 into Tegra's for-3.14/defconfig branch.
>>
>> I've applied patch 2/2 to Tegra's for-3.14/dt branch.
> Actually, I'm dropping patch 2/2 since it causes a whole bunch of error
> spew during boot:
>
>> [    0.628315] tegra124-pinctrl 70000868.pinmux: invalid group "dap2_dout_pp2" for function "rsvd4"
>> [    0.635309] tegra124-pinctrl 70000868.pinmux: does not have pin group dap2_dout_pp2
>> [    0.642999] tegra124-pinctrl 70000868.pinmux: could not map group config for "dap2_dout_pp2"
>> [    0.731176] as3722-pinctrl as3722-pinctrl: pin gpio0 already requested by as3722-pinctrl; cannot claim for as3722-regulator
>> [    0.742312] as3722-pinctrl as3722-pinctrl: pin-0 (as3722-regulator) status -22
>> [    0.749526] as3722-pinctrl as3722-pinctrl: could not request pin 0 (gpio0) from group gpio0  on device as3722-pinctrl
>> [    0.760133] as3722-regulator as3722-regulator: Error applying setting, reverse things back
>> [    0.835838] as3722-regulator as3722-regulator: Failed to find supply vin-ldo1-6
>> [    0.843312] as3722-regulator as3722-regulator: regulator 8 register failed -517
>> [    0.852263] platform as3722-regulator: Driver as3722-regulator requests probe deferral
>> [    0.984920] as3722-pinctrl as3722-pinctrl: pin gpio0 already requested by as3722-pinctrl; cannot claim for as3722-rtc
>> [    0.995537] as3722-pinctrl as3722-pinctrl: pin-0 (as3722-rtc) status -22
>> [    1.002244] as3722-pinctrl as3722-pinctrl: could not request pin 0 (gpio0) from group gpio0  on device as3722-pinctrl
>> [    1.012848] as3722-rtc as3722-rtc: Error applying setting, reverse things back

I did not observe this issue in my log, probably overlooked.
I will repro this and fix/update the issue/patch.

Thanks,
laxman

