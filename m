Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3BDRKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 12:10:39 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:61660 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab3BDRKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 12:10:38 -0500
Date: Mon, 4 Feb 2013 09:10:31 -0800
From: Tejun Heo <tj@kernel.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk
Subject: Re: [PATCHSET] idr: implement idr_alloc() and convert existing users
Message-ID: <20130204171031.GK27963@mtj.dyndns.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <20130203170241.GA24778@fieldses.org>
 <20130204001557.GB24778@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204001557.GB24778@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Sun, Feb 03, 2013 at 07:15:58PM -0500, J. Bruce Fields wrote:
> On Sun, Feb 03, 2013 at 12:02:41PM -0500, J. Bruce Fields wrote:
> > On Sat, Feb 02, 2013 at 05:20:01PM -0800, Tejun Heo wrote:
> > > * Bruce, I couldn't convert nfsd.  Can you please help?  More on it
> > >   later.
> > ...
> > > I converted all in-kernel users except nfsd and staging drivers.  nfsd
> > > splits preloading and actual id allocation in a way that per-cpu
> > > preloading can't be used.  I couldn't follow the control flow to
> > > verify whether the current code is correct either.  I think the best
> > > way would be allocating ID upfront without installing the handle and
> > > then later using idr_replace() to install the pointer when the ID
> > > actually gets used.  Bruce, would something like that be possible?
> > 
> > Actually, I'm not even sure if that's necessary, we can probably just
> > do it all at the start.
> > 
> > I'll try to have a patch doing that tomorrow.
> 
> So, something like this.

Yeah, that should be easily convertable to the new interface.  How
should we route these changes?  Your patch can go through the usual
nfs channel and the conversion and deprecation patches can be held off
until after -rc1.  Does that sound okay?

Thanks.

-- 
tejun
