Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbaBQTXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 14:23:31 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54068 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbaBQTX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 14:23:29 -0500
Date: Mon, 17 Feb 2014 11:23:22 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Andrew Duggan <aduggan@synaptics.com>,
        Vincent Huang <vincent.huang@tw.synaptics.com>,
        Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/11] Input: synaptics-rmi4 - do not update
 configuration in rmi_f01_probe()
Message-ID: <20140217192321.GC19223@core.coreip.homeip.net>
References: <1392269277-16391-1-git-send-email-dmitry.torokhov@gmail.com>
 <1392269277-16391-3-git-send-email-dmitry.torokhov@gmail.com>
 <52FD1BC0.1050009@synaptics.com>
 <20140213215432.GA6225@core.coreip.homeip.net>
 <52FEA01B.7040604@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FEA01B.7040604@synaptics.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 03:00:43PM -0800, Christopher Heiny wrote:
> On 02/13/2014 01:54 PM, Dmitry Torokhov wrote:
> >On Thu, Feb 13, 2014 at 11:23:44AM -0800, Christopher Heiny wrote:
> >>>On 02/12/2014 09:27 PM, Dmitry Torokhov wrote:
> >>>> >Do not write configuration data in probe(), we have config() for that.
> >>>
> >>>Then we should call config() in rmi_function_probe() to ensure that
> >>>any platform data or device tree configuration settings get written
> >>>to the device.
> >
> >Well, yes, we may elect to update device configuration in probe, but
> >then we should not be doing that 2nd time in ->config(). We shoudl pick
> >either one or another.
> 
> But as the code currently stands, config() is only called when a
> device reset is detected, not during initialization.  So if there's
> platform specific configuration data that needs to be written to a
> function, it won't get written until after a device reset occurs,
> which might never happen.  So either we need to write that data (or
> call config()) in each function's probe(), or in
> rmi_function_probe().

Ah, I missed the fact that we do not normally call ->config() unless
device was reset. BTW, if device was reset, shouldn't we tear down
everything and then reenumerate all functions?

-- 
Dmitry
