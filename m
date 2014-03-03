Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbaCCLJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 06:09:56 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:50351 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbaCCLJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 06:09:55 -0500
MIME-Version: 1.0
In-Reply-To: <53145D42.9080806@ti.com>
References: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
	<53145591.4070004@ti.com>
	<CANq1E4QJqB0CSNeSh2jsp90ZtcLwFwfSG=qjodSLdV_aGbL3BQ@mail.gmail.com>
	<53145D42.9080806@ti.com>
Date: Mon, 3 Mar 2014 12:09:54 +0100
Message-ID: <CANq1E4QYuMsj3W80jiyOfeYr+Xm=J096idyvgCUpFhADWR1ZvA@mail.gmail.com>
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

On Mon, Mar 3, 2014 at 11:45 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 03/03/14 12:29, David Herrmann wrote:
>
>>> What's the status with this one? Headed for 3.15?
>>>
>>> Are the SimpleDRM and sysfb linked somehow? (I.e. do they need to be in
>>> the same series?)
>>>
>>> And jfyi, the drivers/video/ changes will conflict with the
>>> drivers/video/ directory reorganization series, which may be merged for
>>> 3.15.
>>
>> If simpledrm is included, then the series needs to be applied as a
>> whole. As Dave considered merging this for 3.15, I'd appreciate it if
>> you could ACK the fbdev related patches (they're really small!):
>>   fbdev: efifb: add dev->remove() callback
>>   fbdev: vesafb: add dev->remove() callback
>
> Those look fine.
>
> I'm not familiar with x86 fb, so I can't comment much to the series, but
> what worries me more is the "[PATCH 06/11] video: sysfb: add generic
> firmware-fb interface", which adds new stuff into drivers/video/. No
> problem as such, but as said, it'll conflict with the fbdev reorg patches.
>
> So, presuming nobody shoots down the fbdev reorg series, I'd like to
> have all fbdev patches going through the fbdev tree for 3.15, so that I
> can handle the (possibly messy) conflicts.
>
> What do you think, would it be possible to keep the sysfb stuff in
> arch/x86, and still be able to do the rest of the stuff here? And then
> move the sysfs from arch/x86 to drivers/video later?

I don't think there's any need for that. Linus does conflict
resolution all day long, so a short hint in Dave's pull-request (plus
an example merge) should be enough. Same is true for -next, I think.
And this is really just a mechanical thing, nothing hard to do. But of
course, it's your decision. However, keeping the code in x86 is the
wrong thing to do. As discussed with Ingo, the patch that extends
x86/sysfb is only provided for easier backporting. The followup patch
immediately removes it again and adds proper video/sysfb. I'd dislike
splitting these just to avoid merge conflicts. I can also maintain a
merge-fixup branch in my tree, if anyone wants that.

Thanks for your reviews of the fbdev stuff!
David
