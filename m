Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab3LLVvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 16:51:19 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54295 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab3LLVvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 16:51:17 -0500
Message-ID: <52AA2FD1.3020000@wwwdotorg.org>
Date: Thu, 12 Dec 2013 14:51:13 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: thierry.reding@gmail.com, rob.herring@calxeda.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: tegra: enable ams AS3722 drivers
References: <1386855064-10993-1-git-send-email-ldewangan@nvidia.com> <52AA2891.2020502@wwwdotorg.org>
In-Reply-To: <52AA2891.2020502@wwwdotorg.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 02:20 PM, Stephen Warren wrote:
> On 12/12/2013 06:31 AM, Laxman Dewangan wrote:
>> ams AS3722 is the system power manager module IC for the Tegra124 based
>> Venice2 platform. Enable configs for gpio, pincontrol, rtc, regulator
>> support from this device.
> 
> I've squashed patch 1/2 into Tegra's for-3.14/defconfig branch.
> 
> I've applied patch 2/2 to Tegra's for-3.14/dt branch.

Actually, I'm dropping patch 2/2 since it causes a whole bunch of error
spew during boot:

> [    0.628315] tegra124-pinctrl 70000868.pinmux: invalid group "dap2_dout_pp2" for function "rsvd4"
> [    0.635309] tegra124-pinctrl 70000868.pinmux: does not have pin group dap2_dout_pp2
> [    0.642999] tegra124-pinctrl 70000868.pinmux: could not map group config for "dap2_dout_pp2"

> [    0.731176] as3722-pinctrl as3722-pinctrl: pin gpio0 already requested by as3722-pinctrl; cannot claim for as3722-regulator
> [    0.742312] as3722-pinctrl as3722-pinctrl: pin-0 (as3722-regulator) status -22
> [    0.749526] as3722-pinctrl as3722-pinctrl: could not request pin 0 (gpio0) from group gpio0  on device as3722-pinctrl
> [    0.760133] as3722-regulator as3722-regulator: Error applying setting, reverse things back

> [    0.835838] as3722-regulator as3722-regulator: Failed to find supply vin-ldo1-6
> [    0.843312] as3722-regulator as3722-regulator: regulator 8 register failed -517
> [    0.852263] platform as3722-regulator: Driver as3722-regulator requests probe deferral

> [    0.984920] as3722-pinctrl as3722-pinctrl: pin gpio0 already requested by as3722-pinctrl; cannot claim for as3722-rtc
> [    0.995537] as3722-pinctrl as3722-pinctrl: pin-0 (as3722-rtc) status -22
> [    1.002244] as3722-pinctrl as3722-pinctrl: could not request pin 0 (gpio0) from group gpio0  on device as3722-pinctrl
> [    1.012848] as3722-rtc as3722-rtc: Error applying setting, reverse things back

