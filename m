Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab3C1P6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:58:19 -0400
Received: from oproxy14-pub.unifiedlayer.com ([67.222.51.224]:48275 "HELO
	oproxy14-pub.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756526Ab3C1P6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:58:11 -0400
Date: Thu, 28 Mar 2013 08:39:43 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, backports@vger.kernel.org,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr, rodrigo.vivi@gmail.com, daniel.vetter@ffwll.ch,
        rafael.j.wysocki@intel.com
Subject: Re: [PATCH] compat/compat-drivers/linux-next: fb skip_vt_switch
Message-ID: <20130328083943.01e61b4b@jbarnes-desktop>
In-Reply-To: <1364472270-9297-1-git-send-email-mcgrof@do-not-panic.com>
References: <1364472270-9297-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Mar 2013 05:04:26 -0700
"Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:

> The new commit by Jesse that extended the fb_info with a skip_vt_switch
> element is the simplest example of a data structure expansion. We'd backport
> this by adding a static inline to compat so that new kernels muck with the
> new element and for older kernels this would be a no-op. This reduces the
> size of the backport and unclutters the required patch with #idefs, and
> insteads leaves only a replacement of the usage of the new elements with
> a static inline, this however would still be required on our end:
> 
> 	-      info->skip_vt_switch = true;
> 	+      fb_enable_skip_vt_switch(info);
> 
> So we'd then have to just add this static inline change for each new driver...
> There may be a way to get SmPL to do this for us...

Yeah I'm not attached to the direct structure reference; a couple of
inlines are just as easy to read.  So no argument from me.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
