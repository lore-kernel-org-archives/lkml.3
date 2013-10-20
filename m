Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab3JTHio (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 03:38:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab3JTHim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 03:38:42 -0400
Date: Sat, 19 Oct 2013 19:57:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Sangjung Woo <sangjung.woo@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] device: Add kernel standard devm_k.alloc functions
Message-ID: <20131020025713.GA22344@kroah.com>
References: <1381296747.2040.17.camel@joe-AO722>
 <20131011131138.3bc5b2acf60df3a5d79d0d24@linux-foundation.org>
 <CAGa+x864VYoGvOxoK0XnxXH9hKNq9WAZ16XHiFawZY7_2WJttw@mail.gmail.com>
 <CAGa+x86aS+C8iEb1P4ZYxPBix=Anjh4JZoAof=R-i9fGw=bq6w@mail.gmail.com>
 <20131018225702.GA13090@kroah.com>
 <8761stu7rl.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761stu7rl.fsf@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 10:52:46PM -0700, Kevin Hilman wrote:
> Greg KH <gregkh@linuxfoundation.org> writes:
> 
> > On Fri, Oct 18, 2013 at 10:04:11AM -0700, Kevin Hilman wrote:
> >> > A handful of boot panics on ARM platforms were bisected to point at
> >> > the version of this commit that's in linux-next (commit
> >> > 64c862a839a8db2c02bbaa88b923d13e1208919d).  Reverting this commit
> >> > makes things happy again.
> >> >
> >> > Upon further digging, it seems that users of devres_alloc() are
> >> > relying on the previous behavior of having the memory zero'd which is
> >> > no longer the case after $SUBJECT patch.  The change below on top of
> >> > -next makes these ARM boards happy again.
> >> 
> >> Oops, it should've fixed __devres_alloc() also.  Updated patch below.
> >
> > Can you send this in a format that I can apply it in?  It was whitespace
> > damaged.
> 
> hmm, sorry about that.  This one should work, though I wonder if Andrew
> should pick this up since I think the patch that causes the breakage
> came through his tree.

No, the patch is in my tree, not Andrew's.

Joe, can I get a signed-off-by for this?

thanks,

greg k-h
