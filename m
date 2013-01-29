Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab3A2KDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 05:03:55 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:49301 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab3A2KDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:03:51 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <s5hd2wos45v.wl%tiwai@suse.de>
References: <1359130915-30082-1-git-send-email-tiwai@suse.de>
	<1359130915-30082-2-git-send-email-tiwai@suse.de>
	<s5htxq0s882.wl%tiwai@suse.de>
	<20130129095350.GI14766@phenom.ffwll.local>
	<s5hd2wos45v.wl%tiwai@suse.de>
Date: Tue, 29 Jan 2013 11:03:49 +0100
X-Google-Sender-Auth: v8HOIObesPbfWmi7UDuuI_Nyxak
Message-ID: <CAKMK7uF5syHSeXKMkZo=ZfiJgqJrXadVx3d0yfKPZkjDP7hW4Q@mail.gmail.com>
Subject: Re: [PATCH] drm/cirrus: Add bpp option
From: Daniel Vetter <daniel@ffwll.ch>
To: Takashi Iwai <tiwai@suse.de>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Bernhard Wiedemann <bwiedemann@suse.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 10:57 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Tue, 29 Jan 2013 10:53:50 +0100,
> Daniel Vetter wrote:
>>
>> On Tue, Jan 29, 2013 at 09:29:17AM +0100, Takashi Iwai wrote:
>> > Add a new option, bpp, to specify the default bpp value.
>> >
>> > Signed-off-by: Takashi Iwai <tiwai@suse.de>
>> > ---
>> >
>> > This patch is applied on the top of previous two patches.
>> > I couldn't find an easy way to specify the default bpp, so I cooked
>> > the driver quickly.  If there is any other convenient way to achieve
>> > this, let me know...
>>
>> Well, you can specify the desired bpp with a full mode on the kernel
>> cmdline - the '-bpp' extension. Reading through the parser I think it
>> should work even with just the '-bpp' and not a full mode, but I haven't
>> tested. Look for cmdline_mode->bpp_specified in drm_fb_helper.c and the
>> relevant parsing code in drm_mode_parse_command_line_for_connector in
>> drm_modes.c
>>
>> If that doesn't work for you, I think it's better to extend/fix it than
>> add driver module options.
>
> Well, the fb can be set by that option, but the default modeset
> doesn't seem to honor it.  So if you start X modeset driver, it still
> takes what the driver sets as default.  That was the problem I hit.

Oh, I've missed the preferred_bpp hint for the generic modesetting
driver. Can we fill that in by using the bpp parsed in the fb helper
somehow?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
