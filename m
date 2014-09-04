Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaIDOA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:00:28 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34598 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbaIDOA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:00:26 -0400
X-Sasl-enc: xSCkiWpuJRsERlT7Jx6ykF8Xe0Wqs1snDEbLTfzpgJed 1409839225
Date: Thu, 4 Sep 2014 07:00:24 -0700
From: Greg KH <greg@kroah.com>
To: Christoph Biedl <linux-kernel@vger.kernel.org>
Cc: stable@vger.kernel.org
Subject: Re: [PATCH 3.14 81/88] usb: hub: Prevent hub autosuspend if
 usbcore.autosuspend is -1
Message-ID: <20140904140024.GB12499@kroah.com>
References: <20140903220515.958924632@linuxfoundation.org>
 <20140903220518.369252517@linuxfoundation.org>
 <1409826760@msgid.manchmal.in-ulm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409826760@msgid.manchmal.in-ulm.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 12:38:57PM +0200, Christoph Biedl wrote:
> Greg Kroah-Hartman wrote...
> 
> > 3.14-stable review patch.  If anyone has any objections, please let me know.
> 
> > From: Roger Quadros <rogerq@ti.com>
> > 
> > commit bdd405d2a5287bdb9b04670ea255e1f122138e66 upstream.
> 
> Obviously that one is the culprit for
> 
> drivers/usb/core/hub.c: In function 'hub_probe':
> drivers/usb/core/hub.c:1702:21: error: 'struct dev_pm_info' has no member named 'autosuspend_delay'
> make[6]: *** [drivers/usb/core/hub.o] Error 1
> make[5]: *** [drivers/usb/core] Error 2
> make[4]: *** [drivers/usb] Error 2
> 
> Also obviously usb-fix-build-error-with-config_pm_runtime-disabled.patch
> is the fix for this. My build host is still busy doing other things so
> I could not validate that yet ... but I'm pretty sure.
> 
> The problem exists in 3.16, too.

I've already queued up this patch for all branches, and should be in the
-rc2 tarball for these stable kernels.

thanks,

greg k-h
