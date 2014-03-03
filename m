Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbaCCK3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 05:29:17 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:36771 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbaCCK3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 05:29:15 -0500
MIME-Version: 1.0
In-Reply-To: <53145591.4070004@ti.com>
References: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
	<53145591.4070004@ti.com>
Date: Mon, 3 Mar 2014 11:29:14 +0100
Message-ID: <CANq1E4QJqB0CSNeSh2jsp90ZtcLwFwfSG=qjodSLdV_aGbL3BQ@mail.gmail.com>
Subject: Re: [PATCH 00/11] SimpleDRM & Sysfb
From: David Herrmann <dh.herrmann@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tom Gundersen <teg@jklm.no>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Mar 3, 2014 at 11:12 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> Hi,
>
> On 23/01/14 16:14, David Herrmann wrote:
>> Hi
>>
>> Another round of SimpleDRM patches. I somehow lost track of the last ones and as
>> this is a major rewrite, I'll just start at v1 again.
>>
>> Some comments up-front:
>>
>>  - @Ingo: Patch #1 and #2 are unchanged from the previous ML discussions. I
>>    included them in this series as the other patches depend on them. Could you
>>    pick them up for the x86 tree? The other 9 patches won't make it in 3.14 so
>>    no reason to put them through the DRM tree.
>>    All mentioned issues should be addressed. If there's still sth missing,
>>    please let me know.
>>
>>  - The DRM patches depend on my "DRM Anonymous Inode" patches. But it should be
>>    trivial to apply them on drm-next (I think only one line needs to be changed:
>>    i_mapping => dev_mapping).
>>
>>  - I tested the SimpleDRM fbdev fallback with linux-console+Xorg and it works
>>    fine. The DRM backend is only tested with some DRM tests I have locally. I
>>    have no idea how to make Xorg pick up a specific /dev/dri/card0 card. It
>>    always tells me "no screens found" (as the underlying device is not marked as
>>    boot_vga..). If someone knows how to tell Xorg to use card0, I'd gladly test
>>    this. But I'm no longer used to writing xorg.confs..
>>
>>
>> This series introduces two new concepts: sysfb and SimpleDRM
>> Sysfb is just a generalization of the x86-sysfb concept. It allows to register
>> firmware-framebuffers with the system as platform-devices. This way, drivers can
>> properly bind to these devices and we prevent multiple drivers from accessing
>> the same firmware-framebuffer.
>> Sysfb also provides hooks to get a safe handover to real hw-drivers (like i915).
>> Please see the "video: sysfb: add generic firmware-fb interface" patch for a
>> thorough description of the API. This patch also adds a rather verbose
>> documentation of all known firmware-fb facilities.
>>
>> As second part, this series introduces SimpleDRM. It's a very basic DRM driver
>> that can replace efifb, vesafb, simplefb and friends. It's 100% compatible to
>> the "udl" DRM driver, so user-space like xf86-video-modesetting can pick them up
>> just fine. User-space that cannot deal with drmModeDirtyFB() (like weston and
>> friends) currently cannot use SimpleDRM. However, that's also true for all other
>> DRM drivers which provide shadow framebuffers. We could provide something like
>> FB-DEFIO, but that's just useless overhead to paper of lazy user-space.
>>
>> I have tested this with all hardware that I have at home, with a lot hand-over
>> combinations (with/without SYSFB, with efifb/vesafb/simplefb, with SimpleDRM,
>> ...) and all worked great so far.
>
> What's the status with this one? Headed for 3.15?
>
> Are the SimpleDRM and sysfb linked somehow? (I.e. do they need to be in
> the same series?)
>
> And jfyi, the drivers/video/ changes will conflict with the
> drivers/video/ directory reorganization series, which may be merged for
> 3.15.

If simpledrm is included, then the series needs to be applied as a
whole. As Dave considered merging this for 3.15, I'd appreciate it if
you could ACK the fbdev related patches (they're really small!):
  fbdev: efifb: add dev->remove() callback
  fbdev: vesafb: add dev->remove() callback

Thanks
David
