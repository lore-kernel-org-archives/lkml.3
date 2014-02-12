Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaBLVyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 16:54:40 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52584 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaBLVyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:54:38 -0500
MIME-Version: 1.0
In-Reply-To: <3619654.tQqiI1EfTB@wuerfel>
References: <1392122211-11422-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<20140211180845.GG841@joshc.qualcomm.com>
	<CAMuHMdVkPLe5986hYPApoQr7oJSb6U2P71=nP+9mtvtaskdHXg@mail.gmail.com>
	<3619654.tQqiI1EfTB@wuerfel>
Date: Wed, 12 Feb 2014 22:54:37 +0100
X-Google-Sender-Auth: wIjYNNvIqTbqKRI4TiuYnaHeLHI
Message-ID: <CAMuHMdVOkUMxEkUK70Y=Y126XmqgKMpyqmGRG5us7vZPhP8WNw@mail.gmail.com>
Subject: Re: [PATCH] of: Turn of_match_node into a static inline when
 CONFIG_OF isn't set
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Josh Cartwright <joshc@codeaurora.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 9:06 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 11 February 2014 19:29:19 Geert Uytterhoeven wrote:
>> On Tue, Feb 11, 2014 at 7:08 PM, Josh Cartwright <joshc@codeaurora.org> wrote:
>> Ideally, all xxx_device_id look like
>>
>>     struct xxx_device_id {
>>             ... /* bus-specific ID information */
>>             kernel_ulong_t driver_data;
>>     };
>>
>> This may be formalized in some way, using a base class, but thay may
>> require reordering the fields, like:
>>
>>     struct base_device_id {
>>             kernel_ulong_t driver_data;
>>             long id[0];
>>     };
>>
>
> You can't reorder the fields because they are shared with user
> space in form of the module-init-tools.

Sure, that's part of the ABI.

But that doesn't mean we can't change the ID as stored in the platform_device.
Many drivers don't want to know the ID, only the driver_data part.
Having that in a uniform way across the different ID types would help.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
