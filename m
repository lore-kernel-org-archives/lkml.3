Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbaAWTJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:09:08 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:58633 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184AbaAWTJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:09:03 -0500
MIME-Version: 1.0
In-Reply-To: <20140123171436.GA27345@gmail.com>
References: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>
	<1390486503-1504-3-git-send-email-dh.herrmann@gmail.com>
	<20140123165115.GB23869@gmail.com>
	<CANq1E4QQE2qeEz1AaN1NO3p2TE006jHfz8uaJ_LLHptKdHecxQ@mail.gmail.com>
	<20140123171436.GA27345@gmail.com>
Date: Thu, 23 Jan 2014 20:09:03 +0100
Message-ID: <CANq1E4SyciabqonrFMRa8cMSDxkFuvfqexTBMxKPih+XreF_=A@mail.gmail.com>
Subject: Re: [PATCH 02/11] x86: sysfb: remove sysfb when probing real hw
From: David Herrmann <dh.herrmann@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tom Gundersen <teg@jklm.no>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Jan 23, 2014 at 6:14 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * David Herrmann <dh.herrmann@gmail.com> wrote:
>
>> >> +#ifdef CONFIG_X86_SYSFB
>> >> +#  include <asm/sysfb.h>
>> >> +#endif
>> >
>> > I guess a single space is sufficient?
>> >
>> > Better yet, I'd include sysfb.h unconditionally:
>>
>> Unconditionally won't work as only x86 has this header. [...]
>
> Well, in non-x86 code an #ifdef x86 looks ugly as well - but I guess
> better than not building.
>
>> [...] If there's a way to place a dummy into asm-generic which is
>> picked if arch/xy/include/asm/ doesn't have the header, let me know.
>
> Not that I know of.
>
>> But if I include it unconditionally without any fallback, this will
>> fail on non-x86. And adding the header to all archs seems overkill.
>
> So why not drop the x86-ism and rename it to CONFIG_PLATFORM_SYSFB?
> Some platforms configure it, some don't. Then the prototypes could
> move into include/linux/sysfb.h or so and would be platform agnostic.

This is almost exactly what patch #6 does. But it also adds ~400 lines
of kernel-doc and ~400 lines of Documentation/. Given your remarks, I
guess I will just split this patch into code and docs, so we can just
pick it up for stable in case patch #1 does not fix all issues.

Thanks
David
