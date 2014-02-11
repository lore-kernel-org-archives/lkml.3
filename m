Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaBKS3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:29:21 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:42329 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaBKS3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:29:20 -0500
MIME-Version: 1.0
In-Reply-To: <20140211180845.GG841@joshc.qualcomm.com>
References: <1392122211-11422-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<1596542.hkJp71u3OJ@avalon>
	<20140211164825.GC841@joshc.qualcomm.com>
	<6446980.WMjvBYStRY@avalon>
	<20140211180845.GG841@joshc.qualcomm.com>
Date: Tue, 11 Feb 2014 19:29:19 +0100
X-Google-Sender-Auth: uJtJ8Q-pAyJ8kzT-GVuMC_9fqUo
Message-ID: <CAMuHMdVkPLe5986hYPApoQr7oJSb6U2P71=nP+9mtvtaskdHXg@mail.gmail.com>
Subject: Re: [PATCH] of: Turn of_match_node into a static inline when
 CONFIG_OF isn't set
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 7:08 PM, Josh Cartwright <joshc@codeaurora.org> wrote:
> It sure would be convenient if platform_device had a 'const struct
> of_device_id *of_id_entry' member similar to the existing struct
> platform_device_id one, that was set up during platform device matching.
> Most platform_driver users of of_match_node() would simply go away.

Can't the entry be shared for both platform_device_id and of_device_id?
Only one of them can be valid at the same time, right?

Ideally, all xxx_device_id look like

    struct xxx_device_id {
            ... /* bus-specific ID information */
            kernel_ulong_t driver_data;
    };

This may be formalized in some way, using a base class, but thay may
require reordering the fields, like:

    struct base_device_id {
            kernel_ulong_t driver_data;
            long id[0];
    };

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
