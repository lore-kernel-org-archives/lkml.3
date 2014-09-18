Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbaIRUpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 16:45:00 -0400
Received: from imap.thunk.org ([74.207.234.97]:36358 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755AbaIRUo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 16:44:59 -0400
Date: Thu, 18 Sep 2014 16:44:55 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/1 linux-next] jbd2: Fix sparse context imbalance warning
Message-ID: <20140918204455.GA26995@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
References: <1411064974-18304-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411064974-18304-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 08:29:34PM +0200, Fabian Frederick wrote:
> spin_unlock after spin_lock only.
> 
> This fixes the following sparse warning:
> fs/jbd2/transaction.c:1102:20: warning: context imbalance
> in 'jbd2_journal_get_create_access' - different lock contexts for basic block
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

NAK, this is a case where I think it's better to make the static
analyzers better.  In any case sparse gives a lot of false positives
for this particular warning, so adding lines of code to try to shut up
sparse for every single false positive seems to be a losing
proposition.

I'll note that these sorts of bugs are much more easily picked up
using lockdep in any case, so we're probably better of just ignoring
these sorts of warnings.  Better to let the 0day kernel tester warn
for new sparse warnings, instead of trying to drive sparse warnings
down to zero.

Cheers,

					- Ted
