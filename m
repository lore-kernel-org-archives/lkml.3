Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab3ANMry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 07:47:54 -0500
Received: from mga14.intel.com ([143.182.124.37]:29700 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556Ab3ANMrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 07:47:53 -0500
Message-Id: <1f4a33$5m0jfk@AZSMGA002.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,468,1355126400"; 
   d="scan'208";a="190860788"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: i915_hangcheck_hung problem with 3.8-rc2+ (Linus's latest tree)
To: Nikola Pajkovsky <npajkovs@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>,
        Lijo Antony <lijo.kernel@gmail.com>, Dave Airlie <airlied@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <878v7w14dn.fsf@redhat.com>
References: <20130108223611.GA19672@kroah.com> <20130109003824.GA21075@kroah.com> <CAPM=9tw3o0e_3cRUFntwddxsWMsYkVKe1b5gDQhxijYKU=9m5g@mail.gmail.com> <20130109042533.GA9164@kroah.com> <CAPM=9tyB4aKK2Z3-h9yEXLWvrnKGjxH2DaOHp8uA0mNNZQiVWQ@mail.gmail.com> <50ED1C12.2090608@gmail.com> <50EDC8A1.30307@oracle.com> <50EDCF14.4080101@oracle.com> <8738y7skae.fsf@redhat.com> <CAKMK7uGpAHRgT3aj6bvU-13gaFe0u8gq19nDfo86JCJJy3R-tw@mail.gmail.com> <87obgsl08a.fsf@redhat.com> <CAKMK7uEd4xLCbiMiVvPGCWG2h5v32WEJVYUtwSsDxZmWu4rUZA@mail.gmail.com> <878v7w14dn.fsf@redhat.com>
Date: Mon, 14 Jan 2013 12:47:46 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2013 10:49:08 +0100, Nikola Pajkovsky <npajkovs@redhat.com> wrote:
> Daniel Vetter <daniel.vetter@ffwll.ch> writes:
> 
> > On Mon, Jan 14, 2013 at 7:58 AM, Nikola Pajkovsky <npajkovs@redhat.com> wrote:
> >> Daniel Vetter <daniel.vetter@ffwll.ch> writes:
> >>
> >>> On Fri, Jan 11, 2013 at 6:26 PM, Nikola Pajkovsky <npajkovs@redhat.com> wrote:
> >>>> bug still kicking even w/ (drm/i915: Revert shrinker changes from "Track
> >>>> unbound pages")
> >>>
> >>> Could be a different bug, can you please attach the error_state somewhere?
> >>
> >> yep, i915_error_state is attached. btw, I'm going to bisect kernel, so
> >> hopefully I will bring some commit.
> >
> > Different bug, on a quick lock this could be a dupe of
> > https://bugzilla.kernel.org/show_bug.cgi?id=52311
> 
> ok
> 
> > Chris should know the details.
> 
> thanks, bisection leads me to commit d7d4eed ("drm/i915: Allow
> DRM_ROOT_ONLY|DRM_MASTER to submit privileged batchbuffers). It's not
> possible to simply revert/test commit and I have no idea how i915 works.
> 
> Chris any ideas?

Userspace is failing to prepare the GPU to execute a WAIT_FOR_EVENT
command, which it can only try if the kernel allows execution of
privileged batch buffers.

Option "SwapbuffersWait" "false" in xorg.conf will prevent the ddx from
issuing the hanging command sequence. It is not clear yet what the
missing ingredient is, I suspect the ddx needs to be more careful about
not setting conditions that can never be met.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
