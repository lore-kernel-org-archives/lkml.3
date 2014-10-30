Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbaJ3AiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 20:38:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973AbaJ3AiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 20:38:07 -0400
Date: Wed, 29 Oct 2014 17:36:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jeff Epler <jepler@unpythonic.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: incompatible pci sysfs change since 3.12 (5136b2da770d)
Message-ID: <20141030003657.GA5487@kroah.com>
References: <20141030002258.GA59253@unpythonic.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030002258.GA59253@unpythonic.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 07:22:58PM -0500, Jeff Epler wrote:
> Hi.
> 
> I am an author of LinuxCNC, a GPL'd CNC control for Linux.
> 
> Recently we added support for userspace PCI drivers.  This worked with
> kernel 3.2 but doesn't with kernel 3.16.  The software fails early with
>     Failed to open "/sys/devices/pci0000:00/.../enable" (Permission denied)
> 
> This appears to be because our software relies on the documented
> "enable" sysfs file for pci devices (Documentation/filesystem/sysfs-pci.txt)
> which was (unintentionally?) changed to "enabled" in the above-named
> patch:
> 
> 5136b2da770d PCI: convert bus code to use dev_groups
> ...
> +static DEVICE_ATTR_RW(enabled);
> ...
> -   __ATTR(enable, 0600, is_enabled_show, is_enabled_store),
> 
> Are we in the LinuxCNC project wrong in thinking that stuff in /sys (and
> not /sys/debug) is supposed to be a durable API/interface for userspace
> to the kernel?  (It must be a low-usage API if it went unnoticed for a
> year :-/)

Ugh, that's my fault, I made a typo and should not have renamed the
sysfs file, very sorry about that.

I'll work on making up a patch to fix this and get it into the stable
kernels so that you don't have to have a work-around for very long.

> We'll have to work around it by modifying our software (since we'd like
> to work with the kernels people already have) in any case.
> 
> Even if it is not going to be changed compatibly with older kernels, it
> seems like the documentation should be updated!

I'll fix it up, this was just a bug, my apologies.

greg k-h
