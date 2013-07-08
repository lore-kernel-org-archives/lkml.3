Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab3GHQtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:49:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab3GHQte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:49:34 -0400
Date: Mon, 8 Jul 2013 09:49:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Dave Jones <davej@redhat.com>, Ming Lei <ming.lei@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dell_rbu: Select CONFIG_FW_LOADER_USER_HELPER explicitly
Message-ID: <20130708164933.GB12670@kroah.com>
References: <20130702192749.A2E7E660D9B@gitolite.kernel.org>
 <20130706221401.GA3652@redhat.com>
 <20130706223003.GA10697@kroah.com>
 <s5h4nc5bewf.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h4nc5bewf.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 11:05:20AM +0200, Takashi Iwai wrote:
> The reason is that dell_rbu driver requires it.  Without the kconfig
> option, this driver won't work at all.  So, it's a right fix for
> dell_rbu.
> 
> AFAIK, the consensus in the kernel side is that this too long fw
> loading time is basically a regression of user-space (udev or
> whatever).  There is no change in the kernel behavior.  The problem
> must exist even with the older kernels.
> 
> But, looking at the development, we can't expect that udev will be
> fixed soon, and this breakage persists already way too long.  Maybe a
> better solution is to kill the fallback to udev for normal f/w loading
> (i.e. for distro kernels).

I thought udev was already fixed for this issue, so why would a "modern"
distro need to worry about this?

> The patch below is an untested quick hack.  It adds a new Kconfig and
> a new function request_firmware_via_user_helper().  Distro kernels may
> set CONFIG_FW_LOADER_USER_HELPER_FALLBACK=n for avoiding 60 seconds
> stall for non-existing firmware file access -- as distributions know
> that the firmware files should be placed in the right path.
> 
> Thoughts?

There's no way we can just fix up the driver instead of doing this in
the firmware core?

thanks,

greg k-h
