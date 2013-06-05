Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab3FERya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:54:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab3FERy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:54:27 -0400
Date: Wed, 5 Jun 2013 10:54:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tobias Winter <tobias@linuxdingsda.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Rob Landley <rob@landley.net>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Increase the number of USB to serial devices we can
 support at once
Message-ID: <20130605175426.GA13461@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are 3 patches that I've tested out on my system with only a small
number of devices, but it seems to work, so why not let others try it
out...

These patches make the USB to serial core have the ability to support up
to 3000 devices at once now.  We do this in the following steps:
	- adding the minor number to the usb_serial_port structure
	- removing the static array of ports, and use idr instead
	- increasing the number

Now, if you pay attention, we end up taking up more runtime memory than
before, because we are asking the tty layer to reserve a bunch more tty
devices for us, negating the potential savings of getting rid of our
original static array.  I'll work on fixing up the tty layer calls to
properly allocate the tty devices only when we need them, much like the
pty layer does.  When that's done, we can bump the number of usb to
serial devices up to 16k with no memory problems.

This series is based on my usb-linus branch on my usb.git tree on
git.kernel.org, as I needed some of the usb-serial fixes that are in
that branch already.

Testing / review is most welcome.

thanks,

greg k-h
