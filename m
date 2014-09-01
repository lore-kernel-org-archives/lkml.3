Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaIAKoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 06:44:03 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:53192 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751832AbaIAKoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 06:44:01 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Mon, 1 Sep 2014 11:43:56 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        linux-kernel@vger.kernel.org, Tibor Billes <tbilles@gmx.com>
Subject: Re: [PATCH v2] drm/i915: Fix lock dropping in intel_tv_detect()
Message-ID: <20140901104356.GE11648@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
	intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	linux-kernel@vger.kernel.org, Tibor Billes <tbilles@gmx.com>
References: <20140901085022.GB11648@nuc-i3427.alporthouse.com>
 <1409566060-21337-1-git-send-email-ville.syrjala@linux.intel.com>
 <20140901102009.GD11648@nuc-i3427.alporthouse.com>
 <20140901103637.GB4193@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140901103637.GB4193@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 01:36:37PM +0300, Ville Syrjälä wrote:
> On Mon, Sep 01, 2014 at 11:20:09AM +0100, Chris Wilson wrote:
> > On Mon, Sep 01, 2014 at 01:07:40PM +0300, ville.syrjala@linux.intel.com wrote:
> > > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > 
> > > When intel_tv_detect() fails to do load detection it would forget to
> > > drop the locks and clean up the acquire context. Fix it up.
> > > 
> > > This is a regression from:
> > >  commit 208bf9fdcd3575aa4a5d48b3e0295f7cdaf6fc44
> > >  Author: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > >  Date:   Mon Aug 11 13:15:35 2014 +0300
> > > 
> > >     drm/i915: Fix locking for intel_enable_pipe_a()
> > > 
> > > v2: Make the code more readable (Chris)
> > > 
> > > Cc: Tibor Billes <tbilles@gmx.com>
> > > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > 
> > Hmm, if we use WARN_ON() you should init type.
> 
> type is always set in the branch that sets status=connected.

Back to thinking about readability and making sure that the WARN_ON
never happens with just a glance. Otherwise, the WARN_ON would be better
as WARN_ON(unsigned)type >= last_tv_type); Or something. Anway, take
your pick and slap my r-b on it. :)
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
