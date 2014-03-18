Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbaCRAWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 20:22:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:57397 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbaCRAWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 20:22:44 -0400
Message-ID: <1395102146.15098.198.camel@pasglop>
Subject: Re: linux-next: build failure after merge of the driver-core tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@kernel.org>,
        Stewart Smith <stewart@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 18 Mar 2014 11:22:26 +1100
In-Reply-To: <20140317222107.GH17373@mtj.dyndns.org>
References: <20140312005152.9ac4063f65dbd233f5d50b4d@kernel.org>
	 <20140312015021.GC10106@kroah.com>
	 <20140317101611.d043a90e1cb72dcfb8bc767a@canb.auug.org.au>
	 <20140317183333.GE10565@kroah.com> <1395088410.15098.175.camel@pasglop>
	 <20140317215619.GA25228@kroah.com> <20140317220554.GG17373@mtj.dyndns.org>
	 <20140317222107.GH17373@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-17 at 18:21 -0400, Tejun Heo wrote:
> So, looked at the failed code.  The only necessary change seems to be
> calling device_remove_file_self() in dump_ack_store() and then doing
> kobject_put() directly afterwards, which would have been completely
> fine as a merge fix patch.

Ok. Since there's no merge error, I'll have to tell Linus explicitly to
apply it during the merge. I've never done that before but I suppose
it's doable.

> Just to be clear, I'm not necessarily against reverting the removal of
> the API.  The removal was based on the speculation that this isn't
> likely to cause trouble.  The speculation was perfectly reasonable but
> being a speculation it failed, so we take actions to remedy that and
> we *do* want to do things that way.  Reverting the removal can sure be
> one choice but the way that choice is being made here seems completely
> wrong to me.  There's no technical evaluation whatsoever.  I'd really
> hate to work in an environment where taking active trade off is
> discouraged replaced with blind policy enforcement.

Sorry I don't understand. Reverting the removal until after -rc1 (or
later in the merge window) is the easiest path from my perspective and
ensure no bisection breakage but whatever Linus prefers works here.

I don't think it's a drastic action or anything like that. It can
trivially be re-applied once the merge window has settled. But I'm happy
to also just send Linus a "apply this as a merge fixup" patch if he's
happy with the method (as I said, I've never done that before on
something that doesn't have an actual merge conflict to begin with)

Cheers,
Ben.


