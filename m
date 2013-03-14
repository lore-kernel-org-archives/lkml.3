Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab3CNTcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 15:32:04 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:50542 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab3CNTcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 15:32:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAKMK7uEDjtECnAO1v38KMDuB7kd=DthiZRvQdto7+HJ19tWkEw@mail.gmail.com>
References: <20130312003145.GA28993@www.outflux.net>
	<20130312090746.GD31324@cantiga.alporthouse.com>
	<20130313202858.GD1896@bremse>
	<CAKMK7uEDjtECnAO1v38KMDuB7kd=DthiZRvQdto7+HJ19tWkEw@mail.gmail.com>
Date: Thu, 14 Mar 2013 12:32:00 -0700
X-Google-Sender-Auth: ykAhwkprpXJ8HfR2U_2EoBB7v-c
Message-ID: <CAGXu5j+Y9Onie1bC5aW-GUqYKCbLe=Zxx3e+74FmKCE237_mig@mail.gmail.com>
Subject: Re: [PATCH v3] drm/i915: bounds check execbuffer relocation count
From: Kees Cook <keescook@chromium.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Julien Tinnes <jln@google.com>, marcheu@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 9:57 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> On Wed, Mar 13, 2013 at 9:28 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
>> On Tue, Mar 12, 2013 at 09:07:46AM +0000, Chris Wilson wrote:
>>> On Mon, Mar 11, 2013 at 05:31:45PM -0700, Kees Cook wrote:
>>> > It is possible to wrap the counter used to allocate the buffer for
>>> > relocation copies. This could lead to heap writing overflows.
>>> >
>>> > CVE-2013-0913
>>> >
>>> > v3: collapse test, improve comment
>>> > v2: move check into validate_exec_list
>>> >
>>> > Signed-off-by: Kees Cook <keescook@chromium.org>
>>> > Reported-by: Pinkie Pie
>>> > Cc: stable@vger.kernel.org
>>>
>>> Looks good to me. The only bikeshed that remains is whether we should
>>> just collapse the two variables into one, but the current 'max - count'
>>> is more idiomatic and so preferrable.
>>> Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
>>
>> Picked up for -fixes, thanks for the patch.
>
> I've forgotten to dump my wishlist: Can I have an i-g-t for this? For
> this bug here specifically an execbuf with just one buffer with too
> many relocs plus another execbuf with two buffers with relocation so
> that the 2nd relocation list will overflow should be sufficient.

Sure thing. Where do these live? (Or what docs should I read for
this?) I'm assuming i-g-t means "intel graphics test"? :)

-Kees

-- 
Kees Cook
Chrome OS Security
