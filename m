Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbbATJsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:48:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:59199 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbbATJsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:48:09 -0500
Date: Tue, 20 Jan 2015 10:48:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrey Tsyvarev <tsyvarev@ispras.ru>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] kernel/module.c: Free lock-classes if parse_args failed
Message-ID: <20150120094805.GB11596@twins.programming.kicks-ass.net>
References: <1421216708-1975-1-git-send-email-tsyvarev@ispras.ru>
 <87iog2arfk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iog2arfk.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 05:07:19PM +1030, Rusty Russell wrote:
> Andrey Tsyvarev <tsyvarev@ispras.ru> writes:
> > parse_args call module parameters' .set handlers, which may use locks defined in the module.
> > So, these classes should be freed in case parse_args returns error(e.g. due to incorrect parameter passed).
> 
> Thanks, this seems right.  Applied.
> 
> But this makes me ask: where is lockdep_free_key_range() called on the
> module init code?  It doesn't seem to be at all...

Hmm, Ingo, how does this work? The lockless class lookup in
look_up_lock_class() very much assumes the class hash is only added too,
but here we go wipe stuff from it.

>From what I can tell, every use of lockdep_free_key_range() is broken.
