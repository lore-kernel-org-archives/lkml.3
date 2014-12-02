Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933951AbaLBT30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:29:26 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62174 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932962AbaLBT3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:29:24 -0500
Date: Tue, 2 Dec 2014 14:29:20 -0500
From: Tejun Heo <tj@kernel.org>
To: Jeff Layton <jeff.layton@primarydata.com>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 00/14] nfsd/sunrpc: add support for a workqueue-based
 nfsd
Message-ID: <20141202192920.GM10918@htj.dyndns.org>
References: <1417544663-13299-1-git-send-email-jlayton@primarydata.com>
 <20141202191814.GK10918@htj.dyndns.org>
 <20141202142627.6f59f693@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141202142627.6f59f693@tlielax.poochiereds.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jeff.

On Tue, Dec 02, 2014 at 02:26:27PM -0500, Jeff Layton wrote:
> I'm already using WQ_UNBOUND workqueues. If that exempts this code from
> the concurrency management, then that's probably not the problem. The
> jobs here aren't terribly CPU intensive, but they can sleep for a long
> time while waiting on I/O, etc...

Yeap, noticed that.  Replied in another message.

> I don't think we necessarily need CPU locality (though that's nice to
> have of course), but NUMA affinity will likely be important. It looked
> like you had done some work a year or so ago to make unbound workqueues
> prefer to queue work on the same NUMA node which meshes nicely with
> what I think we want for this.

Yeap, unbound workqueues are NUMA-affine by default.

Thanks.

-- 
tejun
