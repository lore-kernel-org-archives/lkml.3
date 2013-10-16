Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab3JPOj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:39:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59460 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750811Ab3JPOj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:39:58 -0400
Date: Wed, 16 Oct 2013 10:39:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <tom.leiming@gmail.com>
cc: Vishal Annapurve <vannapurve@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb-storage: scsiglue: Changing the command result
In-Reply-To: <CACVXFVNoMwu6Gi3kWfz=6dm+nq=+3hFyRQGQkQZRsZ46X_ACFQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1310161036550.1264-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013, Ming Lei wrote:

> > Of course the SCSI midlayer has decided to abort.  That's the only way
> > this bit can get set.  But usb-storage doesn't know why SCSI decided to
> > abort.
> 
> usb-storage may know if it is caused by timeout via .eh_timed_out callback
> if it wants to know.

Ah, good point.

Vishal, since the only way an abort can occur is when the 
.eh_timeout_out callback runs, I think it makes sense to set the result 
code to DID_TIME_OUT instead of DID_ABORT in all cases.

Alan Stern

