Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213Ab3K3Idm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 03:33:42 -0500
Received: from www17.your-server.de ([213.133.104.17]:60233 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3K3Idl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 03:33:41 -0500
Message-ID: <1385800414.7279.3.camel@localhost.localdomain>
Subject: Re: [i915] BUG: Bad page state in process Xorg
From: Thomas Meyer <thomas@m3y3r.de>
To: Rob Clark <robdclark@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 Nov 2013 09:33:34 +0100
In-Reply-To: <CAF6AEGsdK4MUm9G8ruX84V5omhej+in7vP5E8skMAoTjRgh7nw@mail.gmail.com>
References: <E1Vkw2k-00015V-Ao@www17.your-server.de>
	 <CAF6AEGsdK4MUm9G8ruX84V5omhej+in7vP5E8skMAoTjRgh7nw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 25.11.2013, 08:23 -0500 schrieb Rob Clark:
> oh, hmm.. are you importing buffers from i915?  It looks like this part:

My computer has an i915 graphic card and I use an USB docking station,
that has an unconnected UDL device inside.

> 
> - if (obj->base.import_attach) {
> - drm_free_large(obj->pages);
> - obj->pages = NULL;
> - return;
> - }
> 
> should not have been removed from udl_gem_put_pages()..

Do you want me to test this? Can this please be fixed in the stable
tree?
I removed the UDL driver from my config for now, as I don't use it.
      * 
best regards
thomas

> 
> BR,
> -R
> 
> On Mon, Nov 25, 2013 at 8:17 AM,  <thomas@m3y3r.de> wrote:
> > Hi,
> >
> > It turns out that this seems to be a bug in udl DRM driver.
> >
> > I bisected the problem to this patch:
> >
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/gpu/drm/udl?id=5dc9e1e87229cb786a5bb58ddd0d60fee6eb4641
> >
> > With kind regards
> > Thomas
> >
> > Am 22.11.2013 17:18 schrieb Daniel Vetter <daniel@ffwll.ch>:
> >>
> >> On Fri, Nov 22, 2013 at 4:54 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
> >> >> Am 22.11.2013 um 11:55 schrieb Daniel Vetter <daniel@ffwll.ch>:
> >> >>
> >> >> On Fri, Nov 22, 2013 at 11:36 AM, Dave Airlie <airlied@linux.ie> wrote:
> >> >>>> Hi,
> >> >>>
> >> >>> cc'ing mailing list,
> >> >>>
> >> >>> Daniel any ideas?
> >> >>
> >> >> Nope, not really :( And no ideas how to triage this further - if it
> >> >> takes 9 days to hit it eventually we'll have a real hard time. Or does
> >> >> this happen even after just a short X run?
> >> >
> >> > Seems to happen every time while stopping the x server. Also after a short run time.
> >> >
> >> > The current fedora 3.11 kernel doesn't show this bug. I'm using fedora 19, with a self compiled kernel.
> >> >
> >> > I did turn on config-debug-pagealloc but this didn't show any wrongness.
> >>
> >> In that case I think the bisect is the fastest way to insight - atm
> >> I'm really at loss what could be wrong here.
> >> -Daniel
> >> --
> >> Daniel Vetter
> >> Software Engineer, Intel Corporation
> >> +41 (0) 79 365 57 48 - http://blog.ffwll.ch



