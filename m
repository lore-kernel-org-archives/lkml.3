Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab3CQVnA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 17:43:00 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:43060 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab3CQVnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 17:43:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130317214049.GB26102@cantiga.alporthouse.com>
References: <CA+ydwtpuBvbwxbt-tdgPUvj1EU7itmCHo_2B3w13HkD5+jWKow@mail.gmail.com>
	<1363265997-29023-1-git-send-email-chris@chris-wilson.co.uk>
	<20130315045004.GA14747@bwidawsk.net>
	<20130315082403.GA29916@cantiga.alporthouse.com>
	<20130315163606.GA17773@bwidawsk.net>
	<20130315220619.GA17405@cantiga.alporthouse.com>
	<20130315234942.GB715@bwidawsk.net>
	<20130316101920.GB17405@cantiga.alporthouse.com>
	<CAKMK7uFiMLcE_TYj5=sKZsVAcCnWSmg49qPrxjswH2s3J5byOg@mail.gmail.com>
	<20130317214049.GB26102@cantiga.alporthouse.com>
Date: Mon, 18 Mar 2013 07:42:58 +1000
Message-ID: <CAPM=9txw7pPT195p1nJrr5=TvTBGsd6G+a7N5C+fxQgP0Eof3w@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Sanity check incoming ioctl data
 for a NULL pointer
From: Dave Airlie <airlied@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Widawsky <ben@bwidawsk.net>, Tommi Rantala <tt.rantala@gmail.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 7:40 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Sun, Mar 17, 2013 at 08:50:03PM +0100, Daniel Vetter wrote:
>> On Sat, Mar 16, 2013 at 11:19 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> > If *userspace* doesn't request either IOC_IN | IOC_OUT in their ioctl
>> > command (which are seperate from the ioctl number), then kdata is set to
>> > NULL.
>>
>> Doesn't that mean that we need these checks everywhere? Or at least a
>> fixup in drm core proper?
>
> That's my conclusion. We either add a flag to ask drm_ioctl to prevent
> passing NULL pointers (as the existing behaviour may be useful
> somewhere, and I have not checked all callees) or saturate our callbacks
> with NULL checks.

Do we have the kernel's expected IOC_IN/IOC_OUT flags at that point as well?

we could check them and block NULL in that case.

Dave.
