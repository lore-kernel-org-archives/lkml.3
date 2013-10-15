Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933878Ab3JOXV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 19:21:58 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58907 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933667Ab3JOXVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 19:21:55 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Aaron Lu <aaron.lu@intel.com>
Cc: linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Ben Jencks <ben@bjencks.net>, Steven Newbury <steve@snewbury.org.uk>,
        James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Joerg Platte <jplatte@naasa.net>, Kalle Valo <kvalo@adurom.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Mike Galbraith <bitbucket@online.de>,
        platform-driver-x86@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH v5 0/4] Fix Win8 backlight issue
Date: Wed, 16 Oct 2013 01:33:44 +0200
Message-ID: <2140073.U60XyxRqVZ@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1381498066-16011-1-git-send-email-aaron.lu@intel.com>
References: <1381498066-16011-1-git-send-email-aaron.lu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 11, 2013 09:27:42 PM Aaron Lu wrote:
> v5:
> 1 Introduce video.use_native_backlight module parameter and set its
>   value to false by default as suggested by Rafael. For Win8 systems
>   which have broken ACPI video backlight control, the parameter can be
>   set to 1 in kernel cmdline to skip registering ACPI video's backlight
>   interface. Due to this change, the acpi_video_verify_backlight_support
>   is moved from video_detect.c to video.c - patch 3/4;
> 2 Rename bd_list_head and bd_list_mutex in backlight.c to
>   backlight_dev_list and backlight_dev_list_mutex as suggested by Rafael
>   - patch 1/4.
> 
> v4:
> Remove decleration and stub for acpi_video_unregister_backlight in
> video.h of patch 2/4 since that function doesn't exist anymore in v3.
> 
> v3:
> 1 Add a new patch 4/4 to fix some problems in thinkpad-acpi module;
> 2 Remove unnecessary function acpi_video_unregister_backlight introduced
>   in patch 2/4 as pointed out by Jani Nikula.
> 
> v2:
> v1 has the subject of "Rework ACPI video driver" and is posted here:
> http://lkml.org/lkml/2013/9/9/74
> Since the objective is really to fix Win8 backlight issues, I changed
> the subject in this version, sorry about that.
> 
> This patchset has four patches, the first introduced a new API named
> backlight_device_registered in backlight layer that can be used for
> backlight interface provider module to check if a specific type backlight
> interface has been registered, see changelog for patch 1/4 for details.
> Then patch 2/4 does the cleanup to sepeate the backlight control and
> event delivery functionality in the ACPI video module and patch 3/4
> solves some Win8 backlight control problems by avoiding register ACPI
> video's backlight interface if:
> 1 Kernel cmdline option acpi_backlight=video is not given;
> 2 This is a Win8 system;
> 3 Native backlight control interface exists.
> Patch 4/4 fixes some problems in thinkpad-acpi module.
> 
> Technically, patch 2/4 is not required to fix the issue here. So if you
> think it is not necessary, I can remove it from the series.
> 
> Aaron Lu (4):
>   backlight: introduce backlight_device_registered
>   ACPI / video: seperate backlight control and event interface
>   ACPI / video: Do not register backlight if win8 and native interface
>     exists
>   thinkpad-acpi: fix handle locate for video and query of _BCL
> 
>  drivers/acpi/internal.h              |   4 +-
>  drivers/acpi/video.c                 | 457 ++++++++++++++++++++---------------
>  drivers/acpi/video_detect.c          |   4 +-
>  drivers/platform/x86/thinkpad_acpi.c |  31 ++-
>  drivers/video/backlight/backlight.c  |  31 +++
>  include/linux/backlight.h            |   4 +
>  6 files changed, 326 insertions(+), 205 deletions(-)

I've added this series to my queue for 3.13.

Since the next step will be to introduce a list of systems that need
video.use_native_backlight=1 *and* don't break in that configuration, I don't
see much point adding another Kconfig option for the default.

Hopefully, in the future we'll be able to fix the problems causing
video.use_native_backlight=1 to fail of the systems where it fails and then
we'll be able to make that the default behavior and drop the option altogether.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
