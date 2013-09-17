Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab3IQNEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 09:04:21 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:33109 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab3IQNEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 09:04:16 -0400
Message-ID: <1379423051.2218.1.camel@ThinkPad-X230.localdomain>
Subject: Re: [PATCH v2 2/3] ACPI / video: seperate backlight control and
 event interface
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
Date: Tue, 17 Sep 2013 17:04:11 +0400
In-Reply-To: <1379409796-29350-3-git-send-email-aaron.lu@intel.com>
References: <1379409796-29350-1-git-send-email-aaron.lu@intel.com>
	 <1379409796-29350-3-git-send-email-aaron.lu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.91 (3.9.91-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-17 at 17:23 +0800, Aaron Lu wrote:
> The backlight control and event delivery functionality provided by ACPI
> video module is mixed together and registered all during video device
> enumeration time. As a result, the two functionality are also removed
> together on module unload time or by the acpi_video_unregister function.
> The two functionalities are actually independent and one may be useful
> while the other one may be broken, so it is desirable to seperate the
> two functionalities such that it is clear and easy to disable one
> functionality without affecting the other one.
> 
> APIs to selectively remove backlight control interface and/or event
> delivery functionality can be easily added once needed.
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
Linux 3.12.0-0.rc1.git0.1.fc20.x86_64

