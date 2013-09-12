Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab3ILH66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 03:58:58 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30635 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab3ILH65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 03:58:57 -0400
Date: Thu, 12 Sep 2013 10:57:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Kees Cook <keescook@chromium.org>, Joe Perches <joe@perches.com>,
        David Miller <davem@davemloft.net>, Eldad Zack <eldad@fogrefinery.com>,
        George Spelvin <linux@horizon.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vsprintf: drop comment claiming %n is ignored
Message-ID: <20130912075756.GG19256@mwanda>
References: <20130911193040.GA16688@www.outflux.net>
 <1378929961.4714.21.camel@joe-AO722>
 <CAGXu5jKRmp_Ei=ty05W3SSqQ01agEMDVMGnZCFqQ_yYbZmMSmw@mail.gmail.com>
 <5231836102000078000F29AD@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5231836102000078000F29AD@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 08:03:29AM +0100, Jan Beulich wrote:
> >>> On 11.09.13 at 22:18, Kees Cook <keescook@chromium.org> wrote:
> > On Wed, Sep 11, 2013 at 1:06 PM, Joe Perches <joe@perches.com> wrote:
> >> On Wed, 2013-09-11 at 12:30 -0700, Kees Cook wrote:
> >>> The %n format is not ignored, so remove the incorrect comment about it.
> >>
> >> I think it may be better to reimplement the ignoring.
> > 
> > Yeah, just had a quick look, and scanf doesn't use this code at all.
> > I'd much rather remove %n again instead.
> 
> Why would you want to artificially make the function diverge
> from the spec? People shouldn't be caught by surprises if at all
> possible, and one can certainly not expect people to go look at
> the comment before the function implementation to find out
> what basic (standard) features _do not_ work (one can expect
> so when trying to find out about _extensions_).
> 
> Jan

Actually it's the reverse.  I was expecting that %n would be ignored
from the start.  Then I looked at the file and the comment said that
%n was ignored.  It's only Kees who looked at the actual code and saw
that it wasn't being ignored since 2009.

Kees has been fixing format strings bugs in the past few months and
there are probably other out of tree drivers where this bug is still
exploitable.  It's quite serious.

regards,
dan carpenter
