Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbaDBNGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:06:03 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:38151 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758676AbaDBNGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:06:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140401184817.GA21855@kroah.com>
References: <20140401184817.GA21855@kroah.com>
Date: Wed, 2 Apr 2014 07:06:00 -0600
Message-ID: <CAKocOOP2E8L1+w0Zik18rnZH+VsvQJNbXymC-7oH+twkDJQKQg@mail.gmail.com>
Subject: Re: [GIT PULL] Staging driver patches for 3.15-rc1
From: Shuah Khan <shuahkhan@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 12:48 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> The following changes since commit dcb99fd9b08cfe1afe426af4d8d3cbc429190f15:
>
>   Linux 3.14-rc7 (2014-03-16 18:51:24 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.15-rc1
>
> for you to fetch changes up to 94debda32429e1a348fec8543245f1190a92d68c:
>
>   staging: xillybus: XILLYBUS_PCIE depends on PCI_MSI (2014-03-21 12:24:09 -0700)
>
> ----------------------------------------------------------------
> Staging driver pull request for 3.15-rc1
>
> Here's the huge drivers/staging/ update for 3.15-rc1.
>
> Loads of cleanup fixes, a few drivers removed, and some new ones added.
>
> All have been in linux-next for a while.
>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

>
> John de la Garza (3):
>       staging: usbip: vhci_sysfs.c: check return value of sscanf
>       comedi:drivers:poc.c: unnecessary space before function pointer arguments
>       usbip:usbip_common.c: check return value of sscanf

Please pull in this fix - without this usbip attach will always fail
with the above scanf return value checks:

[PATCH v2] staging/usbip: fix store_attach() sscanf return value check
https://lkml.org/lkml/2014/3/25/178

> Valentina Manea (20):
>       staging: usbip: convert usbip-host driver to usb_device_driver
>       staging: usbip: userspace: migrate usbip_bind to libudev
>       staging: usbip: userspace: remove useless libsysfs includes
>       staging: usbip: userspace: migrate usbip_unbind to libudev
>       staging: usbip: userspace: migrate usbip_list to libudev
>       staging: usbip: userspace: re-add interface information listing
>       staging: usbip: userspace: add new list API
>       staging: usbip: userspace: move sysfs_utils to libsrc
>       staging: usbip: userspace: migrate usbip_host_driver to libudev
>       staging: usbip: userspace: remove class device infrastructure in vhci_driver
>       staging: usbip: userspace: migrate vhci_driver to libudev
>       staging: usbip: userspace: remove libsysfs flag and autoconf check
>       staging: usbip: userspace: update dependencies in README
>       staging: usbip: userspace: increase version to 2.0
>       staging: usbip: let client choose device configuration
>       staging: usbip: trigger driver probing after unbinding from usbip-host
>       staging: usbip: claim ports used by shared devices
>       staging: usbip: userspace: don't throw error when trying to read configuration specific attributes
>       staging: usbip: userspace: add hwdata as optional dependency in README
>       usbcore: rename struct dev_state to struct usb_dev_state
>

Please pull in the following that fixes usbipd SIGSEGV:

staging/usbip: userspace - fix usbipd SIGSEGV from refresh_exported_devices()
https://lkml.org/lkml/2014/3/24/418

thanks,
-- Shuah
