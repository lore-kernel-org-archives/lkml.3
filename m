Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263AbaEGOZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:25:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42511 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932989AbaEGOZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:25:56 -0400
Date: Wed, 7 May 2014 10:25:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Maxime Ripard <maxime.ripard@free-electrons.com>
cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, <kishon@ti.com>,
        <hdegoede@redhat.com>, Boris Brezillon <boris@free-electrons.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <kevin.z.m.zh@gmail.com>,
        <sunny@allwinnertech.com>, <shuge@allwinnertech.com>,
        <zhuzhenhua@allwinnertech.com>, <linux-sunxi@googlegroups.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 4/7] usb: ehci-platform: add optional reset controller
 retrieval
In-Reply-To: <1399434623-20383-5-git-send-email-maxime.ripard@free-electrons.com>
Message-ID: <Pine.LNX.4.44L0.1405071020490.1325-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014, Maxime Ripard wrote:

> From: Boris BREZILLON <boris.brezillon@free-electrons.com>
> 
> On the Allwinner's A31 SoC the reset line connected to the EHCI IP has to
> be deasserted for the EHCI block to be usable.
> 
> Add support for an optional reset controller that will be deasserted on
> power off and asserted on power on.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Is this really a _reset_ line?  That is, when you assert the reset 
line, does it actually reset the EHCI controller, or does it merely 
leave the controller in a partially powered-down state?

The difference is important.  During suspend, the controller is
supposed to remember the state of the port connections as well as other
settings.  If it doesn't, the controller and all attached USB devices
will have to be reinitialized every time the controller resumes, which
will increase the latency.

Alan Stern

