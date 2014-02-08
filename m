Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaBHUEy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 15:04:54 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:57184 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaBHUEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 15:04:52 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Feb 2014 15:04:51 EST
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <1391886379.2669.11.camel@x41>
References: <1391886379.2669.11.camel@x41>
Date: Sat, 8 Feb 2014 20:59:48 +0100
Message-ID: <CAKMK7uE6Gaq-ghgWJ+6Qyn7hrGzAMOHyGT9KQQJ+ij7omPV2Ew@mail.gmail.com>
Subject: Re: agp/intel: can't ioremap flush page - no chipset flushing
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, David Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 8, 2014 at 8:06 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> 0) Booting v3.14-rc1 on an (outdated) ThinkPad X41 triggers a kernel
> error:
>     pci 0000:00:02.0: can't ioremap flush page - no chipset flushing
>
> That is this pci device:
>      lspci | grep 00:02.0
>      00:02.0 VGA compatible controller: Intel Corporation Mobile 915GM/GMS/910GML Express Graphics Controller (rev 03)
>
> I can't remember seeing that error before. It is apparently printed by
> drivers/char/agp/intel-gtt.c. (So I've sent this message to the people
> touching that file between v3.13 and v3.14-rc1. No, I haven't yet
> pinpointed a specific commit.)
>
> 1) What am I supposed to do to make this error go away?

Hm, if this is really a regression between 3.13 and 3.14-rc1 then I
don't see any quick candidates - relevant functions in intel-gtt.c
seem unchanged.

So probably a bisect is what we need here. Note that this could also
be due to resource handling changes in the driver/pci core, so you
can't restrict the bisect really. But before going down this route it
would be worth to check out the resource allocations of both kernels.
Can you please attach /proc/iomem for both 3.13 and 3.14-rc1

Adding more mailing lists.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
