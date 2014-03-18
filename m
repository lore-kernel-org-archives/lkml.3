Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbaCRP7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:59:04 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:47730 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbaCRP7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:59:01 -0400
Date: Tue, 18 Mar 2014 11:58:57 -0400
From: Tejun Heo <tj@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@kernel.org>,
        Stewart Smith <stewart@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20140318155857.GB3642@htj.dyndns.org>
References: <20140312005152.9ac4063f65dbd233f5d50b4d@kernel.org>
 <20140312015021.GC10106@kroah.com>
 <20140317101611.d043a90e1cb72dcfb8bc767a@canb.auug.org.au>
 <20140317183333.GE10565@kroah.com>
 <1395088410.15098.175.camel@pasglop>
 <20140317215619.GA25228@kroah.com>
 <20140317220554.GG17373@mtj.dyndns.org>
 <20140317222107.GH17373@mtj.dyndns.org>
 <1395102146.15098.198.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395102146.15098.198.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ben.

On Tue, Mar 18, 2014 at 11:22:26AM +1100, Benjamin Herrenschmidt wrote:
> On Mon, 2014-03-17 at 18:21 -0400, Tejun Heo wrote:
> > So, looked at the failed code.  The only necessary change seems to be
> > calling device_remove_file_self() in dump_ack_store() and then doing
> > kobject_put() directly afterwards, which would have been completely
> > fine as a merge fix patch.
> 
> Ok. Since there's no merge error, I'll have to tell Linus explicitly to
> apply it during the merge. I've never done that before but I suppose
> it's doable.

Yeah, that should be fine.  For the next tree, including the fix patch
in a temp branch and pulling that into your for-next branch should
work fine.

> Sorry I don't understand. Reverting the removal until after -rc1 (or
> later in the merge window) is the easiest path from my perspective and
> ensure no bisection breakage but whatever Linus prefers works here.

Merge fix doesn't cause any bisection issue either (because it *is* a
merge problem after all).  It could be just my personal preference but
I'd handle this one as merge fix.  If we rever the removal of the
interface, we'll probably need to mark it deprecated too as people
tend to fork off their devel branches before or at rc1.

> I don't think it's a drastic action or anything like that. It can
> trivially be re-applied once the merge window has settled. But I'm happy
> to also just send Linus a "apply this as a merge fixup" patch if he's
> happy with the method (as I said, I've never done that before on
> something that doesn't have an actual merge conflict to begin with)

Sure, either should work.

Thanks.

-- 
tejun
