Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbaBBQKR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 11:10:17 -0500
Received: from netrider.rowland.org ([192.131.102.5]:43847 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751726AbaBBQKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 11:10:14 -0500
Date: Sun, 2 Feb 2014 11:10:13 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Zoran Markovic <zoran.markovic@linaro.org>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Xenia Ragiadakou <burzalodowa@gmail.com>,
        Julius Werner <jwerner@chromium.org>,
        Krzysztof Mazur <krzysiek@podlesie.net>,
        Matthias Beyer <mail@beyermatthias.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>
Subject: Re: [RFC PATCHv2] usb: move hub init and LED blink work to power
 efficient workqueue
In-Reply-To: <1391311006-4138-1-git-send-email-zoran.markovic@linaro.org>
Message-ID: <Pine.LNX.4.44L0.1402021108470.19760-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Feb 2014, Zoran Markovic wrote:

> From: Shaibal Dutta <shaibal.dutta@broadcom.com>
> 
> Allow the scheduler to select the best CPU to handle hub initalization
> and LED blinking work. This extends idle residency times on idle CPUs
> and conserves power.
> 
> This functionality is enabled when CONFIG_WQ_POWER_EFFICIENT is selected.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> Cc: Xenia Ragiadakou <burzalodowa@gmail.com>
> Cc: Julius Werner <jwerner@chromium.org>
> Cc: Krzysztof Mazur <krzysiek@podlesie.net>
> Cc: Matthias Beyer <mail@beyermatthias.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> Cc: Thomas Pugliese <thomas.pugliese@gmail.com>
> Signed-off-by: Shaibal Dutta <shaibal.dutta@broadcom.com>
> [zoran.markovic@linaro.org: Rebased to latest kernel. Added commit message.
> Changed reference from system to power efficient workqueue for LEDs in
> check_highspeed() and hub_port_connect_change().]
> Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>

Acked-off-by: Alan Stern <stern@rowland.harvard.edu>

Is there some reason why schedule_delayed_work() doesn't use the 
power-efficient work queue by default?

Alan Stern

