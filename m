Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab3CUSfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:35:19 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:46238 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3CUSfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:35:17 -0400
Date: Thu, 21 Mar 2013 11:35:13 -0700
From: Tejun Heo <tj@kernel.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk,
        jlayton@redhat.com
Subject: Re: [PATCHSET] idr: implement idr_alloc() and convert existing users
Message-ID: <20130321183513.GC20500@htj.dyndns.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <20130203170241.GA24778@fieldses.org>
 <20130204001557.GB24778@fieldses.org>
 <20130204171031.GK27963@mtj.dyndns.org>
 <20130204171128.GL27963@mtj.dyndns.org>
 <20130321140618.GD27838@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321140618.GD27838@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Mar 21, 2013 at 10:06:18AM -0400, J. Bruce Fields wrote:
> > Ooh, BTW, the cyclic allocation is broken.  It's prone to -ENOSPC
> > after the first wraparound.  There are several cyclic users in the
> > kernel and I think it probably would be best to implement cyclic
> > support in idr.
> 
> Are you looking at this, by the way, or do you have any suggestions?
> 
> Wondering if it's something I should try to fix or if I should look into
> converting to some other data structure here.

I am not working on it at the moment but I think the logical thing to
do would be implementing cyclic support in idr and enabling it with,
say, a different initializer - IDR_CYCLIC_INIT() or something.  If you
wanna fix it, please go ahead. :)

Thanks.

-- 
tejun
