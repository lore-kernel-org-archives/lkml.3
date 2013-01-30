Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab3A3L71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:59:27 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:52210 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3A3L7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:59:24 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <51067300.2050808@canonical.com>
References: <alpine.DEB.2.00.1301250041001.25545@skynet.skynet.ie>
	<CA+55aFxzDv0emWgyde7iEWpgZarAGaExrKbEHFr-UcbhoeH_Cw@mail.gmail.com>
	<CAPM=9tz6_=k1Ze5h2935-W59BCVy9KXA_z6t8inW6_-Cxw244Q@mail.gmail.com>
	<CAPM=9txUNG_CeK+YBhcA_47BVv4Z2GAmEC_J59cY+D9nRgv54A@mail.gmail.com>
	<51067300.2050808@canonical.com>
Date: Wed, 30 Jan 2013 12:59:22 +0100
X-Google-Sender-Auth: JuohMx21yrKdYVZI_uL2PKHC97I
Message-ID: <CAKMK7uGR+wd6DR561WC_q20WZvf4ytO-wKUk0zKKtxrcc6M43A@mail.gmail.com>
Subject: Re: [git pull] fbcon locking fixes.
From: Daniel Vetter <daniel@ffwll.ch>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Dave Airlie <airlied@gmail.com>, m.b.lankhorst@gmail.com,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 1:45 PM, Maarten Lankhorst
<maarten.lankhorst@canonical.com> wrote:
>> There was a path going into set_con2fb_path if an fb driver was
>> already registered, I just pushed the locking out further on anyone
>> going in there.
>>
>> it boots on my EFI macbook here.
>>
> I cherry picked those patches to my tree, and the full series no longer triggers a lockdep warning.
> It also no longer locks up during modprobing or vga-switcheroo either.
>
> Tested-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

QA reported spurious failures in some kms_flip tests and lockdep
splats, somehow both are fixed with the locking. I'm a bit confused
how these issues could cause failures in the flip tests, but alas:

Tested-by: Lu Hua <huax.lu@intel.com> (for all three patches).
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
