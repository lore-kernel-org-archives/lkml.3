Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934333AbaFST6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:58:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaFST57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:57:59 -0400
Date: Thu, 19 Jun 2014 13:01:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Rob Clark <robdclark@gmail.com>,
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
Message-ID: <20140619200159.GA27883@kroah.com>
References: <20140618102957.15728.43525.stgit@patser>
 <20140618103653.15728.4942.stgit@patser>
 <20140619011327.GC10921@kroah.com>
 <CAF6AEGv4Ms+zsrEtpA10bGq04LnRjzVb925co49eVxh4ugkd=A@mail.gmail.com>
 <20140619170059.GA1224@kroah.com>
 <CAKMK7uFa57YjeJCFQhWFr_5cRTTpWxBdJ1qtb5Ojnu-KZpe-Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFa57YjeJCFQhWFr_5cRTTpWxBdJ1qtb5Ojnu-KZpe-Lw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 09:15:36PM +0200, Daniel Vetter wrote:
> On Thu, Jun 19, 2014 at 7:00 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> >> +     BUG_ON(f1->context != f2->context);
> >> >
> >> > Nice, you just crashed the kernel, making it impossible to debug or
> >> > recover :(
> >>
> >> agreed, that should probably be 'if (WARN_ON(...)) return NULL;'
> >>
> >> (but at least I wouldn't expect to hit that under console_lock so you
> >> should at least see the last N lines of the backtrace on the screen
> >> ;-))
> >
> > Lots of devices don't have console screens :)
> 
> Aside: This is a pet peeve of mine and recently I've switched to
> rejecting all patch that have a BUG_ON, period.

Please do, I have been for a few years now as well for the same reasons
you cite.

greg k-h
