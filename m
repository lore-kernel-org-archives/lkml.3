Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab3IQNEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 09:04:46 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:48236 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab3IQNEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 09:04:44 -0400
Message-ID: <1379423079.2218.2.camel@ThinkPad-X230.localdomain>
Subject: Re: [PATCH v2 3/3] ACPI / video: Do not register backlight if win8
 and native interface exists
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
Date: Tue, 17 Sep 2013 17:04:39 +0400
In-Reply-To: <1379409796-29350-4-git-send-email-aaron.lu@intel.com>
References: <1379409796-29350-1-git-send-email-aaron.lu@intel.com>
	 <1379409796-29350-4-git-send-email-aaron.lu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.91 (3.9.91-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-17 at 17:23 +0800, Aaron Lu wrote:
> According to Matthew Garrett, "Windows 8 leaves backlight control up
> to individual graphics drivers rather than making ACPI calls itself.
> There's plenty of evidence to suggest that the Intel driver for
> Windows 8 doesn't use the ACPI interface, including the fact that
> it's broken on a bunch of machines when the OS claims to support
> Windows 8.  The simplest thing to do appears to be to disable the
> ACPI backlight interface on these systems".
> 
> So for Win8 systems, if there is native backlight control interface
> registered by GPU driver, ACPI video will not register its own. For
> users who prefer to keep ACPI video's backlight interface, the existing
> kernel cmdline option acpi_backlight=video can be used.
> 
> This patch is an evolution from previous work done by Matthew Garrett,
> Chun-Yi Lee, Seth Forshee and Rafael J. Wysocki.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Tested-by: Igor Gnatenko <i.gnatenko.brain@gmail.com>
> ---
>  drivers/acpi/internal.h     |  5 ++---
>  drivers/acpi/video.c        | 27 +++++----------------------
>  drivers/acpi/video_detect.c | 14 ++++++++++++--
>  3 files changed, 19 insertions(+), 27 deletions(-)

-- 
Igor Gnatenko
Fedora release 20 (Heisenbug)
Linux 3.12.0-0.rc1.git0.1.fc20.x86_64

