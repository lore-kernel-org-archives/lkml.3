Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbaFSBkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 21:40:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086AbaFSBkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 21:40:42 -0400
Date: Wed, 18 Jun 2014 18:44:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rob Clark <robdclark@gmail.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Colin Cross <ccross@google.com>, Daniel Vetter <daniel@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [REPOST PATCH 1/8] fence: dma-buf cross-device synchronization
 (v17)
Message-ID: <20140619014440.GA13493@kroah.com>
References: <20140618102957.15728.43525.stgit@patser>
 <20140618103653.15728.4942.stgit@patser>
 <20140619011327.GC10921@kroah.com>
 <CAF6AEGvXp-bBSaU2o-ix+M4+zX24je=y_csz49g_zNn0YPpDYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF6AEGvXp-bBSaU2o-ix+M4+zX24je=y_csz49g_zNn0YPpDYg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 09:23:06PM -0400, Rob Clark wrote:
> On Wed, Jun 18, 2014 at 9:13 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Wed, Jun 18, 2014 at 12:36:54PM +0200, Maarten Lankhorst wrote:
> >> +#define CREATE_TRACE_POINTS
> >> +#include <trace/events/fence.h>
> >> +
> >> +EXPORT_TRACEPOINT_SYMBOL(fence_annotate_wait_on);
> >> +EXPORT_TRACEPOINT_SYMBOL(fence_emit);
> >
> > Are you really willing to live with these as tracepoints for forever?
> > What is the use of them in debugging?  Was it just for debugging the
> > fence code, or for something else?
> 
> fwiw, the goal is something like this:
> 
> http://people.freedesktop.org/~robclark/perf-supertuxkart.svg
> 
> but without needing to make perf understand each driver's custom trace events
> 
> (from: http://bloggingthemonkey.blogspot.com/2013/09/freedreno-update-moar-fps.html
> )

Will these tracepoints provide something like that?  If so, great, but I
want to make sure as these now become a user/kernel ABI that you can not
break.

thanks,

greg k-h
