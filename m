Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbaCMVZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:25:11 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35561 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbaCMVZJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:25:09 -0400
Date: Thu, 13 Mar 2014 21:24:50 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "jmorris@namei.org" <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Message-ID: <20140313212450.67f1de8e@alan.etchedpixels.co.uk>
In-Reply-To: <1394726363.25122.16.camel@x230>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	<CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
	<alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
	<1394686919.25122.2.camel@x230>
	<CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
	<alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
	<1394726363.25122.16.camel@x230>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2014 15:59:24 +0000
Matthew Garrett <matthew.garrett@nebula.com> wrote:

> On Thu, 2014-03-13 at 20:33 +1100, James Morris wrote:
> 
> > I'll take it, but there's unanswered review feedback (your response to the 
> > first question), and Alan raised some doubts about the patches which I'm 
> > not sure have been resolved.
> 
> The remaining opens seem to be CAP_SYS_RAWIO and firmware signing?
> Ironically, disabling CAP_SYS_RAWIO disables firmware loading…
> 
> The problem with CAP_SYS_RAWIO is that its semantics were never
> sufficiently well documented, and as a result it's a mixture of "This is
> incredibly dangerous" and "We replaced a check for uid 0 with whichever
> capability seemed to have the most appropriate name". I've gone through
> all the uses of CAP_SYS_RAWIO and added additional checks to the generic
> ones that seem appropriate. There's a couple of old drivers that use it
> to gate access to features that potentially allow arbitrary DMA and it
> might be worth cleaning those up, but the only general case I haven't
> modified is the ability to send arbitrary SCSI commands from userspace.
> My understanding is that endpoints aren't going to be able to DMA to
> arbitrary addresses, so that doesn't seem like a problem.
> 
> On the other hand, disabling CAP_SYS_RAWIO *definitely* breaks expected
> functionality - firmware loading and the fibmap ioctl are probably the
> most obvious. And changing the use of CAP_SYS_RAWIO potentially breaks
> userspace expectations, so we're kind of stuck there.

If I have CAP_SYS_RAWIO I can make arbitary ring 0 calls from userspace,
trivially and in a fashion well known and documented.

So if that isn't sufficient then we need to sort CAP_foo out first.

You've missed a few others too - mem= (especially with exactmap) for
example.

Alan
