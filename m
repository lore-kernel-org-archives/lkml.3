Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab3J0DcF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 23:32:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3J0DcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 23:32:03 -0400
Date: Sat, 26 Oct 2013 20:33:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Vishal Annapurve <vannapurve@nvidia.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb-storage: scsiglue: Changing the command result
Message-ID: <20131027033348.GA10160@kroah.com>
References: <113ACA888B71994BB56E5CF3704953486D6612FB5B@BGMAIL02.nvidia.com>
 <Pine.LNX.4.44L0.1310261529050.24397-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1310261529050.24397-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
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

What's this line for?  (yeah, I know where it comes from, the point is
it doesn't belong here...)

Also, no signed-off-by, so I can't apply it...

greg k-h
