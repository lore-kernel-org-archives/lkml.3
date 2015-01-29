Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933715AbbA2CWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:22:48 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49268 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718AbbA2CWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:22:44 -0500
Date: Thu, 29 Jan 2015 11:22:41 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Ganesh Mahendran <opensource.ganesh@gmail.com>,
        sergey.senozhatsky.work@gmail.com
Subject: Re: [PATCH v1 2/2] zram: remove init_lock in zram_make_request
Message-ID: <20150129022241.GA2555@swordfish>
References: <1422432945-6764-1-git-send-email-minchan@kernel.org>
 <1422432945-6764-2-git-send-email-minchan@kernel.org>
 <20150128145651.GB965@swordfish>
 <20150128233343.GC4706@blaptop>
 <CAHqPoqKZFDSjO1pL+ixYe_m_L0nGNcu04qSNp-jd1fUixKtHnw@mail.gmail.com>
 <20150129020139.GB9672@blaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150129020139.GB9672@blaptop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/29/15 11:01), Minchan Kim wrote:
> On Thu, Jan 29, 2015 at 10:57:38AM +0900, Sergey Senozhatsky wrote:
> > On Thu, Jan 29, 2015 at 8:33 AM, Minchan Kim <minchan@kernel.org> wrote:
> > > On Wed, Jan 28, 2015 at 11:56:51PM +0900, Sergey Senozhatsky wrote:
> > > > I don't like re-introduced ->init_done.
> > > > another idea... how about using `zram->disksize == 0' instead of
> > > > `->init_done' (previously `->meta != NULL')? should do the trick.
> > >
> > > It could be.
> > >
> > >
> > care to change it?
> 
> Will try!
> 
> If it was your concern, I'm happy to remove the check.(ie, actually,
> I realized that after I push the button to send). Thanks!
> 

Thanks a lot, Minchan.

and, guys, sorry for previous html email (I'm sure I toggled the "plain
text" mode in gmail web-interface, but somehow it has different meaning
in gmail world).


I'm still concerned about performance numbers that I see on my x86_64.
it's not always, but mostly slower. I'll give it another try (disable
lockdep, etc.), but if we lose 10% on average then, sorry, I'm not so
positive about srcu change and will tend to vote for your initial commit
that simply moved meta free() out of init_lock and left locking as is
(lockdep warning would have been helpful there, because otherwise it
just looked like we change code w/o any reason).

what do you thunk?

	-ss
