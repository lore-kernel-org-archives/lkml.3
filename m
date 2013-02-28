Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568Ab3B1RHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 12:07:08 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52795 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab3B1RHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 12:07:06 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130228111819.GF11892@cantiga.alporthouse.com>
References: <CA+icZUXG7WgRap2-oQGBr_s=QbE0QW6_zChDRqC-eEzrWR3Y5g@mail.gmail.com>
	<CA+icZUUP0hLjkTjsAGbhoT1QG55X2062G5KCCDsKkhDyM_SQEg@mail.gmail.com>
	<20130228111819.GF11892@cantiga.alporthouse.com>
Date: Thu, 28 Feb 2013 18:07:01 +0100
Message-ID: <CA+icZUU1ckwT8HiyYP=aT+57gBOu7ZVDNC=as6yzAG=Xpma5AQ@mail.gmail.com>
Subject: Re: [git pull] drm merge for 3.9-rc1
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Sedat Dilek <sedat.dilek@gmail.com>, Dave Airlie <airlied@gmail.com>,
        DRI <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 12:18 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Thu, Feb 28, 2013 at 12:06:28AM +0100, Sedat Dilek wrote:
>> On Wed, Feb 27, 2013 at 11:36 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> > Hi,
>> >
>> > I am seeing this also on Linux-Next.
>> >
>> > /var/log/kern.log:Feb 27 22:52:35 fambox kernel: [   28.202381]
>> > [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not signal timeout
>> > (has irq: 1)!
>> > /var/log/kern.log:Feb 27 22:52:35 fambox kernel: [   28.210588]
>> > [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not signal timeout
>> > (has irq: 1)!
>> >
>> > /var/log/kern.log.1:Feb 22 07:36:04 fambox kernel: [   27.408280]
>> > [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not signal timeout
>> > (has irq: 1)!
>> >
>> > This seems to be hard reproducible...
>> > Laptop-LCD... Sandybridge Mobile-GT2.
>> >
>> > Is there a way to force the error?
>> >
>> > Possible patch see [1].
>> >
>> > - Sedat -
>> >
>> > [1] https://patchwork.kernel.org/patch/2192721/
>
> That was:
>
> +       if (!done) {
> +               status = I915_READ_NOTRACE(ch_ctl);
> +               DRM_ERROR("dp aux hw did not signal timeout (has irq:
> %i), status=%08x!\n",
> +                         has_aux_irq, status);
> +       }
>
> You applied
>
> +       if (!done) {
> +               status = I915_READ_NOTRACE(ch_ctl);
> +               DRM_ERROR("dp aux hw did not signal timeout (has irq:
> %i), status=%08x!\n",
> +                         has_aux_irq, status);
> +       {
>
> That second '{' is the source of the compile error.

Schei**e, OK I try with a v2.

A hint how to force the error?

- Sedat -

> -Chris
>
> --
> Chris Wilson, Intel Open Source Technology Centre
