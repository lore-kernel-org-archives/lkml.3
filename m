Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaCQVyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 17:54:21 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33825 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634AbaCQVyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 17:54:19 -0400
X-Sasl-enc: 9vv6/ES/yezOU0WVfjZfheytKNnML24tvmNJ01VQ0DPP 1395093258
Date: Mon, 17 Mar 2014 14:56:19 -0700
From: Greg KH <greg@kroah.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Mark Brown <broonie@kernel.org>,
        Stewart Smith <stewart@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20140317215619.GA25228@kroah.com>
References: <20140312005152.9ac4063f65dbd233f5d50b4d@kernel.org>
 <20140312015021.GC10106@kroah.com>
 <20140317101611.d043a90e1cb72dcfb8bc767a@canb.auug.org.au>
 <20140317183333.GE10565@kroah.com>
 <1395088410.15098.175.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395088410.15098.175.camel@pasglop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 07:33:30AM +1100, Benjamin Herrenschmidt wrote:
> On Mon, 2014-03-17 at 11:33 -0700, Greg KH wrote:
> 
> > There were only 3 (or 4), users of this api, and no new ones had been
> > added in _years_, it's a very obscure thing, and odds are, it wouldn't
> > ever be added again, especially as it was just removed entirely not
> > being needed anymore.  And I'd argue, it's something that you shouldn't
> > have even been doing in the first place, so why a new user of it was
> > added now is quite strange to me.
> 
> Actually that's a good question. Is there a better way for us than to
> use this API ? Essentially we use that because it's our understanding
> that it is what is needed for a sysfs file that can remove its parent
> directory from within a write() op.
> 
> We followed the driver "remove" implementation as an example.
> 
> The reason the opal elog and dump patches use it is that those two
> patches add sysfs interface that represent the error logs (and platform
> dumps but you can treat the latter as some kind of special case of error
> logs) from the service processor in sysfs.
> 
> So for each log we create a dir (kobject) which we populate with a few
> things like the log unique ID, raw data, etc.... and a file that can be
> used to "ack" the log with the service processor.
> 
> The latter has the effect of removing it. This is done by the collection
> daemon after it has confirmed that the error log has been stored to disk
> and properly flushed.
> 
> Is there a better interface ? Can we implement for example unlink() on
> the kobject itself ? IE. Do the ack by essentially having userspace rm
> the directory ? :-)

No you can't, sorry.

And this seems like a huge abuse of sysfs, you better be using binary
sysfs files for your log data...

Do you have a pointer to where you document this sysfs api in
Documentation/ABI/ ?

> Now regarding the practicals of sorting out our trees, Stephen suggested
> that rather than doing anything on my side (heh, I like that !), you
> should revert the last patch of the series, the one removing the old
> API, in your tree.
> 
> It can then be re-applied later around rc1.

I'll look to see if we can do that, let me dig it up out of my tree...

thanks,

greg k-h
