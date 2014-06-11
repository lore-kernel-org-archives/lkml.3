Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbaFKCVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 22:21:37 -0400
Received: from imap.thunk.org ([74.207.234.97]:60867 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791AbaFKCVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 22:21:34 -0400
Date: Tue, 10 Jun 2014 22:21:28 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
Subject: Re: drivers/char/random.c: more ruminations
Message-ID: <20140611022128.GB23110@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, hpa@linux.intel.com,
	linux-kernel@vger.kernel.org, mingo@kernel.org, price@mit.edu
References: <20140610212032.GG12104@thunk.org>
 <20140611001003.12979.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611001003.12979.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 08:10:03PM -0400, George Spelvin wrote:
> 
> But even I get annoyed when I have a 1-line comment typo fix and wonder
> if it really deserves its own commit or if I can just include it with
> the other changes I'm making to that file.

Unless you're actually modifying that section of code, I usually
recommend that people just not bother.  The fact that someone included
a one-line comment fix caused a merge conflict with the ext4 pull in
this merge window that Linus had to fix up.  Not that it's a big deal,
but unless it's something that's really going to confuse the reader, I
treat it as white space fixes; something that's only worth fixing if
that particular function is being modified for a "real" change.

> I have half a dozen patches to random.c already waiting.  For example,
> one is a bulk conversion of __u8 and __u32 to u8 and u32.  The underscore
> versions are only intended for public header files where namespace
> pollution is a problem.

And sorry, I consider this sort of thing is to be just code wankery.
We use __u32 in a number of places in the kernel, and it doesn't
really affect code readability.  A change like this almost guarantees
that stable patches won't apply manually, and will have to be ported
manually.  It's just not worth it.

						- Ted
