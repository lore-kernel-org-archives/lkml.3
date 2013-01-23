Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab3AWQwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:52:00 -0500
Received: from mxout-08.mxes.net ([216.86.168.183]:30784 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab3AWQv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:51:58 -0500
Date: Wed, 23 Jan 2013 11:51:56 -0500
From: Brad Tilley <brad@16s.us>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: PROBLEM: 3.8.0-rc4 keyboard failure at boot
Message-ID: <20130123165156.GB29114@16s.us>
References: <20130121213604.GA31225@16s.us>
 <20130122001346.GD16638@core.coreip.homeip.net>
 <alpine.LNX.2.00.1301221122380.20374@pobox.suse.cz>
 <20130122121947.GB27072@16s.us>
 <alpine.LNX.2.00.1301221341550.20374@pobox.suse.cz>
 <20130122134658.GA27683@16s.us>
 <alpine.LNX.2.00.1301221821160.20374@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1301221821160.20374@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 06:22:42PM +0100, Jiri Kosina wrote:
> On Tue, 22 Jan 2013, Brad Tilley wrote:
> 
> > See attached. Two dmesgs from the same machine. One from 3.7.3, the 
> > other from 3.8-rc4 (with a ps2 keyboard). USB keyboards on this machine 
> > never work with 3.8, but always works with 3.7.
> > 
> > I used an old ps2 keyboard to enter the dm-crypt password. After that, 
> > the boot process continues and the USB keyboard and mouse become active 
> > and begin to work. However, USB keyboards do not work when the user is 
> > prompted to enter the dm-crypt decryption password early in the boot 
> > process. That's the primary issue.
> 
> Are you sure that HID modules are loaded at the time you are being asked 
> for the dmcrypt password?

Thanks... I believe that was the problem. I added some modules to /etc/initramfs-tools/modules and made a new initramfs image. Here are the modules I added (likely overkill, but now the keyboards work 100% of the time on all systems):

ehci_pci usbcore usb_common xhci_hcd uhci_hcd ehci_hcd ohci_hcd usbhid hid_generic

Thanks,

Brad

