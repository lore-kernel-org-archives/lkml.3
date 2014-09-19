Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbaISVm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 17:42:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757845AbaISVm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 17:42:57 -0400
Date: Fri, 19 Sep 2014 14:42:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Roman Pen <r.peniaev@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [v4 PATCH 1/1] init: fix race between rootfs mount and firmware
 loading
Message-ID: <20140919214257.GA27574@kroah.com>
References: <20140918174127.GB340@redhat.com>
 <1411130664-10195-1-git-send-email-r.peniaev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411130664-10195-1-git-send-email-r.peniaev@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 09:44:24PM +0900, Roman Pen wrote:
> The thing is that built-in modules are being inited before
> rootfs mount.  Some of the modules can request firmware loading
> from another thread using async 'request_firmware_nowait' call
> on inition, so we can catch this kind of race:
>    rootfs does not exist yet, but we are going to open and load
>    firmware file requesting it from the kernel thread.
> 
> Solution is simple: before any rootfs access firmware loader
> must wait for rootfs mount.

Even simpler solution, don't do that :)

If your hardware needs firmware this early, and you don't put the
firmare into the initrd/initramfs, then it will just be loaded later on,
when the root filesystem is needed and the driver asks for it again
(your driver is failing "nicely" and allows the firmware to be loaded
later, right?  If not, that should be fixed...)

Or, build the firmware into the kernel, I think we still have that
option for some drivers that really wanted/needed this.

What has changed recently that requires this type of patch?  What is
wrong with the above solutions?

thanks,

greg k-h
