Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759646AbaD3XiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 19:38:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49605 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbaD3XiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 19:38:08 -0400
Date: Thu, 1 May 2014 00:38:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140430233805.GW18016@ZenIV.linux.org.uk>
References: <20140430183650.GQ18016@ZenIV.linux.org.uk>
 <CAJfpegu+=zidycJwcBPjuDLP-ZnGisOGQpD8GKhD-Wz6eNzd9g@mail.gmail.com>
 <20140430190227.GR18016@ZenIV.linux.org.uk>
 <20140430195918.GS18016@ZenIV.linux.org.uk>
 <CA+55aFxe4HKHiWbarfwtww9=WUgfAmk+Cf3G7tdBB19uMdjbEg@mail.gmail.com>
 <20140430203823.GT18016@ZenIV.linux.org.uk>
 <CA+55aFyqqwrtv7ifTYVK943qm2OJOF8aF1y6apMSwjG93T=ztA@mail.gmail.com>
 <20140430211206.GU18016@ZenIV.linux.org.uk>
 <20140430221238.GV18016@ZenIV.linux.org.uk>
 <CA+55aFzekh6peA627B1e3NwcL06DqErWX6whJGm4w0WDRTn1gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzekh6peA627B1e3NwcL06DqErWX6whJGm4w0WDRTn1gA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 04:04:58PM -0700, Linus Torvalds wrote:
> On Wed, Apr 30, 2014 at 3:12 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > I've just pushed the whole thing to vfs.git#for-linus;
> > review and testing would be very welcome.
> 
> I have no half-way relevant test-case for this, so I'm hoping people
> who have good VFS stress-tests (preferably under memory pressure so
> that we get that whole shrinking path) will test.
> 
> But it looks fine.
> 
> That said, I do hate that RCU read-lock around the final spin-unlock.

So do I, obviously...  After looking through the rest of arch_spin_unlock(),
it looks like the only suspicious one except the paravirt on x86 is
blackfin.  And that might be misreading - I'm not familiar enough with the
architecture to tell...
