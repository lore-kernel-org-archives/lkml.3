Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbaFKNJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 09:09:32 -0400
Received: from imap.thunk.org ([74.207.234.97]:33374 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbaFKNJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 09:09:31 -0400
Date: Wed, 11 Jun 2014 09:09:25 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
Subject: Re: drivers/char/random.c: more ruminations
Message-ID: <20140611130925.GC23110@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, hpa@linux.intel.com,
	linux-kernel@vger.kernel.org, mingo@kernel.org, price@mit.edu
References: <20140611020835.GA23110@thunk.org>
 <20140611043416.13875.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611043416.13875.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 12:34:16AM -0400, George Spelvin wrote:
> 
> I haven't got a specific call chain where 128 bytes pushes it
> over a limit.  But kernel stack usage is a perennial problem.
> Wasn't there some discussion about that just recenty?
> 6538b8ea8: "x86_64: expand kernel stack to 16K"

Yes, but that was a call path involving file systems
writepage/writepages, block devices, and the writeback code paths.
None of which need random numbers...

> Normally, I just test using modules.  Especially when working on a
> driver for a hardware device, virtualization makes life difficult.
> But /dev/random is (for good reasons) not modularizable.

Using virtualization is much faster because you don't have to reboot
your system.  And if you want to test what happens to the random
driver at boot time, again, booting a guest kernel under KVM is much
faster, especially if you screw up and the system locks up....

Sure, if you are testing an actual hardware device, it's harder to use
virtualization.  But if you are doing any kind of core kernel work
(and /dev/random counts as core kernel), virtualization is really
convenient.

Cheers,

					- Ted
