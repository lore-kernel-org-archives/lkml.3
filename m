Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaCMIqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 04:46:21 -0400
Received: from shrek-s3.podlesie.net ([85.14.110.209]:36256 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaCMIqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 04:46:18 -0400
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Mar 2014 04:46:18 EDT
Date: Thu, 13 Mar 2014 09:38:39 +0100
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: antti.koskipaa@linux.intel.com, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: i915: black screen after boot on 915GM (Linux >= 3.4-rc1)
Message-ID: <20140313083839.GA2396@shrek.podlesie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The commit 3f2dc5ac05714711fc14f2bf0ee5e42d5c08c581 (drm/i915: Fix 915GM
self-refresh enable/disable) causes strange regression on the HP Compaq
nc6120. During and after boot to framebuffer console with just LVDS
the screen is black (backlight on, but black). Starting a X server fixes
the problem. Connecting an external VGA monitor also fixes the problem.

Reverting this commit fixes the problem at least up to Linux 3.14.0-rc6.

I'm still using ACPI video problem workaround that effectively does:

 static int acpi_video_bus_start_devices(struct acpi_video_bus *video)
 {
- return acpi_video_bus_DOS(video, 0,
+ return acpi_video_bus_DOS(video, 3,
                            acpi_osi_is_win8() ? 1 : 0);
 }

in drivers/acpi/video.c.

I've added dmesgs from the last good commit and the bad commit at:
https://bugs.freedesktop.org/show_bug.cgi?id=76103

Thanks,
Krzysiek
