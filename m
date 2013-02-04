Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab3BDSPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 13:15:42 -0500
Received: from fieldses.org ([174.143.236.118]:51246 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab3BDSPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 13:15:41 -0500
Date: Mon, 4 Feb 2013 13:15:37 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk
Subject: Re: [PATCHSET] idr: implement idr_alloc() and convert existing users
Message-ID: <20130204181537.GL815@fieldses.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <20130203170241.GA24778@fieldses.org>
 <20130204001557.GB24778@fieldses.org>
 <20130204171031.GK27963@mtj.dyndns.org>
 <20130204171128.GL27963@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204171128.GL27963@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 09:11:28AM -0800, Tejun Heo wrote:
> On Mon, Feb 04, 2013 at 09:10:31AM -0800, Tejun Heo wrote:
> > Yeah, that should be easily convertable to the new interface.  How
> > should we route these changes?  Your patch can go through the usual
> > nfs channel and the conversion and deprecation patches can be held off
> > until after -rc1.  Does that sound okay?
> 
> Ooh, BTW, the cyclic allocation is broken.  It's prone to -ENOSPC
> after the first wraparound.  There are several cyclic users in the
> kernel and I think it probably would be best to implement cyclic
> support in idr.

Ugh.  OK, well it'll take some work to wrap that around, so it's
probably not urgent for nfsd.

--b.
