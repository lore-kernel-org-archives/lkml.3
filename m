Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab3EJBVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 21:21:55 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:40536 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab3EJBVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 21:21:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAH3drwa_ypKKqZ8eayeR4fA4Ounj55R3R9y0_b5crp99YMFQ=w@mail.gmail.com>
References: <cover.1368128020.git.luto@amacapital.net> <CAH3drwa_ypKKqZ8eayeR4fA4Ounj55R3R9y0_b5crp99YMFQ=w@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 9 May 2013 18:21:33 -0700
Message-ID: <CALCETrUWZmcOv6WmpdUCqb-xwH9ZLrrXffv96j6hguV08OGtkQ@mail.gmail.com>
Subject: Re: [RFC/PATCH v2 0/8] Clean up write-combining MTRR addition
To: Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 9, 2013 at 4:44 PM, Jerome Glisse <j.glisse@gmail.com> wrote:
> On Thu, May 9, 2013 at 3:46 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> A fair number of drivers (mostly graphics) add write-combining MTRRs.
>> Most ignore errors and most add the MTRR even on PAT systems which don't
>> need to use MTRRs.
>
> This comment is wrong, as i said we need MTRR on PAT system for VRAM.

I didn't follow it last time.

 - If userspace is setting an MTRR directly, then it will work exactly
as before -- this patch has no effect on the userspace MTRR APIs.

 - If userspace uses the drm map interface with DRM_FRAME_BUFFER or
DRM_WRITE_COMBINING, there won't be an MTRR but the range will still
be WC.

 - If userspace uses GEM or TTM, then everything should still use WC
(TTM has explicit handling for this, which I presume is correct, and
i915, the major GEM user, already doesn't set an MTRR).

 - If userspace does not map the range, then either the kernel driver
is buggy or it doesn't matter because there's no map.

Is there a case I've missed?

--Andy
