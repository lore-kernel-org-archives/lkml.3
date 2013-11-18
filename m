Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab3KRPJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 10:09:01 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46151 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750779Ab3KRPIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 10:08:54 -0500
Date: Mon, 18 Nov 2013 10:08:53 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vishal Annapurve <vannapurve@nvidia.com>
cc: Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: RE: [PATCH] usb-storage: scsiglue: Changing the command result
In-Reply-To: <113ACA888B71994BB56E5CF3704953486D664FCD42@BGMAIL02.nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1311181008330.1421-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Nov 2013, Vishal Annapurve wrote:

> Hi,
> 
> Here are the updated patches:	
> 
> [PATCH 1/3] usb: storage: Proper cmd result assignment
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
> Signed-off-by: Vishal Annapurve <vannapurve@nvidia.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

