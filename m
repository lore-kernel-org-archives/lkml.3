Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841Ab3CZQgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:36:47 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:55496 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab3CZQgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:36:45 -0400
Date: Tue, 26 Mar 2013 09:36:35 -0700
From: Tejun Heo <tj@kernel.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@redhat.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk
Subject: Re: [PATCHSET] idr: implement idr_alloc() and convert existing users
Message-ID: <20130326163635.GC3061@htj.dyndns.org>
References: <20130203170241.GA24778@fieldses.org>
 <20130204001557.GB24778@fieldses.org>
 <20130204171031.GK27963@mtj.dyndns.org>
 <20130204171128.GL27963@mtj.dyndns.org>
 <20130321140618.GD27838@fieldses.org>
 <20130321183513.GC20500@htj.dyndns.org>
 <20130326111936.550110bf@tlielax.poochiereds.net>
 <20130326152653.GA3061@htj.dyndns.org>
 <20130326163011.GC3353@fieldses.org>
 <20130326163351.GB3061@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326163351.GB3061@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 09:33:51AM -0700, Tejun Heo wrote:
> not be too bad.  The optimal would be bitmap + hashtable, I suppose.

Oops, with more restricted (or at least dynamically adjusted) ID
space, that is.

The problem with idr is that it can get pretty wasteful if the IDs
become very scattered - the worst case being one ID per each idr_layer
(the internal allocation block).  That said, even cyclic allocation
should yield somewhat clustered IDs, so I don't think it'd be too bad.

Thanks.

-- 
tejun
