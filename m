Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbbA2F2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 00:28:37 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55702 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbbA2F2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 00:28:35 -0500
Date: Thu, 29 Jan 2015 14:28:27 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: Re: [PATCH v1 2/2] zram: remove init_lock in zram_make_request
Message-ID: <20150129052827.GB25462@blaptop>
References: <1422432945-6764-1-git-send-email-minchan@kernel.org>
 <1422432945-6764-2-git-send-email-minchan@kernel.org>
 <20150128145651.GB965@swordfish>
 <20150128233343.GC4706@blaptop>
 <CAHqPoqKZFDSjO1pL+ixYe_m_L0nGNcu04qSNp-jd1fUixKtHnw@mail.gmail.com>
 <20150129020139.GB9672@blaptop>
 <20150129022241.GA2555@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150129022241.GA2555@swordfish>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2015 at 11:22:41AM +0900, Sergey Senozhatsky wrote:
> On (01/29/15 11:01), Minchan Kim wrote:
> > On Thu, Jan 29, 2015 at 10:57:38AM +0900, Sergey Senozhatsky wrote:
> > > On Thu, Jan 29, 2015 at 8:33 AM, Minchan Kim <minchan@kernel.org> wrote:
> > > > On Wed, Jan 28, 2015 at 11:56:51PM +0900, Sergey Senozhatsky wrote:
> > > > > I don't like re-introduced ->init_done.
> > > > > another idea... how about using `zram->disksize == 0' instead of
> > > > > `->init_done' (previously `->meta != NULL')? should do the trick.
> > > >
> > > > It could be.
> > > >
> > > >
> > > care to change it?
> > 
> > Will try!
> > 
> > If it was your concern, I'm happy to remove the check.(ie, actually,
> > I realized that after I push the button to send). Thanks!
> > 
> 
> Thanks a lot, Minchan.
> 
> and, guys, sorry for previous html email (I'm sure I toggled the "plain
> text" mode in gmail web-interface, but somehow it has different meaning
> in gmail world).
> 
> 
> I'm still concerned about performance numbers that I see on my x86_64.
> it's not always, but mostly slower. I'll give it another try (disable
> lockdep, etc.), but if we lose 10% on average then, sorry, I'm not so
> positive about srcu change and will tend to vote for your initial commit
> that simply moved meta free() out of init_lock and left locking as is
> (lockdep warning would have been helpful there, because otherwise it
> just looked like we change code w/o any reason).
> 
> what do you thunk?

Surely I agreee with you. If it suffers from 10% performance regression,
it's absolutely no go.

However, I believe it should be no loss because that's one of the reason
from RCU birth which should be really win in read-side lock path compared
to other locking.

Please test it with dd or something for block-based test for removing
noise from FS. I also will test it to confirm that with real machine.

Thanks for the review!



> 
> 	-ss

-- 
Kind regards,
Minchan Kim
