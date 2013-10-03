Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab3JCR0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:26:25 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52258 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754245Ab3JCR0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:26:24 -0400
X-Sasl-enc: jJm5MelmvZp439yXDaq66vcJMOM0pFvfj9Ht1jxsNEwa 1380821182
Date: Thu, 3 Oct 2013 10:26:21 -0700
From: Greg KH <greg@kroah.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <andreas.dilger@intel.com>,
        Peng Tao <tao.peng@emc.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Nikita Danilov <nikita@clusterfs.com>
Subject: Re: lustre: why does cfs_get_random_bytes() exist?
Message-ID: <20131003172621.GA14775@kroah.com>
References: <20131003163908.GD31721@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003163908.GD31721@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 12:39:08PM -0400, Theodore Ts'o wrote:
> I've been auditing uses of get_random_bytes() since there are places
> where get_random_bytes() is getting used where something weaker, such
> as prandom_u32() is quite sufficient.  Basically, if kernel code just
> needs a random number which does not have any cryptographic
> requirements (such as in ext[234]. which gets the new block group used
> for inode allocations using get_random_bytes), then prandom_u32()
> should be used instead of get_random_bytes() to save CPU overhead and
> to reduce the drain on the /dev/urandom's entropy pool.
> 
> Typically, the reason for this is either for historical reasons, since
> prandom_u32() hadn't existed when the code was written, or because
> historical code was cut and pasted into newer code.
> 
> When I came across staging/lustre/lustre/libcfs/prng.c, I saw
> something which is **really** weird.  It defines a cfs_rand() which is
> functionally identical to prandom_u32().  More puzzlingly, it also
> defines cfs_get_random_bytes() which calls get_random_bytes() and then
> xor's the result with cfs_rand().  That last step has no cryptographic
> effect, so I'm really wondering who thought this as a good idea and/or
> necessary.
> 
> What I think should happen is that staging/lustre/lustre/libcfs/prng.c
> should be removed, and calls to cfs_rand() should get replaced
> prandom_u32(), and cfs_get_random_bytes() should get replaced with
> get_random_bytes().
> 
> Does this sound reasonable?

Sounds reasonable to me, care to send a patch to do so?

thanks,

greg k-h
