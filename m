Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab3IYVaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:30:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab3IYVaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:30:11 -0400
Date: Wed, 25 Sep 2013 14:30:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Dave Jones <davej@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Chen Gang <gang.chen@asianux.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, mempolicy: make mpol_to_str robust and always
 succeed
Message-Id: <20130925143009.913fb1c042abe10d91c86c8b@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1309251057080.17676@chino.kir.corp.google.com>
References: <5215639D.1080202@asianux.com>
	<5227CF48.5080700@asianux.com>
	<alpine.DEB.2.02.1309241957280.26415@chino.kir.corp.google.com>
	<20130925031127.GA4210@redhat.com>
	<alpine.DEB.2.02.1309242012070.27940@chino.kir.corp.google.com>
	<20130925032530.GA4771@redhat.com>
	<alpine.DEB.2.02.1309251057080.17676@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013 10:58:27 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> On Tue, 24 Sep 2013, Dave Jones wrote:
> 
> >  > 	/* fall through */
> >  > 
> >  > for all of them would be pretty annoying.
> >  
> > agreed, but with that example, it seems pretty obvious (to me at least)
> > that the lack of break's is intentional.  Where it gets trickier to
> > make quick judgment calls is cases like the one I mentioned above,
> > where there are only a few cases, and there's real code involved in
> > some but not all cases.
> > 
> 
> I fully agree and have code in the oom killer that has the "fall through" 
> comment if there's code in between the case statements, but I think things 
> like
> 
> 	case MPOL_BIND:
> 	case MPOL_INTERLEAVE:
> 		...
> 
> is quite easy to read.  I don't feel strongly at all, though, so I'll just 
> leave it to Andrew's preference.

I've never even thought about it, but that won't prevent me from
pretending otherwise!  How about:

This:

	case WIBBLE:
		something();
		something_else();
	case WOBBLE:

needs a /* fall through */ comment (because it *looks* like a mistake),
whereas

	case WIBBLE:
	case WOBBLE:

does not?
