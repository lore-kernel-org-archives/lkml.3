Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab3BCRCr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 12:02:47 -0500
Received: from fieldses.org ([174.143.236.118]:39338 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659Ab3BCRCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 12:02:44 -0500
Date: Sun, 3 Feb 2013 12:02:41 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk
Subject: Re: [PATCHSET] idr: implement idr_alloc() and convert existing users
Message-ID: <20130203170241.GA24778@fieldses.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2013 at 05:20:01PM -0800, Tejun Heo wrote:
> * Bruce, I couldn't convert nfsd.  Can you please help?  More on it
>   later.
...
> I converted all in-kernel users except nfsd and staging drivers.  nfsd
> splits preloading and actual id allocation in a way that per-cpu
> preloading can't be used.  I couldn't follow the control flow to
> verify whether the current code is correct either.  I think the best
> way would be allocating ID upfront without installing the handle and
> then later using idr_replace() to install the pointer when the ID
> actually gets used.  Bruce, would something like that be possible?

Actually, I'm not even sure if that's necessary, we can probably just
do it all at the start.

I'll try to have a patch doing that tomorrow.

--b.
