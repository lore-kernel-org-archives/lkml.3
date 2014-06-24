Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbaFXNvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 09:51:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaFXNvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 09:51:18 -0400
Date: Tue, 24 Jun 2014 09:51:01 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Dexuan Cui <decui@microsoft.com>
Cc: linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com,
        linux-fbdev@vger.kernel.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, kys@microsoft.com, haiyangz@microsoft.com
Subject: Re: [PATCH] video: hyperv: hyperv_fb: refresh the VM screen by force
 on VM panic
Message-ID: <20140624135101.GB10115@kroah.com>
References: <1403569757-2622-1-git-send-email-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403569757-2622-1-git-send-email-decui@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 08:29:17AM +0800, Dexuan Cui wrote:
> Currently the VSC has no chance to notify the VSP of the dirty rectangle on VM
> panic because the notification work is done in a workqueue, and in panic() the
> kernel typically ends up in an infinite loop, and a typical kernel config has
> CONFIG_PREEMPT_VOLUNTARY=y and CONFIG_PREEMPT is not set, so a context switch
> can't happen in panic() and the workqueue won't have a chance to run. As a
> result, the VM Connection window can't refresh until it's closed and we
> re-connect to the VM.
> 
> We can register a handler on panic_notifier_list: the handler can notify
> the VSC and switch the framebuffer driver to a "synchronous mode", meaning
> the VSC flushes any future framebuffer change to the VSP immediately.
> 
> MS-TFS: 157532

What is this line for?

thanks,

greg k-h
