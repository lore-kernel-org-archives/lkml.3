Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab3KVBdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 20:33:01 -0500
Received: from imap.thunk.org ([74.207.234.97]:60721 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361Ab3KVBc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 20:32:57 -0500
Date: Thu, 21 Nov 2013 20:32:54 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'linux-arch-owner@vger.kernel.org'" 
	<linux-arch-owner@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-msm-owner@vger.kernel.org'" 
	<linux-arm-msm-owner@vger.kernel.org>
Subject: Re: bug report about assert at [ kernel/fs/jbd2/transaction.c:2138 ]
Message-ID: <20131122013254.GA5923@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"Wang, Yalin" <Yalin.Wang@sonymobile.com>,
	"'linux-arch-owner@vger.kernel.org'" <linux-arch-owner@vger.kernel.org>,
	"'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
	"'linux-arm-msm-owner@vger.kernel.org'" <linux-arm-msm-owner@vger.kernel.org>
References: <35FD53F367049845BC99AC72306C23D10194484B7BB2@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D10194484B7BB2@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 03:54:29PM +0800, Wang, Yalin wrote:
> 
> I have a crash on Android phone during daily use.
> 
> It crash at function __jbd2_journal_refile_buffer( ) :
> 
> if (jh->b_transaction)
> 		assert_spin_locked(&jh->b_transaction->t_journal->j_list_lock);
> 
> 
> I have a look at the code,
> Seems this part are all handled by kernel ,
> So should be kernel BUG ,
> 
> https://www.codeaurora.org/cgit/quic/la/kernel/msm/tree/fs/jbd2/commit.c?id=ccde7494b7174d810f316019b6e935fb222c6533

This commit ID references a truly antique kernel --- 2.6.29, dating
from January 9th, 2009.  There is saying that in Internet times, two
years is infinity.  So four years is two times infinity.  :-)

If the reason why Sony is still shipping kernels that are this anique
is because you are stuck on !@#!?! proprietary binaries brought to you
by the letters 'B' or the letters 'Q', may I suggest that you add to
your procurement contracts a requirement that your downstream hardware
providers provide open source drivers?

(I'll note that some of enterprise server providers have succesfully
leaned on their peripheral providers for host bus adapters and
networking cards that the drivers not only be open source, but have to
be accepted in the upstream kernel.  I'll gently suggest that handset
vendors first require in their procurement contracts that drivers at
the very least be open source, and then later, that said open source
drivers are accepted into the mainline kernel, since that way you
won't be responsible for forward porting out-of-tree drivers to
non-antique kernels.)

In any case, ext4 back in 2.6.29 had many bugs.  It's not something
that the open source community is going to be all that interested in
supporting.  Enterprise distributions pay long-suffering developers
$$$ to support ancient, old kernels.  My advice to not ship new
products with ancient kernels.

If in fact you aren't really using that ancient a kernel, you need to
let us know the precise version of the kernel you are using.

Best regards,

					- Ted
