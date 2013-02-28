Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab3B1PJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:09:53 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:38751 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932475Ab3B1PJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 10:09:48 -0500
Date: Thu, 28 Feb 2013 10:09:47 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Venu Byravarasu <vbyravarasu@nvidia.com>
cc: gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <swarren@wwwdotorg.org>
Subject: Re: [PATCH] usb: host: tegra: Reset Tegra USB controller before init
In-Reply-To: <1362033418-7332-1-git-send-email-vbyravarasu@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1302281003340.1352-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2013, Venu Byravarasu wrote:

> To clear any configurations made by U-Boot on Tegra USB controller,
> reset it before init in probe.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
> When U-Boot configures a Tegra USB controller in device mode and if the EHCI
> driver of kernel tries to set it to HOST mode, message "irq 52: nobody cared"
> appears and IRQ gets disabled.
> 
> This issue was initially reported with: http://marc.info/?l=linux-tegra&m=136110175423601&w=2
> 
> To avoid such issues, due to configurations made by U-Boot driver, reset the
> Tegra USB controller, before configuring it by kernel.

Does the Tegra platform use shared interrupts?  If it does, what 
happens if the IRQ is enabled and in use by another device before 
ehci-tegra resets the USB controller?

Does the unwanted interrupt occur only when the controller is switched
to host mode?  If not, it seems to me this reset belongs in the
platform code, not in the glue layer.  If yes, the reset belongs
somewher before the controller is switched -- where does that occur?

Alan Stern

