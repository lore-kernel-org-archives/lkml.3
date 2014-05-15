Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbaEOWut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 18:50:49 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:50033 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaEOWus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 18:50:48 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <1400190194.3289.143.camel@ul30vt.home>
References: <20140509201655.2849.97478.stgit@bling.home>
	<20140512190812.GH25056@phenom.ffwll.local>
	<1399923039.6734.97.camel@bling.home>
	<20140512193825.GI25056@phenom.ffwll.local>
	<1400190194.3289.143.camel@ul30vt.home>
Date: Fri, 16 May 2014 00:50:47 +0200
X-Google-Sender-Auth: rBUeIcdfyicOcZOlVEaqBF2lQvU
Message-ID: <CAKMK7uGRCQSUNjBiegkYncUiYmFfoLAqxj6UPYJNeOf2S2x-7w@mail.gmail.com>
Subject: Re: [PATCH] i915: Add module option to support VGA arbiter on HD devices
From: Daniel Vetter <daniel@ffwll.ch>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 11:43 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> I don't know what to do with this.  It seems like a lot of wishful
> thinking that in the best case would drag on for years.  Even if we get
> VGA arbitration out of Xorg, the bit about making the userspace VGA
> arbiter interface lie depending on current->comm sounds tricky and
> horrible.  If we can lie to Xorg there, why don't we do that now?  If we
> can't lie to Xorg now, then what deprecation event or detection of the
> caller is going to allow us to do so in the future?

Well we wouldn't necessarily need to lie to X, but could instead look
whether all the vga devices in a system are claimed by kms drivers. If
that's the case the userspace doesn't have an awful lot of business
touching the VGA registers and we could simply not obey a vga arb
request from userspace.

More advanced would be if we still obey it for those devices not
claimed by kms drivers. So not really a need to key on current->comm.

> Meanwhile anyone that wants i915 to participate in arbitration like it
> should have from the start needs to patch their kernel with forward
> ports of the reverted commits.
>
> I just don't see this moving forward, which is why I thought a module
> option at least gives us a workaround.  Thanks,

I know that this is awful, but a module option means that the few
people interested in moving this forward will be happy enough to no
longer bother. Which is even worse from my pov as driver maintainer. I
highly consider module options used in production evil.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
