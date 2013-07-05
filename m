Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab3GENJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 09:09:44 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:40574 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3GENJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 09:09:43 -0400
MIME-Version: 1.0
In-Reply-To: <51D5B560.8050504@zytor.com>
References: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
	<51D5B560.8050504@zytor.com>
Date: Fri, 5 Jul 2013 15:09:42 +0200
Message-ID: <CANq1E4SZPhzYKUi-VRQon90R8wC9wRncN7ah60CqwwAL-x6EHQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/14] Platform Framebuffers and SimpleDRM
From: David Herrmann <dh.herrmann@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter Jones <pjones@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Jul 4, 2013 at 7:48 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/04/2013 05:25 AM, David Herrmann wrote:
>>
>>   - What FB formats are common on x86 that we should add to
>> SIMPLEFB_FORMATS?
>>     (other than ARGB/XRGB32)
>
>
> The common pixel formats on x86 are:
>
> - Palettized 4-bit planar (bigendian, i.e. MSB to the left)
> - Palettized 8-bit packed (one byte per pixel)

Unlikely to be supported with DRM. But if users want it, we can always
add a shadow-buffer and advertise it as RGB332 or alike. Otherwise,
they have to use fbdev as usual, which sounds reasonable to me.

> - 16-bit RGB555 (16-bit littleendian words with R=14:10, G=9:5, B=4:0)

DRM_FORMAT_XRGB1555

> - 16-bit RGB565 (16-bit littleendian words with R=15:11, G=10:5, B=4:0)

DRM_FORMAT_RGB565

> - 24-bit RGB888 in littleendian order (first byte in memory is B,
>   second is G, third is R)

DRM_FORMAT_RGB888

> - 32-bit ARGB8888 (first byte in memory is B, second G, third R, fourth
>   unused in the framebuffer proper)

DRM_FORMAT_ARGB8888

> - 32-bit RGB10:10:10 (I *believe* 32-bit littleendian words with
>   R=29:20, G=19:10, B=9:0)

DRM_FORMAT_XRGB2101010

Thanks for the hints, I will add these to patch #5.
David
