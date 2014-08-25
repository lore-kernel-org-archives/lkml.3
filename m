Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbaHYKTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 06:19:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:44079 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142AbaHYKTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 06:19:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,396,1406617200"; 
   d="scan'208";a="589438581"
From: Jani Nikula <jani.nikula@intel.com>
To: Eric Rannaud <eric.rannaud@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Jon Kristensen <info@jonkri.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: i915: Regression: +4W in idle power use on Macbook Pro 15 (late 2013)
In-Reply-To: <CA+zRj8WfK3Dgcx2F-eOJ10ZroZaZDdB6NYp6SLpBs2eOu2bUOA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <CA+zRj8WfK3Dgcx2F-eOJ10ZroZaZDdB6NYp6SLpBs2eOu2bUOA@mail.gmail.com>
User-Agent: Notmuch/0.18.1+66~g7487985 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 25 Aug 2014 13:19:05 +0300
Message-ID: <87vbpglvmu.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014, Eric Rannaud <eric.rannaud@gmail.com> wrote:
> Hi,
>
> Between 3.15.4 and 3.15.8, there was an increase in idle power consumption on
> Apple Macbook Pro 15 (late 2013) on a freshly booted system (no wifi driver
> loaded; brightness set to 4/100; X running; no desktop environment, except
> Awesome), from 6.5W to about 10.5W, as reported by powertop.
>
> In the stable tree, it bisects to:
>         commit f4db98240ac2c6d9d2118c6f82d483ff5293f1ed
>         Author: Chris Wilson <chris@chris-wilson.co.uk>
>         Date:   Fri Jun 6 10:37:11 2014 +0100
>
>             drm/i915: Disable FBC by default also on Haswell and later
>
>             commit 0368920e51ae0cded0eb518c340a4dd17764d461 upstream.
>
>             It causes black screen on bootup and is approximately 100x
> slower than
>             running with FBC disabled, so the GPU runs at a high
> frequency for much
>             longer - completely contrary to the power saving claims.
> It also still
>             has mutex deadlocks in multi-head scenarios, which can lead to a
>             system/X lockup. These bugs were known before FBC was
> enabled by default
>             on Haswell and still have not been fixed.
>
> The issue is still present in Linus' tree (v3.17-rc1-22-g480cadc2b7e0).
>
> With a 75Wh battery, that's a significant loss in battery life in normal use.
>
> I'll be happy to help test any potential fix.

The earlier regression trumps, and in this case it was enabling FBC by
default on Haswell. Sorry.

You can enable FBC with i915.enable_fbc=1 module parameter, but all bets
are off. See the commit message you quoted above. I don't recommend.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
