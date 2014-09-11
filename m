Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbaIKMtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:49:24 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:51054 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107AbaIKMs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:48:59 -0400
MIME-Version: 1.0
In-Reply-To: <1410381657.4117.3.camel@nebula.com>
References: <1410364463-12692-1-git-send-email-dh.herrmann@gmail.com>
	<1410381657.4117.3.camel@nebula.com>
Date: Thu, 11 Sep 2014 14:48:59 +0200
Message-ID: <CANq1E4S6rzDSXXTQws1nPiAXkRgLMbADJJTCoLjONLFiR6wP4g@mail.gmail.com>
Subject: Re: [PATCH RFC 0/4] Linking DRM Connectors to Backlight Devices
From: David Herrmann <dh.herrmann@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "cooloney@gmail.com" <cooloney@gmail.com>,
        "airlied@gmail.com" <airlied@gmail.com>,
        "ajax@redhat.com" <ajax@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Sep 10, 2014 at 10:40 PM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> On Wed, 2014-09-10 at 17:54 +0200, David Herrmann wrote:
>
>>  * User-space currently has a hard-time figuring out which backlight device to
>>    use, and which backlight device belongs to which display. So far, most
>>    systems only provide backlight-devices for internal displays, so figuring out
>>    the connection is easy, but that might change with more capable external
>>    connectors.
>
> The parent device of the backlight will be the correct display, if the
> kernel has a meaningful way to determine that. We could do a better job
> in the ACPI code than we currently do, but (unfortunately) that requires
> us to know the ACPI IDs that each GPU vendor uses.

We also probe ACPI devices independently of PCI devices (or other
buses). So the actual DRM device might be created much later than the
backlight, thus it cannot be a parent of the backlight. We can try to
find a common ancestor, though.

>> This series tries to solve this problem with a much simpler approach:
>> Instead of moving backlights into DRM, we simply link DRM properties to a
>> backlight device. That is, the kernel manages a link between a connector and a
>> backlight device (or n backlight devices) which can be modified by udev in case
>> the kernel got it wrong (we don't want huge board-fixup-tables in the kernel).
>> User-space can now use the simpl DRM API to manage backlights, and the kernel
>> does not need any special driver code to make it work.
>
> This doesn't really simplify userspace significantly - something's still
> going to have to make the same policy decision as we do right now, and
> the kernel isn't really the right place to do that.

This patch allows to add really simple udev rules that implement any
policy we want. This way, we can keep the policy in user-space, but at
the same time it's no longer part of the compositors. Instead, we have
an independent place (udev rules) where to write that policy and tell
the kernel. I think this is an improvement. But of course, the
unprivileged access is the much more compelling argument.

Thanks
David
