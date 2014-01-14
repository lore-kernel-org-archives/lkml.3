Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaANEss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 23:48:48 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:64114 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaANEsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 23:48:45 -0500
Date: Mon, 13 Jan 2014 20:48:41 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hugh Dickins <hughd@google.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shli@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: next bio iters break discard?
Message-ID: <20140114044841.GO9037@kmo>
References: <alpine.LSU.2.11.1401121909160.1239@eggly.anvils>
 <20140114023346.GN9037@kmo>
 <yq161pnmcl2.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq161pnmcl2.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 11:06:33PM -0500, Martin K. Petersen wrote:
> >>>>> "Kent" == Kent Overstreet <kmo@daterainc.com> writes:
> 
> Kent,
> 
> Kent> I think for discards we can deal with this easily enough -
> Kent> __blk_recalc_rq_segments() will have to special case them - but
> Kent> there's a similar (but worse) issue with WRITE_SAME, and looking
> Kent> at the code it does attempt to merge WRITE_SAME requests too.
> 
> DISCARD bios have no payload going down the stack. They get a payload
> attached in the sd driver and will therefore have a single bvec at
> completion time.
> 
> WRITE_SAME bios have a single bvec payload throughout their lifetime.
> 
> For both these types of requests we never attempt to merge the actual
> payloads. But the block range worked on may shrink or grow as the bio is
> split or merged going down the stack.
> 
> IOW, DISCARD, WRITE SAME and the impending COPY requests do not have a
> 1:1 mapping between the block range worked on and the size of any bvecs
> attached. Your recent changes must have changed the way we handled that
> in the past.

Yeah - but with WRITE_SAME bios, wouldn't we at least have to check that they're
writing the same data to merge them?
