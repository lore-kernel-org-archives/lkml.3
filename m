Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab3CQTqm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 15:46:42 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:55398 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411Ab3CQTql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 15:46:41 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CACP_E+JZ36SXNU4b4GDFRo9KkW28brEEFDEYhyRqR3S4n6JNQg@mail.gmail.com>
References: <20120913141841.GC5693@phenom.ffwll.local>
	<CACP_E+JZ36SXNU4b4GDFRo9KkW28brEEFDEYhyRqR3S4n6JNQg@mail.gmail.com>
Date: Sun, 17 Mar 2013 20:46:40 +0100
X-Google-Sender-Auth: XdwxO_pAFhZF3J2DF-OlWjSW9hk
Message-ID: <CAKMK7uHW0YnbZnGH0vLz3aq+EwR7x+f5o7dh6cyttWuEdSpRTQ@mail.gmail.com>
Subject: Re: [pull] drm-intel-next
From: Daniel Vetter <daniel@ffwll.ch>
To: =?ISO-8859-1?Q?St=E9phane_Marchesin?= 
	<stephane.marchesin@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 3:11 AM, Stéphane Marchesin
<stephane.marchesin@gmail.com> wrote:
>>       drm/i915: read out the modeset hw state at load and resume time
> This commit regresses modeset on the samsung series 5 chromebook (it
> is basically a pineview machine with an lvds panel). I don't seem to
> be able to set any mode on it any longer.

Does that mean the kernel refuses to set the mode, or that you get a
black screen?

For starters I guess we need:
- drm.debug=0xe dmesg from just before that commit
- same for latest 3.9-rc kernels, presuming it's not broken there

Latest upstream has a minor chance to work better I think since we've
improved the pfit handling in the setup and teardown sequence a bit.

Generally lvds has been hit&miss on way too many machines
unfortunately with things randomly breaking and getting fixed again
(e.g. one of Chris' machines works again with the new code ...). And
the commit above doesn't really change much in the code itself but it
does change the order (and timing) of the different enable/disable
codepaths.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
