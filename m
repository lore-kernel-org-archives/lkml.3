Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab3IRGa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 02:30:26 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:39088 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab3IRGaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 02:30:24 -0400
Message-ID: <1379485819.2294.1.camel@ThinkPad-X230.localdomain>
Subject: Re: [PATCH v2 0/3] Fix Win8 backlight issue
From: Igor Gnatenko <i.gnatenko.brain@gmail.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Jani Nikula <jani.nikula@linux.intel.com>
Date: Wed, 18 Sep 2013 10:30:19 +0400
In-Reply-To: <5238FBF5.8080405@intel.com>
References: <1379409796-29350-1-git-send-email-aaron.lu@intel.com>
	 <1379424853.3348.1.camel@ThinkPad-X230.localdomain>
	 <5238FBF5.8080405@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.91 (3.9.91-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 09:03 +0800, Aaron Lu wrote:
> On 09/17/2013 09:34 PM, Igor Gnatenko wrote:
> > On Tue, 2013-09-17 at 17:23 +0800, Aaron Lu wrote:
> >> v1 has the subject of "Rework ACPI video driver" and is posted here:
> >> http://lkml.org/lkml/2013/9/9/74
> >> Since the objective is really to fix Win8 backlight issues, I changed
> >> the subject in this version, sorry about that.
> >>
> >> This patchset has three patches, the first introduced a new API named
> >> backlight_device_registered in backlight layer that can be used for
> >> backlight interface provider module to check if a specific type backlight
> >> interface has been registered, see changelog for patch 1/3 for details.
> >> Then patch 2/3 does the cleanup to sepeate the backlight control and
> >> event delivery functionality in the ACPI video module and patch 3/3
> >> solves some Win8 backlight control problems by avoiding register ACPI
> >> video's backlight interface if:
> >> 1 Kernel cmdline option acpi_backlight=video is not given;
> >> 2 This is a Win8 system;
> >> 3 Native backlight control interface exists.
> >>
> >> Technically, patch 2/3 is not required to fix the issue here. So if you
> >> think it is not necessary, I can remove it from the series.
> >>
> >> Apply on top of v3.12-rc1.
> >>
> >> Aaron Lu (3):
> >>   backlight: introduce backlight_device_registered
> >>   ACPI / video: seperate backlight control and event interface
> >>   ACPI / video: Do not register backlight if win8 and native interface
> >>     exists
> >>
> >>  drivers/acpi/internal.h             |   5 +-
> >>  drivers/acpi/video.c                | 442 ++++++++++++++++++++----------------
> >>  drivers/acpi/video_detect.c         |  14 +-
> >>  drivers/video/backlight/backlight.c |  31 +++
> >>  include/acpi/video.h                |   2 +
> >>  include/linux/backlight.h           |   4 +
> >>  6 files changed, 300 insertions(+), 198 deletions(-)
> >>
> > 
> > Aaron, how about fix indicator on ThinkPads ?
> 
> Can you please describe the problem in detail, is it that when you
> adjust brightness level through hotkey, there is no GUI indication?
> Thanks.
> 
> -Aaron

Yes. On my ThinkPad X230 I pressing backlight hotkeys. Actually
brightnes changing, but have no indicator in GUI.

-- 
Igor Gnatenko
Fedora release 20 (Heisenbug)
Linux 3.11.1-300.fc20.x86_64

