Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaIYHAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:00:39 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:24224 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaIYHAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:00:38 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-d5-5423bd93d59c
Message-id: <1411628434.16755.3.camel@AMDC1943>
Subject: Re: linux-next: build warning after merge of the battery tree
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sebastian Reichel <sre@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Date: Thu, 25 Sep 2014 09:00:34 +0200
In-reply-to: <20140925142206.5ebea1eb@canb.auug.org.au>
References: <20140925142206.5ebea1eb@canb.auug.org.au>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t/xq7qT9yqHGDzcqmhx/+tRRovLu+aw
	WRxc2MZosXXvVXaL07tLHFg9Gm/cYPPYtKqTzePOtT1sHp83yQWwRHHZpKTmZJalFunbJXBl
	zHt1nLngGmfF5f4VzA2Mczm6GDk5JARMJE7O/ssKYYtJXLi3ng3EFhJYyigx8Sl/FyMXkP2Z
	UeL9rtNMIAleAX2JFaensHcxcnAIC7hJLN0UDBJmEzCW2Lx8CRtIWERAW+LAbwGQVmaBFkaJ
	mdcPMYLUsAioSlz52MMCYnMKmEt829vLBLHLTKJ351Uwm1lAXWLSvEXMIHMkBJQlGvvdILYK
	SvyYfI8FokReYvOat8wTGAVmIemYhaRsFpKyBYzMqxhFU0uTC4qT0nON9IoTc4tL89L1kvNz
	NzFCAvjrDsalx6wOMQpwMCrx8Hr4K4cIsSaWFVfmHmKU4GBWEuHdthUoxJuSWFmVWpQfX1Sa
	k1p8iJGJg1OqgfGEV1X/+x/aRTauEeHrmufb/q97/+iokjob475+v32vbihctmyM7uhwnqOh
	zbqtuZwh/Zsv07yfYU07os4pGjgfux8iuPGk8mO99zucluzxkj6r0djJ7CnwNqJbc3ZshfrT
	6Icn5jyTkrL3WvenuE3E9efklVKLF0t3uRTf+1rAd2LrP5OXXkosxRmJhlrMRcWJAFOFJaU+	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-09-25 at 14:22 +1000, Stephen Rothwell wrote:
> Hi Sebastian,
> 
> After merging the battery tree, today's linux-next build (powerpc
> ppc64_defconfig and x86_64 allmodconfig) produced this warning:
> 
> fs/sysfs/Kconfig:1:error: recursive dependency detected!
> fs/sysfs/Kconfig:1:	symbol SYSFS is selected by CHARGER_MAX14577
> drivers/power/Kconfig:327:	symbol CHARGER_MAX14577 depends on POWER_SUPPLY
> drivers/power/Kconfig:1:	symbol POWER_SUPPLY is selected by HID_SONY
> drivers/hid/Kconfig:649:	symbol HID_SONY depends on NEW_LEDS
> drivers/leds/Kconfig:8:	symbol NEW_LEDS is selected by SENSORS_APPLESMC
> drivers/hwmon/Kconfig:299:	symbol SENSORS_APPLESMC depends on HWMON
> drivers/hwmon/Kconfig:5:	symbol HWMON is selected by EEEPC_LAPTOP
> drivers/platform/x86/Kconfig:496:	symbol EEEPC_LAPTOP depends on HOTPLUG_PCI
> drivers/pci/hotplug/Kconfig:5:	symbol HOTPLUG_PCI depends on SYSFS
> 
> Caused by commit e30110e9c96f ("charger: max14577: Configure
> battery-dependent settings from DTS and sysfs").  Consider depending on
> SYSFS instead of selecting it ... or maybe making your driver work even
> without it.

I'll send a patch changing to "depends on".

Best regards,
Krzysztof

