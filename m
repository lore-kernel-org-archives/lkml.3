Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbaFIBgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 21:36:12 -0400
Received: from imap.thunk.org ([74.207.234.97]:56563 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573AbaFIBgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 21:36:00 -0400
Date: Sun, 8 Jun 2014 21:35:53 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, price@mit.edu, linux-kernel@vger.kernel.org,
        mingo@kernel.org
Subject: Re: [RFC PATCH] drivers/char/random.c: Is reducing locking range
 like this safe?
Message-ID: <20140609013553.GA1167@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, hpa@linux.intel.com,
	price@mit.edu, linux-kernel@vger.kernel.org, mingo@kernel.org
References: <20140609000524.19476.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609000524.19476.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2014 at 08:05:24PM -0400, George Spelvin wrote:
> 
> The problem I started trying to solve is readers (entropy extractors)
> monopolizing the pool lock and stalling writers (entropy mixers), which
> are supposed to be fast and low overhead.

Which writer are you worried about, specifically?  A userspace write
to /dev/random from rgnd?

And have you measured this to be something significant, or is this a
theoretical concern.  If you've measured it, what's the conditions
where this is stalling an entropy mixer a significant amount of time?

      	      	       	  	  	  - Ted
