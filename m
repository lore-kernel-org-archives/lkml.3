Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157AbaEEOwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:52:50 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:34679 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448AbaEEOwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:52:46 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <s5hd2fsffhk.wl%tiwai@suse.de>
References: <s5htx94fkfi.wl%tiwai@suse.de>
	<CAKMK7uHcYvuViEeyxLc75+kMVPPaKMr8svJQysk124--cjGL+g@mail.gmail.com>
	<s5hd2fsffhk.wl%tiwai@suse.de>
Date: Mon, 5 May 2014 16:52:45 +0200
X-Google-Sender-Auth: hiskMiUAz9iEdYg8q3D58CyQjrw
Message-ID: <CAKMK7uGD5JCQSfk+Vuf=qrjU9x+Y+-W3o-xyGyTM_BreR_XZcw@mail.gmail.com>
Subject: Re: Atomicity in KMS panic notifier
From: Daniel Vetter <daniel@ffwll.ch>
To: Takashi Iwai <tiwai@suse.de>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Herrmann <dh.herrmann@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 4:48 PM, Takashi Iwai <tiwai@suse.de> wrote:
>
> The current problem I see is that the rest of panic notifier chain
> won't be called once when we hit the problem in KMS notifier.  So,
> this bug in KMS influences on the rest panic behavior.
>
> Maybe a hackish solution would be to keep KMS notifier at the end of
> notifier chain so that it crashes at last.  I don't like this either,
> but...

You need to do that with both the kms panic notifier in
drm_fb_helper.c and with the fbcon panic notifier. And iirc there's
also a console->unblank call somewhere which _also_ can end up in
->set_par. But I'm not sure anymore when exactly that one is run, I've
tried hard to forget this all ;-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
