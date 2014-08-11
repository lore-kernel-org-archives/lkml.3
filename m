Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaHKXiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 19:38:54 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33769 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaHKXix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 19:38:53 -0400
Date: Mon, 11 Aug 2014 16:38:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rob Clark <robdclark@gmail.com>
cc: sanjeev sharma <sanjeevsharmaengg@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm: Do not use BUG_ON(!spin_is_locked())
In-Reply-To: <CAF6AEGuu7cGpudV-G=vGCZrHjEuqTcFHsqnULE771a5UMNEVsw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1408111636370.23479@chino.kir.corp.google.com>
References: <1407731491-22446-1-git-send-email-linux@roeck-us.net> <alpine.DEB.2.02.1408110439580.15519@chino.kir.corp.google.com> <CAGUYZuS=_rFpukssRebxXBccPrJAen15i8Qf3K+1YyF+feShdQ@mail.gmail.com> <CAGUYZuSk4u5jyPcrYTjwjXmQRyr0kCEvxkgFfjcyP+ex544CLA@mail.gmail.com>
 <alpine.DEB.2.02.1408111352090.24240@chino.kir.corp.google.com> <CAF6AEGuu7cGpudV-G=vGCZrHjEuqTcFHsqnULE771a5UMNEVsw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2014, Rob Clark wrote:

> > I'm suggesting that if you don't want to incur the cost of the conditional
> > everytime you call a certain function with assert_spin_locked() that you
> > could covert these to lockdep_assert_held() so the check is only done when
> > lockdep is enabled for debugging.
> 
> not sure about the nouveau parts, but for the omap and msm hunks, this
> code getting called at potentially vblank rate (so maybe once or twice
> per ~16ms)..  and lockdep has considerable overhead (for a gpu driver)
> so I don't always have it enabled.  So it sounds like for those two at
> least assert_spin_locked() is a better option.
> 

Unless there's a bug, assert_spin_locked() is just going to incur an 
unnecessary cost every time it is called at runtime.  My suggestion was to 
limit that check only to debugging kernels that include enabling lockdep 
when tracking down problems rather than needlessly evaluating the 
conditional every time when there are no bugs.
