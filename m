Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab3JROKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:10:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44673 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755622Ab3JROKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:10:13 -0400
Date: Fri, 18 Oct 2013 10:10:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vishal Annapurve <vannapurve@nvidia.com>
cc: Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: RE: [PATCH] usb-storage: scsiglue: Changing the command result
In-Reply-To: <113ACA888B71994BB56E5CF3704953486D65F41715@BGMAIL02.nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1310181002190.1164-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Oct 2013, Vishal Annapurve wrote:

> Hi Alan,
> 
> What I wanted to say was If the bit US_FLIDX_TIMED_OUT can have more
> meanings than timed out then maybe it would be best to override the
> results after usb-storage is done with the command maybe in scsi layer
> itself who aborted it in the first place.

US_FLIDX_TIMED_OUT has one very specific meaning: command_abort() was
called.

Since command_abort() is the .eh_abort_handler routine, 
US_FLIDX_TIMED_OUT means that the SCSI layer decided to abort the 
command.

Does the SCSI layer ever abort a command for any reason other than a
timeout?  If not, you may conclude that US_FLIDX_TIMED_OUT indicates 
a timeout.  But if it does, you should not make this conclusion.

> My concern was that overriding the result in usb storage or scsi layers
> will have more side effects than doing it in scsiglue.c.
> And by scsi-usb storage bridge what I meant was specifically the code in 
> scsiglue.
> 
> Question about your last mail, do you want to change all the occurrences of
> DID_ABORT from usb-storage to DID_TIMEOUT?

Put it this way: There's no good reason for changing some of them but 
not all of them.

And if you're going to change them at all, it makes no sense to first 
set the result to DID_ABORT and then change it to DID_TIMEOUT.  You 
should simply set it to DID_TIMEOUT in the first place.

Alan Stern

