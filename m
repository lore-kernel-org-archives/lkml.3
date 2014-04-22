Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbaDVUOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:14:35 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61747 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaDVUOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:14:33 -0400
Date: Tue, 22 Apr 2014 22:14:28 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: intel-gfx@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] Fwd: 3.15-rc1: Endless "Disabling PPGTT because VT-d
 is on" messages in /var/log/messages
Message-ID: <20140422201428.GJ10722@phenom.ffwll.local>
Mail-Followup-To: Alessandro Suardi <alessandro.suardi@gmail.com>,
	intel-gfx@lists.freedesktop.org,
	LKML <linux-kernel@vger.kernel.org>
References: <CAKWSe6DD77urqqTxya4FAE+VrJ1XD9UQ8u+x5DYefvO1VosLfA@mail.gmail.com>
 <CAKWSe6BvB2hyp9C4muKrUZBibhGQuPsvj571uZJX9T+_jn9XWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKWSe6BvB2hyp9C4muKrUZBibhGQuPsvj571uZJX9T+_jn9XWA@mail.gmail.com>
X-Operating-System: Linux phenom 3.14.0+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 06:29:45PM +0200, Alessandro Suardi wrote:
> forwarding from my lkml post as probably more appropriate to send this here...

Yup, but just adding more cc's is preferred. I've re-added lkml for
reference. Bug is fairly obvious regression in 3.15, patch is on the way.
-Daniel

> 
> thanks,
> 
> ---------- Forwarded message ----------
> From: Alessandro Suardi <alessandro.suardi@gmail.com>
> Date: Fri, Apr 18, 2014 at 12:31 AM
> Subject: 3.15-rc1: Endless "Disabling PPGTT because VT-d is on"
> messages in /var/log/messages
> To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> 
> 
> [hoping I persuaded gmail to get my old text-only email settings back, grrr]
> 
> 
> Noticed that my root fs was filling up, and found out that /var/log/messages was
>  approaching 2GB of space, most of which were as per $subject. To give an idea
>  of the magnitude, here's a snippet from a saved sample of /var/log/messages:
> 
> [root@xbox log]# grep  "Disabling PP" messages.save.head |head -1
> Apr 15 03:44:10 xbox kernel: [    3.115126] [drm] Disabling PPGTT
> because VT-d is on
> [root@xbox log]# grep  "Disabling PP" messages.save.head |tail -1
> Apr 15 03:45:50 xbox kernel: [  130.165219] [drm] Disabling PPGTT
> because VT-d is on
> [root@xbox log]# grep -c "Disabling PP" messages.save.head
> 610
> 
> Or from the dmesg ring:
> 
> [root@xbox log]# dmesg|head
> [22446.690572] [drm] Disabling PPGTT because VT-d is on
> [22446.690616] [drm] Disabling PPGTT because VT-d is on
> [22446.704560] [drm] Disabling PPGTT because VT-d is on
> [22446.706747] [drm] Disabling PPGTT because VT-d is on
> [22446.720202] [drm] Disabling PPGTT because VT-d is on
> [22446.722447] [drm] Disabling PPGTT because VT-d is on
> [22446.724850] [drm] Disabling PPGTT because VT-d is on
> [22446.727268] [drm] Disabling PPGTT because VT-d is on
> [22446.733052] [drm] Disabling PPGTT because VT-d is on
> [22446.735319] [drm] Disabling PPGTT because VT-d is on
> 
> 
> 
> Are there patches for this issue, or is a workaround available to prevent a
>  filesystem full condition on my root fs?
> 
> 
> This is on a Dell Latitude E6420 laptop, Fedora 19 x86_64, onboard
>  Intel video card... yes, I have an old A08 BIOS, but I've never seen
>  this issue while regularly updating my mainline kernel weekly or so...
> 
> 
> Available for more details if needed, thanks in advance,
> 
> --alessandro
> 
> "don't underestimate the things that I will do"
> 
>  (Adele, "Rolling In The Deep")
> 
> 
> -- 
> --alessandro
> 
> "don't underestimate the things that I will do"
> 
>  (Adele, "Rolling In The Deep")
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
