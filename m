Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab3GORJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:09:30 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:51435 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab3GORJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:09:28 -0400
MIME-Version: 1.0
In-Reply-To: <51E2FF42.2090507@gmail.com>
References: <1371923055-29623-1-git-send-email-prabhakar.csengg@gmail.com>
 <1371923055-29623-3-git-send-email-prabhakar.csengg@gmail.com>
 <51D05568.3090009@gmail.com> <CA+V-a8sW+D8trces5AXu__Lw9F7TO6fCcQW+LGZKRhA41uOEfw@mail.gmail.com>
 <51DF2BF6.30509@gmail.com> <CA+V-a8u0G6m+VoSc4FPmDxEYmE_vQaL7zu3fUFk3iVKnOywnRA@mail.gmail.com>
 <51E2FF42.2090507@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 15 Jul 2013 22:39:06 +0530
Message-ID: <CA+V-a8tCTVzyE0YWjYexuXMD1QYHJa-OTmwZq7rVpdfn-262iA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] media: i2c: tvp7002: add OF support
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

On Mon, Jul 15, 2013 at 1:12 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Prabhakar,
>
[Snip]
>> Something similar to fid_polarity.
>
>
> Then as I suggested earlier, let's just add 'sync-on-green-active' DT
> property for that. I wouldn't expect the DT properties to be directly
> replacing your driver platform_data members. Saying in the binding that
> this is a normal operation and that is an inverted one is not very useful
> in general, as you would need to dig in the binding's description what
> "normal" exactly means. sync-on-green-active = <1>; seems much more
> explicit than, e.g. sync-on-green-inverted. By looking at the
> sync-on-green-active property each device driver would determine whether
> it means normal or inverted operation for its device.
>
Ok so I'll add 'sync-on-green-active' property and parse it in
v4l2_of_parse_parallel_bus()
and add it as part of flags. and define the following flags in mediabus.h

V4L2_MBUS_VIDEO_SOG_ACTIVE_{HIGH,LOW}.

Hope you are OK with it.

--
Regards,
Prabhakar Lad
