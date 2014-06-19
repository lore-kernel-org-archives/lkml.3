Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbaFSGhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 02:37:39 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:50707 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417AbaFSGhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 02:37:36 -0400
Date: Thu, 19 Jun 2014 08:37:27 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, thellstrom@vmware.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robdclark@gmail.com,
        thierry.reding@gmail.com, ccross@google.com, daniel@ffwll.ch,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org
Subject: Re: [REPOST PATCH 4/8] android: convert sync to fence api, v5
Message-ID: <20140619063727.GL5821@phenom.ffwll.local>
Mail-Followup-To: Greg KH <gregkh@linuxfoundation.org>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	linux-arch@vger.kernel.org, thellstrom@vmware.com,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, robdclark@gmail.com,
	thierry.reding@gmail.com, ccross@google.com,
	sumit.semwal@linaro.org, linux-media@vger.kernel.org
References: <20140618102957.15728.43525.stgit@patser>
 <20140618103711.15728.97842.stgit@patser>
 <20140619011556.GE10921@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619011556.GE10921@kroah.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 06:15:56PM -0700, Greg KH wrote:
> On Wed, Jun 18, 2014 at 12:37:11PM +0200, Maarten Lankhorst wrote:
> > Just to show it's easy.
> > 
> > Android syncpoints can be mapped to a timeline. This removes the need
> > to maintain a separate api for synchronization. I've left the android
> > trace events in place, but the core fence events should already be
> > sufficient for debugging.
> > 
> > v2:
> > - Call fence_remove_callback in sync_fence_free if not all fences have fired.
> > v3:
> > - Merge Colin Cross' bugfixes, and the android fence merge optimization.
> > v4:
> > - Merge with the upstream fixes.
> > v5:
> > - Fix small style issues pointed out by Thomas Hellstrom.
> > 
> > Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> > Acked-by: John Stultz <john.stultz@linaro.org>
> > ---
> >  drivers/staging/android/Kconfig      |    1 
> >  drivers/staging/android/Makefile     |    2 
> >  drivers/staging/android/sw_sync.c    |    6 
> >  drivers/staging/android/sync.c       |  913 +++++++++++-----------------------
> >  drivers/staging/android/sync.h       |   79 ++-
> >  drivers/staging/android/sync_debug.c |  247 +++++++++
> >  drivers/staging/android/trace/sync.h |   12 
> >  7 files changed, 609 insertions(+), 651 deletions(-)
> >  create mode 100644 drivers/staging/android/sync_debug.c
> 
> With these changes, can we pull the android sync logic out of
> drivers/staging/ now?

Afaik the google guys never really looked at this and acked it. So I'm not
sure whether they'll follow along. The other issue I have as the
maintainer of gfx driver is that I don't want to implement support for two
different sync object primitives (once for dma-buf and once for android
syncpts), and my impression thus far has been that even with this we're
not there.

I'm trying to get our own android guys to upstream their i915 syncpts
support, but thus far I haven't managed to convince them to throw people's
time at this.

It looks like a step into the right direction, but until I have the proof
in the form of i915 patches that I won't have to support 2 gfx fencing
frameworks I'm opposed to de-staging android syncpts. Ofc someone else
could do that too, but besides i915 I don't see a full-fledged (modeset
side only kinda doesn't count) upstream gfx driver shipping on android.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
