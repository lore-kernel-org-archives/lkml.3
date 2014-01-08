Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbaAHROa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 12:14:30 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59156 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756730AbaAHRO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 12:14:26 -0500
Date: Wed, 8 Jan 2014 12:14:25 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Laight <David.Laight@ACULAB.COM>
cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, walt <w41ter@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D455602@AcuExch.aculab.com>
Message-ID: <Pine.LNX.4.44L0.1401081210140.1659-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jan 2014, David Laight wrote:

> > From: Alan Stern
> > 
> > This may be a foolish question, but why is xhci-hcd using no-op TRBs in
> > the first place?
> 
> Because it can't write in a link TRB because other parts of the
> code use link TRBs to detect the end of the ring.
> 
> The problem is that it can't put a link TRB in the middle of
> a chain of data fragments unless it is at a 'suitable' offset
> from the start of the data TD. Given arbitrary input fragmentation
> this means that you can't put a link TRB in the middle of a TD.
> (The documented alignment might be as high as 16kB.)
> 
> If the rest of the code used a 'ring end pointer' then a link TRB
> could be used instead.

I see.  Sounds like a poor design decision in hindsight.  Can it be
changed?

Alan Stern

