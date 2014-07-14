Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbaGNO7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:59:05 -0400
Received: from netrider.rowland.org ([192.131.102.5]:58471 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755940AbaGNO6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:58:55 -0400
Date: Mon, 14 Jul 2014 10:58:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Lee Jones <lee.jones@linaro.org>
cc: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <maxime.coquelin@st.com>, <patrice.chotard@st.com>,
        <gregkh@linuxfoundation.org>, <srinivas.kandagatla@gmail.com>,
        USB list <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/3] usb: host: st-hcd: Add USB HCD support for STi SoCs
In-Reply-To: <20140714083549.GK2954@lee--X1>
Message-ID: <Pine.LNX.4.44L0.1407141054010.10763-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014, Lee Jones wrote:

> On Fri, 11 Jul 2014, Alan Stern wrote:
> > On Fri, 11 Jul 2014, Peter Griffin wrote:
> > > On Thu, 10 Jul 2014, Alan Stern wrote:
> > > 
> > > > On Thu, 10 Jul 2014, Peter Griffin wrote:
> > > > 
> > > > > This driver adds support for the USB HCD present in STi
> > > > > SoC's from STMicroelectronics. It has been tested on the
> > > > > stih416-b2020 board.
> > > > 
> > > > This driver file, along with the Kconfig changes, belongs in the
> > > > arch/platform-specific source directory.  Not in drivers/usb/host/.  
> > > > It is, after all, a platform driver that registers two platform
> > > > devices.
> > > 
> > > Why do think that?
> > 
> > Because it is true.  One can easily see that st-hcd.c is a platform
> > driver: It contains a module_platform_driver() line and a struct
> > platform_driver definition near the end.  And it registers a platform
> > device by calling platform_device_add() in st_hcd_device_create(),
> > which is called twice by st_hcd_probe().
> 
> You are correct that this is indeed a platform driver and in the 'old
> days' these would have been stuffed into the ARM sub-architecture
> directories.  However, these became far too bloated and created too
> much churn which angered Linus.  A great deal has changed since his
> ARM rant [1].  All drivers (platform or otherwise) are now to live in
> 'drivers', which makes a great deal of sense really, doesn't it?
> 
> Did you grep kernel wide for module_platform_driver()?
> 
> $ git grep module_platform_driver -- arch/ | wc -l
> 12
> 
> $ git grep module_platform_driver -- drivers/ | wc -l
> 1138
> 
> Most platform drivers have already been moved.

Okay, I grant the point.  Objections withdrawn.  Fix up the spelling 
error and the other stuff in the Kconfig help text, and this will be 
acceptable.

Alan Stern

