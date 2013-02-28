Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982Ab3B1SK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 13:10:29 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34038 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab3B1SK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 13:10:28 -0500
Message-ID: <512F9D90.7090705@wwwdotorg.org>
Date: Thu, 28 Feb 2013 11:10:24 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Venu Byravarasu <vbyravarasu@nvidia.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: host: tegra: Reset Tegra USB controller before init
References: <Pine.LNX.4.44L0.1302281003340.1352-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1302281003340.1352-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 08:09 AM, Alan Stern wrote:
> On Thu, 28 Feb 2013, Venu Byravarasu wrote:
> 
>> To clear any configurations made by U-Boot on Tegra USB controller,
>> reset it before init in probe.
>>
>> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
>> ---
>> When U-Boot configures a Tegra USB controller in device mode and if the EHCI
>> driver of kernel tries to set it to HOST mode, message "irq 52: nobody cared"
>> appears and IRQ gets disabled.
>>
>> This issue was initially reported with: http://marc.info/?l=linux-tegra&m=136110175423601&w=2
>>
>> To avoid such issues, due to configurations made by U-Boot driver, reset the
>> Tegra USB controller, before configuring it by kernel.
> 
> Does the Tegra platform use shared interrupts?  If it does, what 
> happens if the IRQ is enabled and in use by another device before 
> ehci-tegra resets the USB controller?

I believe there's a dedicated interrupt just for each individual controller.
