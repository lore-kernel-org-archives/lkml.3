Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbaAGV1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 16:27:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:49959 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135AbaAGV1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 16:27:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,620,1384329600"; 
   d="scan'208";a="435324715"
Date: Tue, 7 Jan 2014 13:27:12 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "'walt'" <w41ter@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within a
 USB payload burst
Message-ID: <20140107212712.GB4199@xanatos>
References: <20131218211220.412278148@linuxfoundation.org>
 <52C32BB0.90600@gmail.com>
 <20140102191510.GA9621@xanatos>
 <52C6D9F1.9000709@gmail.com>
 <20140103195455.GA4193@xanatos>
 <52C729CE.9050307@gmail.com>
 <20140103232929.GD4193@xanatos>
 <20140107003157.GA7963@xanatos>
 <52CC014C.5060604@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D453E1A@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D453E1A@AcuExch.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 01:58:32PM +0000, David Laight wrote:
> The dmesg contains:
> 
> [  538.728064] EXT4-fs warning (device dm-0): ext4_end_bio:316: I/O error writing to inode 23330865 (offset 0 size 8388608 starting block 812628)
> 
> An 8MB transfer will need at least 128 ring entries (TRB) even if the request
> is a single contiguous memory block.
> 
> Are you using the patch that increases the ring size from 64 to 256?

It's likely that the block layer is breaking up the EXT4 write into
several transfers, since usb-storage limits overall transfer size to
120 KB.  In any case, I added more debugging in the last patch to print
the number of TRBs necessary.  That way we can verify the patch to limit
the number of scatter-gather list entries is working.

Sarah Sharp
