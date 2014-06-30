Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaF3NnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:43:18 -0400
Received: from imap.thunk.org ([74.207.234.97]:36939 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbaF3NnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:43:17 -0400
Date: Mon, 30 Jun 2014 09:43:13 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ext4: total breakdown on USB hdd, 3.0 kernel
Message-ID: <20140630134313.GA3753@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Pavel Machek <pavel@ucw.cz>,
	kernel list <linux-kernel@vger.kernel.org>
References: <20140626202021.GA8512@xo-6d-61-c0.localdomain>
 <20140626203052.GA9449@xo-6d-61-c0.localdomain>
 <20140627024659.GF6826@thunk.org>
 <20140629202516.GA11430@amd.pavel.ucw.cz>
 <20140629210428.GD2162@thunk.org>
 <20140630064644.GA23079@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630064644.GA23079@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 08:46:44AM +0200, Pavel Machek wrote:
> :-). Aha, and I misremembered, it was block descriptor checksums, not
> inode checksums:
> 
> One or more block group descriptor checksums are invalid.  Fix? yes
> 
> Group descriptor 0 checksum is invalid.  FIXED.
> Group descriptor 1 checksum is invalid.  FIXED.
> Group descriptor 2 checksum is invalid.  FIXED.
> Group descriptor 3 checksum is invalid.  FIXED.

Yeah, what we should be doing here is to try to backup block
descriptors and check to see if they are valid, and if so, use them
instead.


> I'm still trying to figure out what went wrong in the OLPC-1.75 + USB
> disk case.
> 
> One possibility is that OLPC is unable to provide enough power from
> the two USB ports to power Seagate Momentus 5400.6, and that the hard
> drive fails to detect the brown-out and does something wrong. (Are
> SATA drives expected to work at 4.5V? Because that's what is
> guaranteed on USB, IIRC).

The USB spec seems to require 5V +/i 0.25V, which also seems to be the
spec on laptop drives.  It wouldn't surprise me if the OLPC (or its
power adapter) is a bit dodgy under heavy load, though.  It might be
useful for you to measure the voltage and amps delivered at the USB
ports

> Heavy corruption happened when I was charging the phone _and_ running
> the hard drive, from the OLPC. Now I have seen cases when OLPC crashed 
> on device plug-in, in what looked like a brown-out...

.... and from the power brick to see if either is out of spec.



						- Ted
