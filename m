Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab3JTPWw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 11:22:52 -0400
Received: from smtprelay0194.hostedemail.com ([216.40.44.194]:40646 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751061Ab3JTPWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 11:22:51 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:2895:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3867:3870:3871:3872:3873:3874:4250:4321:5007:6120:7652:7903:7974:10004:10400:10450:10455:10848:11232:11658:11914:12043:12295:12438:12517:12519:12555:12740:13069:13311:13357:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:n
X-HE-Tag: joke43_52be253e05c33
X-Filterd-Recvd-Size: 2721
Message-ID: <1382282566.2041.39.camel@joe-AO722>
Subject: Re: [RFC PATCH] device: Add kernel standard devm_k.alloc functions
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kevin Hilman <khilman@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sangjung Woo <sangjung.woo@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Date: Sun, 20 Oct 2013 08:22:46 -0700
In-Reply-To: <20131020025713.GA22344@kroah.com>
References: <1381296747.2040.17.camel@joe-AO722>
	 <20131011131138.3bc5b2acf60df3a5d79d0d24@linux-foundation.org>
	 <CAGa+x864VYoGvOxoK0XnxXH9hKNq9WAZ16XHiFawZY7_2WJttw@mail.gmail.com>
	 <CAGa+x86aS+C8iEb1P4ZYxPBix=Anjh4JZoAof=R-i9fGw=bq6w@mail.gmail.com>
	 <20131018225702.GA13090@kroah.com> <8761stu7rl.fsf@linaro.org>
	 <20131020025713.GA22344@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-10-19 at 19:57 -0700, Greg KH wrote:
> On Fri, Oct 18, 2013 at 10:52:46PM -0700, Kevin Hilman wrote:
> > Greg KH <gregkh@linuxfoundation.org> writes:
> > 
> > > On Fri, Oct 18, 2013 at 10:04:11AM -0700, Kevin Hilman wrote:
> > >> > A handful of boot panics on ARM platforms were bisected to point at
> > >> > the version of this commit that's in linux-next (commit
> > >> > 64c862a839a8db2c02bbaa88b923d13e1208919d).  Reverting this commit
> > >> > makes things happy again.
> > >> >
> > >> > Upon further digging, it seems that users of devres_alloc() are
> > >> > relying on the previous behavior of having the memory zero'd which is
> > >> > no longer the case after $SUBJECT patch.  The change below on top of
> > >> > -next makes these ARM boards happy again.
> > >> 
> > >> Oops, it should've fixed __devres_alloc() also.  Updated patch below.
> > >
> > > Can you send this in a format that I can apply it in?  It was whitespace
> > > damaged.
> > 
> > hmm, sorry about that.  This one should work, though I wonder if Andrew
> > should pick this up since I think the patch that causes the breakage
> > came through his tree.
> 
> No, the patch is in my tree, not Andrew's.
> 
> Joe, can I get a signed-off-by for this?

If you want.

Signed-off-by: Joe Perches <joe@perches.com>


