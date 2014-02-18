Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaBRUbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:31:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaBRUbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:31:14 -0500
Date: Tue, 18 Feb 2014 12:32:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        Colin Cross <ccross@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 12/14] staging: binder: Fix ABI for 64bit Android
Message-ID: <20140218203239.GA18852@kroah.com>
References: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
 <1392674322-9036-13-git-send-email-john.stultz@linaro.org>
 <20140218190828.GA10376@kroah.com>
 <CALAqxLWMF0WFAoi-yGtWiKh2Dgw8hpM4NY5F8TQ5Yt3MvHY3kA@mail.gmail.com>
 <20140218194936.GA8584@kroah.com>
 <CALAqxLXYzCkwywS2+besc3Ai1yJc9EuDwDEHquF0OnCjPOXe_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLXYzCkwywS2+besc3Ai1yJc9EuDwDEHquF0OnCjPOXe_Q@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 12:02:07PM -0800, John Stultz wrote:
> On Tue, Feb 18, 2014 at 11:49 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Tue, Feb 18, 2014 at 11:30:26AM -0800, John Stultz wrote:
> >> On Tue, Feb 18, 2014 at 11:08 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> > On Mon, Feb 17, 2014 at 01:58:40PM -0800, John Stultz wrote:
> >> >> From: Serban Constantinescu <serban.constantinescu@arm.com>
> >> >>
> >> >> This patch fixes the ABI for 64bit Android userspace.
> >> >> BC_REQUEST_DEATH_NOTIFICATION and BC_CLEAR_DEATH_NOTIFICATION claim
> >> >> to be using struct binder_ptr_cookie, but they are using a 32bit handle
> >> >> and a pointer.
> >> >>
> >> >> On 32bit systems the payload size is the same as the size of struct
> >> >> binder_ptr_cookie, however for 64bit systems this will differ. This
> >> >> patch adds struct binder_handle_cookie that fixes this issue for 64bit
> >> >> Android.
> >> >>
> >> >> Since there are no 64bit users of this interface that we know of this
> >> >> change should not affect any existing systems.
> >> >
> >> > But you are changing the ioctl structures here, what is that going to
> >> > cause with old programs?
> >>
> >> So I'd be glad for Serban or Arve to clarify, but my understanding
> >> (and as is described in the commit message) is that the assumption is
> >> there are no 64bit binder users at this point, and the ioctl structure
> >> changes are made such that existing 32bit applications are unaffected.
> >
> > How does changing the structure size, and contents, not affect any
> > applications or the kernel code?  What am I missing here?
> 
> On 32bit pointers and ints are the same size? (Years ago I sat through
> your presentation on this, so I'm worried I'm missing something here
> :)
> 
> struct binder_ptr_cookie {
> void *ptr;
> void *cookie;
> };
> 
> struct binder_handle_cookie {
> __u32 handle;
> void *cookie;
> } __attribute__((packed));
> 
> 
> On 32bit systems these are the same size.  Now on 64bit systems, this
> changes things, and would break users, but the assumption here is
> there are no pre-existing 64bit binder users.

But you added a field to the existing structure, right?  I don't really
remember the patch, it was a few hundred back in my review of stuff
today, sorry...

greg k-h
