Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964798Ab3CNQ5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 12:57:36 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:42961 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab3CNQ5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 12:57:34 -0400
MIME-Version: 1.0
X-Originating-IP: [67.232.160.146]
In-Reply-To: <20130313202858.GD1896@bremse>
References: <20130312003145.GA28993@www.outflux.net>
	<20130312090746.GD31324@cantiga.alporthouse.com>
	<20130313202858.GD1896@bremse>
Date: Thu, 14 Mar 2013 17:57:31 +0100
Message-ID: <CAKMK7uEDjtECnAO1v38KMDuB7kd=DthiZRvQdto7+HJ19tWkEw@mail.gmail.com>
Subject: Re: [PATCH v3] drm/i915: bounds check execbuffer relocation count
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Julien Tinnes <jln@google.com>,
        marcheu@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 9:28 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Tue, Mar 12, 2013 at 09:07:46AM +0000, Chris Wilson wrote:
>> On Mon, Mar 11, 2013 at 05:31:45PM -0700, Kees Cook wrote:
>> > It is possible to wrap the counter used to allocate the buffer for
>> > relocation copies. This could lead to heap writing overflows.
>> >
>> > CVE-2013-0913
>> >
>> > v3: collapse test, improve comment
>> > v2: move check into validate_exec_list
>> >
>> > Signed-off-by: Kees Cook <keescook@chromium.org>
>> > Reported-by: Pinkie Pie
>> > Cc: stable@vger.kernel.org
>>
>> Looks good to me. The only bikeshed that remains is whether we should
>> just collapse the two variables into one, but the current 'max - count'
>> is more idiomatic and so preferrable.
>> Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
>
> Picked up for -fixes, thanks for the patch.

I've forgotten to dump my wishlist: Can I have an i-g-t for this? For
this bug here specifically an execbuf with just one buffer with too
many relocs plus another execbuf with two buffers with relocation so
that the 2nd relocation list will overflow should be sufficient.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
