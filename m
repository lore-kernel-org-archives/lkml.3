Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaBRTsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:48:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48653 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbaBRTsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:48:11 -0500
Date: Tue, 18 Feb 2014 11:49:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        Colin Cross <ccross@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 12/14] staging: binder: Fix ABI for 64bit Android
Message-ID: <20140218194936.GA8584@kroah.com>
References: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
 <1392674322-9036-13-git-send-email-john.stultz@linaro.org>
 <20140218190828.GA10376@kroah.com>
 <CALAqxLWMF0WFAoi-yGtWiKh2Dgw8hpM4NY5F8TQ5Yt3MvHY3kA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALAqxLWMF0WFAoi-yGtWiKh2Dgw8hpM4NY5F8TQ5Yt3MvHY3kA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 11:30:26AM -0800, John Stultz wrote:
> On Tue, Feb 18, 2014 at 11:08 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Mon, Feb 17, 2014 at 01:58:40PM -0800, John Stultz wrote:
> >> From: Serban Constantinescu <serban.constantinescu@arm.com>
> >>
> >> This patch fixes the ABI for 64bit Android userspace.
> >> BC_REQUEST_DEATH_NOTIFICATION and BC_CLEAR_DEATH_NOTIFICATION claim
> >> to be using struct binder_ptr_cookie, but they are using a 32bit handle
> >> and a pointer.
> >>
> >> On 32bit systems the payload size is the same as the size of struct
> >> binder_ptr_cookie, however for 64bit systems this will differ. This
> >> patch adds struct binder_handle_cookie that fixes this issue for 64bit
> >> Android.
> >>
> >> Since there are no 64bit users of this interface that we know of this
> >> change should not affect any existing systems.
> >
> > But you are changing the ioctl structures here, what is that going to
> > cause with old programs?
> 
> So I'd be glad for Serban or Arve to clarify, but my understanding
> (and as is described in the commit message) is that the assumption is
> there are no 64bit binder users at this point, and the ioctl structure
> changes are made such that existing 32bit applications are unaffected.

How does changing the structure size, and contents, not affect any
applications or the kernel code?  What am I missing here?

> >> Cc: Colin Cross <ccross@android.com>
> >> Cc: Arve Hjønnevåg <arve@android.com>
> >> Cc: Serban Constantinescu <serban.constantinescu@arm.com>
> >> Cc: Android Kernel Team <kernel-team@android.com>
> >
> > I am going to require Acks from someone on the Android team to accept
> > this, or any other 64bit binder patch, given all the back-and-forth that
> > has happened with the different patch sets here over the past year or
> > so.
> 
> Certainly reasonable given the earlier back and forth.  For extra
> context, these have been merged into the 3.10 AOSP by Arve:
> https://android-review.googlesource.com/#/c/79228/

That's good to see, and a good reason to get them merged, but better
descriptions and acks would be nice to have :)

How about sending these as a separate series when all worked out, as
lots of people seem interested in them?

thanks,

greg k-h
