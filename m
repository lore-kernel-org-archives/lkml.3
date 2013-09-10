Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab3IJFXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 01:23:49 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53068 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab3IJFXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 01:23:48 -0400
Message-ID: <1378790623.2160.2.camel@ThinkPad-X230.localdomain>
Subject: Re: [PATCH 1/2] ACPI / video: seperate backlight control and event
 interface
From: Igor Gnatenko <i.gnatenko.brain@gmail.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Lee Chun-Yi <jlee@novell.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date: Tue, 10 Sep 2013 09:23:43 +0400
In-Reply-To: <522D8991.5070707@intel.com>
References: <522D88C3.7000808@intel.com> <522D8991.5070707@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.91 (3.9.91-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2013-09-09 at 16:40 +0800, Aaron Lu wrote:
> The backlight control and event delivery functionality provided by ACPI
> video module is mixed together and registered all during video device
> enumeration time. As a result, the two functionality are also removed
> together on module unload time or by the acpi_video_unregister function.
> The two functionalities are actually independent and one may be useful
> while the other one may be broken, so it is desirable to seperate the
> two functionalities such that it is clear and easy to disable one
> functionality without affecting the other one. This patch does the
> seperation and as a result, a new video_bus_head list is introduced to
> store all registered video bus structure and a new function
> acpi_video_unregister_backlight is introduced to unregister backlight
> interfaces for all video devices belonging to stored video buses.
> 
> Currently, there is no need to unregister ACPI video's event delivery
> functionality alone so the function acpi_video_remove_notify_handler is
> not introduced, it can be easily added when needed.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Tested-by: Igor Gnatenko <i.gnatenko.brain@gmail.com>
> ---
>  drivers/acpi/video.c | 451 ++++++++++++++++++++++++++++++---------------------
>  include/acpi/video.h |   2 +
>  2 files changed, 264 insertions(+), 189 deletions(-)

-- 
Igor Gnatenko
Fedora release 20 (Heisenbug)
Linux 3.11.0-3.fc20.x86_64

-- 
Igor Gnatenko
Fedora release 20 (Heisenbug)
Linux 3.11.0-1.fc20.x86_64

