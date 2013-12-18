Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab3LRLyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 06:54:35 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:44520 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab3LRLyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 06:54:33 -0500
Date: Wed, 18 Dec 2013 12:54:23 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        the arch/x86 maintainers <x86@kernel.org>, linux-fbdev@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC] x86: sysfb: remove sysfb when probing real hw
Message-ID: <20131218115423.GA23692@gmail.com>
References: <s5hk3f2v15r.wl%tiwai@suse.de>
 <1387367283-20078-1-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387367283-20078-1-git-send-email-dh.herrmann@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Herrmann <dh.herrmann@gmail.com> wrote:

> If we probe a real hw driver for graphics devices, we need to unload any
> generic fallback driver like efifb/vesafb/simplefb on the system
> framebuffer. This is currently done via remove_conflicting_framebuffers()
> in fbmem.c. However, this only removes the fbdev driver, not the fake
> platform devices underneath. This hasn't been a problem so far, as efifb
> and vesafb didn't store any resources there. However, with simplefb this
> changed.
> 
> To correctly release the IORESOURCE_MEM resources of simple-framebuffer
> platform devices, we need to unregister the underlying platform device
> *before* probing any new hw driver. This patch adds sysfb_unregister() for
> that purpose. It can be called from any context (except from the
> platform-device ->remove callback path) and synchronously unloads any
> global sysfb and prevents new sysfbs from getting registered. Thus, you
> can call it even before any sysfb has been loaded.
> 
> This also changes remove_conflicting_framebuffer() to call this helper
> *before* trying it's fbdev heuristic to remove conflicting drivers.
> 
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> ---
> Hi
> 
> This is imho the clean version of Takashi's fix. However, it gets pretty huge. I
> wouldn't object to marking CONFIG_X86_SYSFB broken in the stable series and get
> this in for 3.14. Your call..
> 
> This patch basically simulates an unplug event for system-framebuffers when
> loading real hardware drivers. To trigger it, call sysfb_unregister(). You can
> optionally pass an aperture-struct and primary-flag similar to
> remove_conflicting_framebuffers(). If they're not passed, we remove it
> unconditionally.
> 
> Untested, but my kernel compiles are already running. If my tests succeed and
> nobody has objections, I can resend it as proper PATCH and marked for stable.
> And maybe split the fbmem and sysfb changes into two patches..

Please fix the changelog to conform to the standard changelog style:

 - first describe the symptoms of the bug - how does a user notice? 

 - then describe how the code behaves today and how that is causing the bug

 - and then only describe how it's fixed.

The first item is the most important one - while developers 
(naturally) tend to concentrate on the least important point, the last 
one.

Thanks,

	Ingo
