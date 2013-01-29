Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab3A2PWC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:22:02 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36644 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756633Ab3A2PV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:21:59 -0500
Date: Tue, 29 Jan 2013 10:21:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vivek Gautam <gautam.vivek@samsung.com>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <jg1.han@samsung.com>, Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH] usb: ehci: s5p: Power-off VBUS during suspend.
In-Reply-To: <1359456765-7335-1-git-send-email-gautam.vivek@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1301291017360.1507-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2013, Vivek Gautam wrote:

> This change de-asserts vbus_gpio on suspend and
> re-asserts on resume in order to save power.
> NOTE, this change means no USB charging in suspend
> mode.

Doing this would mean USB devices could not wake up the system.  This 
would be unacceptable.

However, turning off VBUS power is okay provided:

	no root-hub ports are enabled, and

	the root hub is not enabled for wakeup.

Under those circumstances there can't be any wakeup-enabled USB devices 
on the bus, and the root hub itself would not need to detect new 
connections and disconnections.

Alan Stern

