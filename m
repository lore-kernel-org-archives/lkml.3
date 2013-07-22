Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab3GVMku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 08:40:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34200 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3GVMkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 08:40:49 -0400
Date: Mon, 22 Jul 2013 13:40:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] um: change defconfig to stop spawning xterm
Message-ID: <20130722124047.GL4165@ZenIV.linux.org.uk>
References: <1374258017-19606-1-git-send-email-artagnon@gmail.com>
 <51E988FF.9010201@nod.at>
 <CALkWK0kj=maJgrLV11h8GzJ-L24KWDzgCAiZa97rieJKUXeW_A@mail.gmail.com>
 <CALkWK0=0NWediExGCwJ3R-O+7V_9sgGzJPUaXgaTEka5O05N=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0=0NWediExGCwJ3R-O+7V_9sgGzJPUaXgaTEka5O05N=Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 03:15:14PM +0530, Ramkumar Ramachandra wrote:
> Ramkumar Ramachandra wrote:
> > [1]: http://lists.freedesktop.org/archives/systemd-devel/2013-July/012152.html
> 
> ... and the patches were rejected.  Lennart says that UML providing
> /dev/tty* is wrong, and that UML should call them /dev/hvc* (or
> something).  Can we do something about the situation?  Can we remove
> /dev/tty*, and provide /dev/hvc*?  Will we be breaking existing users?

Yes, you would be breaking existing users.  Starting with anybody with static
/dev.  Or a debian userland, for that matter.  Any systemd-free setup,
actually.

Changing device number assignments is not to be done lightly, whether
they should've been set that way back then or not.

As for Lennart's opinion...  *shrug*  He's free to do whatever he wants
in systemd.  It does not translate into having any kind of control over
the kernel.
