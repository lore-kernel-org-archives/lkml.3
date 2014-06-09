Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972AbaFIWir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:38:47 -0400
Received: from service87.mimecast.com ([91.220.42.44]:41258 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932999AbaFIWig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:38:36 -0400
Date: Mon, 9 Jun 2014 23:38:31 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Inderpal Singh <inderpal.s@samsung.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        "olof@lixom.net" <olof@lixom.net>, Tushar Behera <trblinux@gmail.com>,
        Kevin Hilman <khilman@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: EXYNOS: mcpm: Don't rely on firmware's
 secondary_cpu_start
Message-ID: <20140609223831.GB16889@e102568-lin.cambridge.arm.com>
References: <1402090985-8061-1-git-send-email-dianders@chromium.org>
 <20140607181221.GB25068@e102568-lin.cambridge.arm.com>
 <CAD=FV=X17PeJ6JPE9Qyc1QT07AvA2PTE69Q87gz9a6MdUHgi4A@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAD=FV=X17PeJ6JPE9Qyc1QT07AvA2PTE69Q87gz9a6MdUHgi4A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 09 Jun 2014 22:38:27.0333 (UTC) FILETIME=[87C90350:01CF8433]
X-MC-Unique: 114060923383400901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 06:03:31PM +0100, Doug Anderson wrote:

[...]

> Cold boot and resume from suspend are detected via various special
> flags in various special locations.  Resume from suspend looks at
> INFORM1 (0x10048004) for flags.  This register is 0 during a cold boot
> and has special values set by the kernel at resume time.
> 
> It also looks as if some code looks at 0x10040900 (PMU_SPARE0) to help
> tell initial cold boot and secondary CPU bringup.

Ok, thanks a lot. It looks like firmware paths should be ready to
detect cold vs warm boot, and hopefully do not rely on a specific
MPIDR to come up first out of power states.

> > I am asking to check if on this platform CPUidle (where the notion of
> > primary CPU disappears) has a chance to run properly.
> 
> I believe it should be possible, but we don't have CPUidle implemented
> in our current system.  Abhilash may be able to comment more.

I am interested in more insights, that's very helpful thanks.

> > Probably CPUidle won't attain idle states where IRAM content is lost, but I
> > am still worried about the primary vs secondaries firmware boot behaviour.
> 
> I don't think iRAM can be turned off for CPUidle.

It might be added a system state but I doubt that too and if you are
relying on registers for jump addresses that's not even a problem in
the first place.

> > What happens on reboot from suspend to RAM (or to put it differently,
> > what does secure firmware do on reboot from suspend to RAM - in
> > particular how is the "jump" address to bootloader/kernel set ?)
> 
> Should be described above now.

Thank you very much.

Lorenzo

