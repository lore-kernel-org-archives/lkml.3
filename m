Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab3HUQj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:39:27 -0400
Received: from kanga.kvack.org ([205.233.56.17]:59171 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab3HUQj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:39:26 -0400
Date: Wed, 21 Aug 2013 12:39:25 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, linux-aio@kvack.org
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
Message-ID: <20130821163925.GI13330@kvack.org>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com> <20130821130231.GG13330@kvack.org> <5214EB1E.5050407@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5214EB1E.5050407@oracle.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 11:30:22AM -0500, Dave Kleikamp wrote:
> Ben,
> First, let me apologize for neglecting to copy you and linux-aio on the
> applicable patches. I've been carrying along this patchset, assuming I
> had gotten the proper cc's correct a while back, but I somehow missed
> the aio pieces.

Thanks.  Let's figure out how to tackle this best.

> On 08/21/2013 08:02 AM, Benjamin LaHaise wrote:
...
> > First off, have you tested that this series actually works when merged with 
> > the pending AIO changes from Kent?  There a git tree with those pending 
> > changes at git://git.kvack.org/~bcrl/aio-next.git , and they're in 
> > linux-next.
> 
> I've lightly tested the patchset against the linux-next tree, running a
> fio job on loop-mounted filesystems of different fs types.

Good to hear.
> 
> > One of the major problems your changeset continues to carry is that your 
> > new read_iter/write_iter operations permit blocking (implicitely), which 
> > really isn't what we want for aio.  If you're going to introduce a new api, 
> > it should be made non-blocking, and enforce that non-blocking requirement 
> > (ie warn when read_iter/write_iter methods perform blockin operations, 
> > similar to the warnings when scheduling in atomic mode).  This means more 
> > changes for some filesystem code involved, something that people have been 
> > avoiding for years, but which really needs to be done.
> 
> I'm not really sure how the read_iter and write_iter operations are more
> likely to block than the current aio_read and aio_write operations. Am I
> missing something?

What you say is true, however, my point is more that it will be far easier 
to fix this issue by making it a hard constraint of a new API than it is 
to do a system-wide retrofit.  You're converting code over to use the new 
API one by one, so adding a little bit more work to try and finally sort 
out this issue while making those conversions would be vrey helpful.

I'm not saying that you should be required to write the code to cope with 
this additional requirement (I'm perfectly happy to help with that, and 
can probably get some time for that at $work), but more that if we're 
going to be changing all of the filesystems, we might as well try to get 
things right.

		-ben

> Thanks,
> Dave

-- 
"Thought is the essence of where you are now."
