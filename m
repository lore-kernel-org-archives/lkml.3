Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaIBIQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 04:16:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:36153 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbaIBIQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 04:16:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,447,1406617200"; 
   d="scan'208";a="584954257"
Date: Tue, 2 Sep 2014 11:16:12 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, intel-gfx@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        Tibor Billes <tbilles@gmx.com>
Subject: Re: [PATCH v2] drm/i915: Fix lock dropping in intel_tv_detect()
Message-ID: <20140902081612.GH4193@intel.com>
References: <20140901085022.GB11648@nuc-i3427.alporthouse.com>
 <1409566060-21337-1-git-send-email-ville.syrjala@linux.intel.com>
 <20140901102009.GD11648@nuc-i3427.alporthouse.com>
 <20140901103637.GB4193@intel.com>
 <20140901104356.GE11648@nuc-i3427.alporthouse.com>
 <87egvuii5q.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87egvuii5q.fsf@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 10:41:05AM +0300, Jani Nikula wrote:
> On Mon, 01 Sep 2014, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > On Mon, Sep 01, 2014 at 01:36:37PM +0300, Ville Syrjälä wrote:
> >> On Mon, Sep 01, 2014 at 11:20:09AM +0100, Chris Wilson wrote:
> >> > On Mon, Sep 01, 2014 at 01:07:40PM +0300, ville.syrjala@linux.intel.com wrote:
> >> > > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> >> > > 
> >> > > When intel_tv_detect() fails to do load detection it would forget to
> >> > > drop the locks and clean up the acquire context. Fix it up.
> >> > > 
> >> > > This is a regression from:
> >> > >  commit 208bf9fdcd3575aa4a5d48b3e0295f7cdaf6fc44
> >> > >  Author: Ville Syrjälä <ville.syrjala@linux.intel.com>
> >> > >  Date:   Mon Aug 11 13:15:35 2014 +0300
> >> > > 
> >> > >     drm/i915: Fix locking for intel_enable_pipe_a()
> >> > > 
> >> > > v2: Make the code more readable (Chris)
> >> > > 
> >> > > Cc: Tibor Billes <tbilles@gmx.com>
> >> > > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> >> > 
> >> > Hmm, if we use WARN_ON() you should init type.
> >> 
> >> type is always set in the branch that sets status=connected.
> >
> > Back to thinking about readability and making sure that the WARN_ON
> > never happens with just a glance. Otherwise, the WARN_ON would be better
> > as WARN_ON(unsigned)type >= last_tv_type); Or something. Anway, take
> > your pick and slap my r-b on it. :)
> 
> Ville?

I don't know anymore. Just kill the WARN_ON() if it makes things
confusing?

-- 
Ville Syrjälä
Intel OTC
