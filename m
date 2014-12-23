Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbaLWPL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 10:11:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862AbaLWPL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 10:11:27 -0500
Date: Tue, 23 Dec 2014 09:10:56 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: livepatching tree for linux-next
Message-ID: <20141223151056.GA4789@treble.redhat.com>
References: <alpine.LNX.2.00.1412221412360.1680@pobox.suse.cz>
 <20141223094607.GA16445@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141223094607.GA16445@infradead.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 01:46:07AM -0800, Christoph Hellwig wrote:
> On Mon, Dec 22, 2014 at 08:52:02PM +0100, Jiri Kosina wrote:
> > Hi Stephen,
> > 
> > a substantial amount of work has been invested into abstracing "Live 
> > Patching" core functionality out of the already existing implementations, 
> > so that further improvements can be built on top of it in incremental 
> > steps.
> > 
> > The core functionality (which is self-contained) now works and has been 
> > Reviewed/Acked by both interested parties (i.e. people working on kPatch 
> > and kGraft) and agreed to be a common ground on which further development 
> > will happen.
> > 
> > We plan to send a pull request for 3.20, therefore I'd like to ask you to 
> > include 'for-next' branch of
> 
> This is still missing the actual patch generators, which should be
> merged together with the code, otherwise we'll get a mess with forever
> out of tree tools like systemtap again.

Well, a patch generator isn't required.  You can build a patch module
from source with kbuild, just like you would for any other kernel
module.  This is what kGraft already does today.  For example:

   https://git.kernel.org/cgit/linux/kernel/git/jikos/livepatching.git/commit/?h=for-next&id=13d1cf7e702596e0cd8ec62afa6bd49c431f2d0c

We do want to add a generator, but there are two of them out there that
need to be converged.  It doesn't make sense to do that work until we
have first converged the rest of the stack (namely, consistency models).
That's our next step.

The current code is by no means a final product, but it's still quite
useful already.

-- 
Josh
