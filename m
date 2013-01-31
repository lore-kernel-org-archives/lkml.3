Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab3AaEYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 23:24:42 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:54281 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab3AaEYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 23:24:40 -0500
MIME-Version: 1.0
In-Reply-To: <5109EA2A.8020204@gmail.com>
References: <1359514939-15653-1-git-send-email-acourbot@nvidia.com>
 <1359514939-15653-2-git-send-email-acourbot@nvidia.com> <5108C9C1.1090707@gmail.com>
 <51098064.7030902@wwwdotorg.org> <5109EA2A.8020204@gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 31 Jan 2013 13:24:19 +0900
Message-ID: <CAAVeFuJf9Ww7g8Q9RAG9Na1SZq2-n2MMxcAEBek52ZVG7RpL7g@mail.gmail.com>
Subject: Re: [RFC 1/4] video: panel: add CLAA101WA01A panel support
To: Mark Zhang <nvmarkzhang@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 12:51 PM, Mark Zhang <nvmarkzhang@gmail.com> wrote:
>> DDC access is a property of the display controller, not the panel
>> itself. The panel might be hooked up to a display controller's DDC/I2C
>> channel as the target, but it isn't the host/controller of the DDC/I2C
>> channel. As such, placing the nvidia,ddc property into the display
>> controller node makes sense.
>>
>
> Yes, DC triggers the DDC access and is the host of the DDC/I2C channel.
> So I think it's reasonable to put nvidia,ddc property into the display
> controller node. But the video mode info in EDID which be fetched via
> DDC is the property of the panel, so this info should be provided by
> panel driver. Actually display controller cares about the video modes,
> not the way to get these info. So I think it's better to do the whole
> work like this:
>
> 1) display controller relied on CDF to call "display_entity_get_modes"
> 2) panel driver calls the function which is hooked to display controller
> to get the video modes via DDC.
> 3) if the video modes can't be fetched via DDC, panel driver provides
> the info(either by hard-coded or defined in DT) anyway

This would require a callback dedicated to this in display_entity and
would break its simple design.

> Just like I said above, display controller should not query DDC
> directly. Since CDF already defines these for us, display controller
> should call CDF's functions, like: display_entity_get_modes,
> display_entity_get_size... I think this is the key difference I wanna
> talk about. And also in this way, display controller doesn't need to
> care about this 2 steps logics, just call "display_entity_get_modes" is OK.

Well the fact is that it *is* the display controller that queries DDC
directly. The panel is just a bus here, and the EDID EEPROM could
perfectly work without it. If you model what you described with DT
nodes, I'm afraid you will end up with something both complex (with DC
node referencing panel node and back again for the EDID bus) and that
does not picture reality accurately.

Alex.
