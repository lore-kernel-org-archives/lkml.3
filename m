Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbaLOH5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 02:57:01 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45910 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaLOH5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 02:57:00 -0500
Date: Mon, 15 Dec 2014 08:57:34 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: linux-kernel@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, airlied@linux.ie,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [Regression] 3.18 black screen after boot (bisected)
Message-ID: <20141215075734.GR27182@phenom.ffwll.local>
Mail-Followup-To: linux-kernel@vger.kernel.org, airlied@linux.ie,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
References: <20141214115831.GA1634@fritha.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141214115831.GA1634@fritha.org>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 12:58:31PM +0100, Heinz Diehl wrote:
> Hi,
> 
> since kernel 3.18 I'm no longer able to run X on my machine. While
> 3.17.6 is fine, 3.18 leaves me with a black screen when starting
> X. Booting into runlevel 1/3 is fine.
> 
> I did a "git bisect", and the offending commit is this one:
> 
> [root@kiera linux-git]# git bisect bad
> 83f45fc360c8e16a330474860ebda872d1384c8c is the first bad commit
> commit 83f45fc360c8e16a330474860ebda872d1384c8c
> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> Date:   Wed Aug 6 09:10:18 2014 +0200
> 
>     drm: Don't grab an fb reference for the idr
> 
> [....]
> 
> I double-checked, and 3.18 is fine with this commit reverted.
> 
> My machine is an Asus U45JC laptop, and the CPU is an Intel i450M
> (Ironlake). Please contact me if I can help in any way (I'm subscribed
> to lkml, but not to other X or kernel related lists).

Can you please boot with drm.debug=0xf on both good and bad kernels and
then grab dmesg from each?

To make sure we don't forget this please file the above summary plus dmesg
files as a new bug against dri -> drm(intel) on bugs.freedesktop.org.
Please add "[ilk bisected]" to the bug summary so it shows up in all the
right searches for us.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
