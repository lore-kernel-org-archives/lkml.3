Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbbANVNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:13:01 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38916 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582AbbANVNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:13:00 -0500
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jan 2015 16:13:00 EST
X-Sasl-enc: pjyZlqYzrSl7087XbyJ0sapBEcgGqjvQX1UQmt3Eby0T 1421269666
Date: Wed, 14 Jan 2015 13:07:46 -0800
From: Greg KH <greg@kroah.com>
To: Miquel van Smoorenburg <mikevs@xs4all.net>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: net: prevent of emerging cross-namespace symlinks patches for
 3.14
Message-ID: <20150114210746.GC32102@kroah.com>
References: <54B6D241.6070700@xs4all.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B6D241.6070700@xs4all.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 09:32:01PM +0100, Miquel van Smoorenburg wrote:
> When running 'lxc' on the latest -stable kernel, 3.14.28, I'm seeing these
> errors:
> 
> Jan 14 17:47:16 lxc2 kernel: [   10.704890] WARNING: CPU: 0 PID: 3209 at
> fs/sys
> fs/dir.c:52 sysfs_warn_dup+0x8c/0xb0()
> Jan 14 17:47:16 lxc2 kernel: [   10.704892] sysfs: cannot create duplicate
> filename '/devices/virtual/net/eth0.104/upper_eth0'
> Jan 14 17:47:16 lxc2 kernel: [   10.704954] CPU: 0 PID: 3209 Comm:
> lxc-autostart Not tainted 3.14.28-xsserver #1
> 
> I did not see these errors in 3.12. This was fixed in 3.17 by:
> 
> net: prevent of emerging cross-namespace symlinks
> https://github.com/torvalds/linux/commit/4c75431ac3520631f1d9e74aa88407e6374dbbc4
> 
> net: fix creation adjacent device symlinks
> https://github.com/torvalds/linux/commit/7ce64c79c4decdeb1afe0bf2f6ef834b382871d1
> 
> These patches apply cleanly to 3.14.28. I think this should go into
> 3.14-stable.

For networking patches, can you cc: netdev and get an ack from the
networking maintainer for me to be able to apply them?

thanks,

greg k-h
