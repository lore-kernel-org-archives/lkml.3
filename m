Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbaLVQGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:06:23 -0500
Received: from netrider.rowland.org ([192.131.102.5]:34128 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754588AbaLVQGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:06:22 -0500
Date: Mon, 22 Dec 2014 11:06:20 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Wu Liang feng <wulf@rock-chips.com>
cc: heiko@sntech.de, <huangtao@rock-chips.com>, <kever.yang@rock-chips.com>,
        <eddie.cai@rock-chips.com>, <roy.li@rock-chips.com>,
        <zyw@rock-chips.com>, <jwerner@google.com>, <dianders@google.com>,
        <posciak@google.com>, <tfiga@google.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 2/2] USB: ehci-platform: Support ehci reset after resume
 quirk
In-Reply-To: <1419244588-5227-3-git-send-email-wulf@rock-chips.com>
Message-ID: <Pine.LNX.4.44L0.1412221101540.23710-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2014, Wu Liang feng wrote:

> The EHCI controller doesn't properly detect the case when

"The" EHCI controller?  I don't know what EHCI controller you're 
talking about, but my controllers don't have any trouble detecting 
device removal during suspend.

> a device is removed during suspend. Specifically,when we
> resume from suspend the EHCI controller maintaining the
> USB state (FLAG_CF is 1 Current Connect Status is 1) but
> a USB device (like a USB camera on rk3288) may have been
> disconnected actually.
> 
> Let's add a quirk to force ehci to go into the
> usb_root_hub_lost_power() path and reset after resume.
> This should generally reset the whole controller and all
> ports and initialize everything cleanly again, and bring
> the devices back up.

Isn't this solution too extreme?  What if the device was a flash 
storage drive and it wasn't unplugged during suspend?  This patch would 
force it to be removed, messing up any mounted filesystems, when there 
was no need.

Can you find a better way to work around the problem?

Alan Stern

