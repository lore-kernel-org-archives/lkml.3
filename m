Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab3COMcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 08:32:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:26578 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab3COMcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 08:32:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,850,1355126400"; 
   d="scan'208";a="302722407"
Date: Fri, 15 Mar 2013 12:32:01 +0000
From: Damien Lespiau <damien.lespiau@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Julien Tinnes <jln@google.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH v3] drm/i915: bounds check execbuffer
 relocation count
Message-ID: <20130315123201.GA12828@dyon.amr.corp.intel.com>
References: <20130312003145.GA28993@www.outflux.net>
 <20130312090746.GD31324@cantiga.alporthouse.com>
 <20130313202858.GD1896@bremse>
 <CAKMK7uEDjtECnAO1v38KMDuB7kd=DthiZRvQdto7+HJ19tWkEw@mail.gmail.com>
 <CAGXu5j+Y9Onie1bC5aW-GUqYKCbLe=Zxx3e+74FmKCE237_mig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+Y9Onie1bC5aW-GUqYKCbLe=Zxx3e+74FmKCE237_mig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 12:32:00PM -0700, Kees Cook wrote:
> On Thu, Mar 14, 2013 at 9:57 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > On Wed, Mar 13, 2013 at 9:28 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> >> On Tue, Mar 12, 2013 at 09:07:46AM +0000, Chris Wilson wrote:
> >>> On Mon, Mar 11, 2013 at 05:31:45PM -0700, Kees Cook wrote:
> >>> > It is possible to wrap the counter used to allocate the buffer for
> >>> > relocation copies. This could lead to heap writing overflows.
> >>> >
> >>> > CVE-2013-0913
> >>> >
> >>> > v3: collapse test, improve comment
> >>> > v2: move check into validate_exec_list
> >>> >
> >>> > Signed-off-by: Kees Cook <keescook@chromium.org>
> >>> > Reported-by: Pinkie Pie
> >>> > Cc: stable@vger.kernel.org
> >>>
> >>> Looks good to me. The only bikeshed that remains is whether we should
> >>> just collapse the two variables into one, but the current 'max - count'
> >>> is more idiomatic and so preferrable.
> >>> Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
> >>
> >> Picked up for -fixes, thanks for the patch.
> >
> > I've forgotten to dump my wishlist: Can I have an i-g-t for this? For
> > this bug here specifically an execbuf with just one buffer with too
> > many relocs plus another execbuf with two buffers with relocation so
> > that the 2nd relocation list will overflow should be sufficient.
> 
> Sure thing. Where do these live? (Or what docs should I read for
> this?) I'm assuming i-g-t means "intel graphics test"? :)

Close :) GPU Tools. The tests lives in the tests directory of:
http://cgit.freedesktop.org/xorg/app/intel-gpu-tools/

-- 
Damien
