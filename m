Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab3JZTdf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 15:33:35 -0400
Received: from netrider.rowland.org ([192.131.102.5]:53339 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753365Ab3JZTdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 15:33:33 -0400
Date: Sat, 26 Oct 2013 15:33:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Vishal Annapurve <vannapurve@nvidia.com>
cc: Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: RE: [PATCH] usb-storage: scsiglue: Changing the command result
In-Reply-To: <113ACA888B71994BB56E5CF3704953486D6612FB5B@BGMAIL02.nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1310261529050.24397-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Oct 2013, Vishal Annapurve wrote:

> Hi Alan,
> 
> Here is the new patch:
> 
> From: Vishal Annapurve <vannapurve@nvidia.com>
> Date: Sat, 26 Oct 2013 21:10:11 +0530
> Subject: [PATCH] usb: storage: Proper cmd result assignment
> 
> This change replaces DID_ABORT with DID_TIMEOUT as a command result
> whenever US_FLIDX_TIMED_OUT bit is set.
> 
> This change is made to bring USB storage inline with a recent change:
> 
> commit    18a4d0a22ed6c54b67af7718c305cd010f09ddf8
> 
> [SCSI] Handle disk devices which can not process medium access commands
> We have experienced several devices which fail in a fashion we do not
> currently handle gracefully in SCSI. After a failure these devices will
> respond to the SCSI primary command set (INQUIRY, TEST UNIT READY, etc.)
> but any command accessing the storage medium will time out.
> 
> As the USB storage was setting command result as aborted rather than
> timed out, SCSI layer was not recognizing the above mentioned failure
> pattern.
> 
> Change-Id: Ic58e2247fed11649f4dbea56382354ba2fe0be1b
> ---
>  drivers/staging/keucr/transport.c   | 6 +++---
>  drivers/staging/keucr/usb.c         | 5 +++--

Those two files aren't part of usb-storage; they belong to a different 
driver.  It would be better to have a separate patch for them, and you 
should copy that patch to the driver's maintainer.

>  drivers/usb/storage/cypress_atacb.c | 1 +
>  drivers/usb/storage/isd200.c        | 2 +-
>  drivers/usb/storage/transport.c     | 8 ++++----
>  drivers/usb/storage/usb.c           | 9 +++++----
>  6 files changed, 17 insertions(+), 14 deletions(-)

Otherwise this is okay.  You might also want to submit a third patch 
for the uas driver.

Alan Stern

