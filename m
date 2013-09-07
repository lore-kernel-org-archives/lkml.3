Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750878Ab3IGXXY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 19:23:24 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:34944 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab3IGXXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 19:23:21 -0400
MIME-Version: 1.0
X-Originating-IP: [89.2.206.189]
In-Reply-To: <CAG-2HqXrpmZCsqXTG7pE9rtgPVrtvkU8gDxngGMtRjkoyqBMHA@mail.gmail.com>
References: <CAG-2HqVruXZxO1xLvYeAPa1RYmy044UiBXFLAtX5WcHVQVAtfA@mail.gmail.com>
 <CANq1E4RAoLo2=fdZ4SCAnOtbCuJkAAf-BOfUFuK5S+gijpS8ng@mail.gmail.com>
 <CAG-2HqVpAGOgvYKAsOCAac5F4SHB8nEtKtyTor2TYqp_fi7S7w@mail.gmail.com>
 <CANq1E4QPMKvDu5wA9meSt6hKRA7yTA1RhGY6NsSCMTBFmR5f0w@mail.gmail.com>
 <CANq1E4QYrQ-YcL9eGAA4LUozVnPaDNisVex8eMe+Xpj8TaWdeA@mail.gmail.com> <CAG-2HqXrpmZCsqXTG7pE9rtgPVrtvkU8gDxngGMtRjkoyqBMHA@mail.gmail.com>
From: Tom Gundersen <teg@jklm.no>
Date: Sun, 8 Sep 2013 01:22:59 +0200
Message-ID: <CAG-2HqUG=Ocd6qZuy6LYRA49NvyKnguSdnpDgX1Br17SWvkS1A@mail.gmail.com>
Subject: Re: [REGRESSION] v3.12-rc1: i915_driver_load oopses when sysfb enabled
To: David Herrmann <dh.herrmann@gmail.com>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sat, Sep 7, 2013 at 11:57 PM, Tom Gundersen <teg@jklm.no> wrote:
> On Sat, Sep 7, 2013 at 4:30 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
>> Attached are two patches. The first one should fix this issue, the
>> second one is the rebased ioremap_wc() patch from the other thread.
>>
>> Does this fix the issue (and the speed-problems)?
>
> Sadly, no. I added a few printk's to verify that the function you
> added is called (it is), but still the same oops.

A few more datapoints:

Triggers:
X86_SYSFB=y and FB_SIMPLE=n (so no fbdev until i915 is loaded)
X86_SYSFB=y and FB_SIMPLE=y

Does not trigger:
X86_SYSFB=y, FB_EFI=yes, and without the overflow fix (i.e., so we
fall back to efifb)
X86_SYSFB=n and FB_EFI=y
X86_SYSFB=n and FB_EFI=n (so no fbdev until i915 is loaded)

Does this make any sense?

Cheers,

Tom
