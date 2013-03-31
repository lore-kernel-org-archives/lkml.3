Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab3CaH4i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 03:56:38 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:34012 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3CaH4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 03:56:36 -0400
Date: Sun, 31 Mar 2013 09:56:23 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6]  Make return type of i2c_del_adapter() (and
 i2c_del_mux_adapter())  void
Message-ID: <20130331095623.146f65db@endymion.delvare>
In-Reply-To: <51574E71.7010403@metafoo.de>
References: <1362853009-20789-1-git-send-email-lars@metafoo.de>
	<20130330211352.07530db7@endymion.delvare>
	<51574E71.7010403@metafoo.de>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Mar 2013 21:43:29 +0100, Lars-Peter Clausen wrote:
> On 03/30/2013 09:13 PM, Jean Delvare wrote:
> > I see:
> > 
> > struct device_driver {
> > 	(...)
> > 	int (*probe) (struct device *dev);
> > 	int (*remove) (struct device *dev);
> >
> > So the driver core does allow remove functions to return an error.
> 
> Well, the return type is int, but the return value is never checked. So you
> can return an error value, but the device driver core is going to care and
> the device is still removed. So any code which does return an error in it's
> probe function in the assumption that this means the device will still be
> present is broken and leaves the system in an undefined state. So if that
> happens the kernel will probably crash sooner or later, or if you are lucky
> you only created a few resources leaks.
> 
> And no we can't change the core to handle errors from a drivers remove
> callback. It's a basic inherent property of the Linux device driver model
> that any device can be removed at any time.
> 
> > Are you going to fix all subsystems as you are doing for i2c now, and then
> > change device_driver.remove to return void? If not, I don't see the
> > point of changing it in i2c.
> 
> As I said it's a bug if a driver returns an error in its remove function.
> And the fact that the return type of the remove callback is int is pretty
> much misleading in this regard, so the long term goal is to make the return
> type void. But that's a long way to go until we get there, fixing the return
> type of i2c_del_adapter() is kind of the low hanging fruit.

OK, makes sense, thanks for the clarification.

-- 
Jean Delvare
