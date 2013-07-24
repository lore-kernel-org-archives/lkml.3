Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407Ab3GXCvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 22:51:31 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:34358 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3GXCva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 22:51:30 -0400
MIME-Version: 1.0
In-Reply-To: <trinity-81535fa6-00e2-4f98-add9-0efa33cd768e-1374610106451@3capp-webde-bs40>
References: <trinity-81535fa6-00e2-4f98-add9-0efa33cd768e-1374610106451@3capp-webde-bs40>
Date: Tue, 23 Jul 2013 22:51:29 -0400
Message-ID: <CADnq5_P0zy3YuyFtyPMBYuhi5a+1f-V1mVhMohfxQtvX4DAhew@mail.gmail.com>
Subject: Re: PATCH - radeon_atombios_parse_power_table_4_5 - update of 23th
 july 2013
From: Alex Deucher <alexdeucher@gmail.com>
To: Michael Schuster <michaelschuster@email.de>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 4:08 PM, Michael Schuster
<michaelschuster@email.de> wrote:
> Dear Mr. Deucher,
>
> I received a reply from Mr. Airlie with your email as developer of the
> radeon kernel driver.
> I don't know if he send you the both emails and (patch) attachements, if
> not, please send me a short
> note than I would like to send you some information about me why I decided
> to try to develope a patch...

I only saw the message he cc'ed me on.  I haven't seen any of the
previous patches or emails.

> Attached is the actual version of the patche, changed some lines e.g. in
> atombios.c and radeon_pm.c (and
> corrected some off/on typos in evergreen.c) to start he asic with
> AUTO/BALANCED power mode using
> LOW clocks if some power modes are available.
> By now I unsuccesfully tried to autosuspend my muxless (was my real initial
> intention to develope the patch)
> from the start but did not find an succesful way to do it...

You can use vgaswitcheroo to disable the dGPU on your system if you
aren't using it.

> Hope he patch will do some good (almost byte-wise) parsing the
> PowerPlayTable used for
> radeon_atombios_parse_power_table_4_5 (and probably assembling missing power
> modes) for proper
> use in 'static mode' power management.

It's not entirely clear to me what your patch is doing.  I think you
might be overcomplicating things.  The power tables are designed with
the DPM (Dynamic Power Management) hardware in mind, so they don't
match perfectly to the the older static levels from older asics.  Now
that we have DPM support (as of 3.11), I'd like to eventually
deprecate the the old static profiles on asics that support DPM so I'd
prefer not make any major changes to that code to avoid any
regressions.

> By the way, the 'rom' file size from (debian 7, ext4) is 128k, 'rom' is not
> readable after echo 1 > rom
> may be it depends of my Samsung 700Z3A having an intel integrated graphics
> card and a (muxless)
> HD6490M as a second graphics card.

In hybrid laptops the vbios for the discrete card is stored in ACPI,
you can't just dump it from the pci rom.  You'd need to dump it from
the driver itself or provide an interface in the driver to access it
via debugfs or sysfs.

> Corrections und hints for learning C / doing kernel module programming the
> right/code safe way
> are highly appreciated, thanks a lot in advance, best wishes and regards,
>

Best advice is to look at other kernel drivers and see what they are
doing and how the code is written for pointers on style.

Alex

> Michael Schuster
>
> post scriptum: the patch is 66k plain text, I attached it because of the
> size, hoping
> this will be okay for you ... - M.
>
