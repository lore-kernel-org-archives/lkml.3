Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966422AbaFSXip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 19:38:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965603AbaFSXin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 19:38:43 -0400
Date: Thu, 19 Jun 2014 16:42:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Rob Clark <robdclark@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Colin Cross <ccross@google.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [REPOST PATCH 1/8] fence: dma-buf cross-device synchronization
 (v17)
Message-ID: <20140619234243.GA8952@kroah.com>
References: <20140618102957.15728.43525.stgit@patser>
 <20140618103653.15728.4942.stgit@patser>
 <20140619011327.GC10921@kroah.com>
 <CAF6AEGv4Ms+zsrEtpA10bGq04LnRjzVb925co49eVxh4ugkd=A@mail.gmail.com>
 <20140619170059.GA1224@kroah.com>
 <CAKMK7uFa57YjeJCFQhWFr_5cRTTpWxBdJ1qtb5Ojnu-KZpe-Lw@mail.gmail.com>
 <20140619200159.GA27883@kroah.com>
 <53A366B3.8020808@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A366B3.8020808@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 03:39:47PM -0700, H. Peter Anvin wrote:
> On 06/19/2014 01:01 PM, Greg KH wrote:
> > On Thu, Jun 19, 2014 at 09:15:36PM +0200, Daniel Vetter wrote:
> >> On Thu, Jun 19, 2014 at 7:00 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >>>>>> +     BUG_ON(f1->context != f2->context);
> >>>>>
> >>>>> Nice, you just crashed the kernel, making it impossible to debug or
> >>>>> recover :(
> >>>>
> >>>> agreed, that should probably be 'if (WARN_ON(...)) return NULL;'
> >>>>
> >>>> (but at least I wouldn't expect to hit that under console_lock so you
> >>>> should at least see the last N lines of the backtrace on the screen
> >>>> ;-))
> >>>
> >>> Lots of devices don't have console screens :)
> >>
> >> Aside: This is a pet peeve of mine and recently I've switched to
> >> rejecting all patch that have a BUG_ON, period.
> > 
> > Please do, I have been for a few years now as well for the same reasons
> > you cite.
> > 
> 
> I'm actually concerned about this trend.  Downgrading things to WARN_ON
> can allow a security bug in the kernel to continue to exist, for
> example, or make the error message disappear.

A BUG_ON makes any error message disappear pretty quickly :)

I'm talking about foolish "ASSERT-like" BUG_ON that driver authors like
to add to their code when writing it to catch things they are messing
up.  After the code is working, they should be removed, like this one.

Don't enforce an api requirement with a kernel crash, warn and return an
error which the caller should always be checking anyway.

thanks,

greg k-h
