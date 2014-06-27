Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaF0CrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 22:47:08 -0400
Received: from imap.thunk.org ([74.207.234.97]:60418 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbaF0CrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 22:47:07 -0400
Date: Thu, 26 Jun 2014 22:46:59 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ext4: total breakdown on USB hdd, 3.0 kernel
Message-ID: <20140627024659.GF6826@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Pavel Machek <pavel@ucw.cz>,
	kernel list <linux-kernel@vger.kernel.org>
References: <20140626202021.GA8512@xo-6d-61-c0.localdomain>
 <20140626203052.GA9449@xo-6d-61-c0.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626203052.GA9449@xo-6d-61-c0.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 10:30:52PM +0200, Pavel Machek wrote:
> 
> It looks like the filesystem contains _way_ too many 0xffff's:

That sounds like it's a hardware issue.  It may be that the controller
did something insane while trying to do a write at the point when the
disk drive was disconnected (and so the drive suffered a power drop).

> I saved beggining of the filesystem using cat /dev/sdc4 | gzip -9 - > /dev/sda3, but
> then ran out of patience. So there may be something for analysis, but...

The way to snapshot just the metadata blocks for analysis is:

e2image -r /dev/hdc4 | bzip2 > ~/hdc4.e2i.bz2

But in this case, it's I doubt it will be very helpful, because
fundamentally, this appears to be a hardware issue.

       	    	       	       	       - Ted
