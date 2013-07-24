Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab3GXRgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:36:20 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36402 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752732Ab3GXRgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:36:16 -0400
Message-ID: <1374687373.7382.22.camel@dabdike>
Subject: Re: [PATCH] mm: Save soft-dirty bits on swapped pages
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 24 Jul 2013 10:36:13 -0700
In-Reply-To: <20130724171728.GH8508@moon>
References: <20130724160826.GD24851@moon>
	 <CALCETrXYnkonpBANnUuX+aJ=B=EYFwecZO27yrqcEU8WErz9DA@mail.gmail.com>
	 <20130724163734.GE24851@moon>
	 <CALCETrVWgSMrM2ujpO092ZLQa3pWEQM4vdmHhCVUohUUcoR8AQ@mail.gmail.com>
	 <20130724171728.GH8508@moon>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-24 at 21:17 +0400, Cyrill Gorcunov wrote:
> On Wed, Jul 24, 2013 at 10:06:53AM -0700, Andy Lutomirski wrote:
> > > Hi Andy, if I understand you correctly "file-backed pages" are carried
> > > in pte with _PAGE_FILE bit set and the swap soft-dirty bit won't be
> > > used on them but _PAGE_SOFT_DIRTY will be set on write if only I've
> > > not missed something obvious (Pavel?).
> > 
> > If I understand this stuff correctly, the vmscan code calls
> > try_to_unmap when it reclaims memory, which makes its way into
> > try_to_unmap_one, which clears the pte (and loses the soft-dirty bit).
> 
> Indeed, I was so stareing into swap that forgot about files. I'll do
> a separate patch for that, thanks!

Lets just be clear about the problem first: the vmscan pass referred to
above happens only on clean pages, so the soft dirty bit could only be
set if the page was previously dirty and got written back.  Now it's an
exercise for the reader whether we want to reinstantiate a cleaned
evicted page for the purpose of doing an iterative migration or whether
we want to flip the page in the migrated entity to be evicted (so if it
gets referred to, it pulls in an up to date copy) ... assuming the
backing file also gets transferred, of course.

James


