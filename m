Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759790Ab3JOUWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:22:07 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58688 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759540Ab3JOUWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:22:05 -0400
Date: Tue, 15 Oct 2013 16:22:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vishal Annapurve <vannapurve@nvidia.com>
cc: Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: RE: [PATCH] usb-storage: scsiglue: Changing the command result
In-Reply-To: <113ACA888B71994BB56E5CF3704953486D65F41155@BGMAIL02.nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1310151615160.1377-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013, Vishal Annapurve wrote:

> Hi Alan,
> 
> USB storage maybe just has to say that the abort occurred. By setting the
> US_FLIDX_TIMED_OUT bit USB storage is getting signaled that the reason was
> time out and the command is being aborted.

No.  By setting the US_FLIDX_TIMED_OUT bit, usb-storage indicates that
the command was aborted.  This doesn't indicate anything about the
reason for the abort.  (Maybe this bit's name wasn't chosen very well.)

> Now, it's arguable whether to change the implication of US_FLIDX_TIMED_OUT
> bit for scsi - USB storage bridge or for entire usb storage

I don't understand this.  What's the difference between "scsi - USB 
storage bridge" and "entire usb storage"?  Aren't they the same thing?

>  Or maybe scsi has
> decided to abort so it should override the result.

Of course the SCSI midlayer has decided to abort.  That's the only way 
this bit can get set.  But usb-storage doesn't know why SCSI decided to 
abort.

Alan Stern

