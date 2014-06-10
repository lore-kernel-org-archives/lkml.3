Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933996AbaFJBUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 21:20:44 -0400
Received: from imap.thunk.org ([74.207.234.97]:58588 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171AbaFJBUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 21:20:42 -0400
Date: Mon, 9 Jun 2014 21:20:36 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
Subject: Re: drivers/char/random.c: more ruminations
Message-ID: <20140610012036.GA8092@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, hpa@linux.intel.com,
	linux-kernel@vger.kernel.org, mingo@kernel.org, price@mit.edu
References: <20140609155046.GA8993@thunk.org>
 <20140610002057.21845.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610002057.21845.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 08:20:57PM -0400, George Spelvin wrote:
> 
> I have an idea for a patch to change _xfer_secondary_pool
> to use extract_buf rather than extract_entropy; is all that
> FIPS stuff needed for purely internal transfers?

That's not the part of extract_entropy() which is critical.  What's
critical is the control over only transfering entropy when there is at
least a certain minimum amount of entropy.  This provides the
Yarrow-like avalanche property which is required to provide recovery
after the internal state of the entropy pools have been exposed.

> Also, shouldn't the r->last_pulled holdoff in xfer_secondary_pool be
> really limited to actual transfers?  I.e. reorder the conditions as...

Yes, that makes sense.

Cheers,

						- Ted
