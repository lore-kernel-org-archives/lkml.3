Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaFKJch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:32:37 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:40150 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbaFKJcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:32:35 -0400
Date: Wed, 11 Jun 2014 11:32:29 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: Mismatch in gmch_pfit.lvds_border_bits on EeePC 900
Message-ID: <20140611093229.GD5821@phenom.ffwll.local>
Mail-Followup-To: Sitsofe Wheeler <sitsofe@gmail.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <20140608213015.GA30713@sucs.org>
 <20140610062655.GA5821@phenom.ffwll.local>
 <20140611054640.GA31892@sucs.org>
 <20140611060339.GA6261@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611060339.GA6261@sucs.org>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 07:03:39AM +0100, Sitsofe Wheeler wrote:
> (resending because Daniel was dropped from the reply list - I don't know
> why)
> 
> On Wed, Jun 11, 2014 at 06:46:40AM +0100, Sitsofe Wheeler wrote:
> > On Tue, Jun 10, 2014 at 08:26:55AM +0200, Daniel Vetter wrote:
> > > On Sun, Jun 08, 2014 at 10:30:15PM +0100, Sitsofe Wheeler wrote:
> > > > With a tree that is close to 3.15 final I'm regularly seeing the
> > > > following on my EeePC 900 when starting ioquake3:
> > > > 
> > > > [drm:intel_pipe_config_compare] *ERROR* mismatch in gmch_pfit.lvds_border_bits (expected 32768, found 0)
> > > 
> > > Hm, I've thought we've fixed that by now. Alas, no :(
> > > 
> > > Can you please add drm.debug=0xe to your kernel cmdline, reproduce the
> > > issue and attach the entire dmesg? Please make sure it contains everything
> > > since boot-up so that we can reconstruct the state properly (might need to
> > > grab it from logfiles if dmesg is cut off).
> > 
> > Please find kern.log.gz attached.

Not in the resend and I didn't seem to receive your original mail somehow
at all. Can you please resend.

> > > Also, do you have any ideas when you reproduce this? Anything that changes
> > > the lvds output could be relevant ...
> > 
> > Doing
> > xrandr -s 800x600
> > xrandr -s 0
> > 
> > was enough to provoke the messages in the attached log.

Ok, makes sense. Smells a bit like leftover pfit state. Can you please
also try latest drm-intel-nightly?

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
