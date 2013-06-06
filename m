Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab3FFRbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 13:31:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50809 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab3FFRbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 13:31:04 -0400
Date: Thu, 6 Jun 2013 10:31:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tobias Winter <tobias@linuxdingsda.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, Johan Hovold <jhovold@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] Increase the number of USB to serial devices we can
 support at once
Message-ID: <20130606173103.GA1812@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the updated patch set to increase the number of USB to serial
devices that we can support at once.

Changes from v1:
	- now only support 512 instead of 3000 devices, as that's all we
	  really need / want at this point in time.
	- removed usb_serial.minor field as it doesn't make any sense
	  now.
	- addressed review comments / issues found in first round of
	  patches.

Overall, the diffstat is still nice, we are removing more code than we
are adding:

 drivers/staging/serqt_usb2/serqt_usb2.c |   36 +++-----
 drivers/usb/serial/ark3116.c            |    4 
 drivers/usb/serial/bus.c                |    6 -
 drivers/usb/serial/console.c            |    2 
 drivers/usb/serial/cp210x.c             |    2 
 drivers/usb/serial/cypress_m8.c         |    4 
 drivers/usb/serial/digi_acceleport.c    |    6 -
 drivers/usb/serial/f81232.c             |    7 -
 drivers/usb/serial/garmin_gps.c         |    6 -
 drivers/usb/serial/io_edgeport.c        |   60 +++++--------
 drivers/usb/serial/io_ti.c              |   23 ++---
 drivers/usb/serial/keyspan.c            |   29 ++----
 drivers/usb/serial/metro-usb.c          |    4 
 drivers/usb/serial/mos7720.c            |   39 ++++----
 drivers/usb/serial/mos7840.c            |   59 ++++---------
 drivers/usb/serial/opticon.c            |    4 
 drivers/usb/serial/pl2303.c             |    4 
 drivers/usb/serial/quatech2.c           |    9 --
 drivers/usb/serial/sierra.c             |    2 
 drivers/usb/serial/ssu100.c             |    2 
 drivers/usb/serial/ti_usb_3410_5052.c   |   12 +-
 drivers/usb/serial/usb-serial.c         |  139 ++++++++++++++++----------------
 drivers/usb/serial/usb_wwan.c           |    4 
 drivers/usb/serial/whiteheat.c          |   22 ++---
 include/linux/usb/serial.h              |   15 +--
 25 files changed, 224 insertions(+), 276 deletions(-)

This series is on top of my usb-linus branch of my usb.git tree on
git.kernel.org, as it relies on some patches in there already.

If there are no objections to these, I'll queue them up to be merged in
3.11.

thanks,

greg k-h
